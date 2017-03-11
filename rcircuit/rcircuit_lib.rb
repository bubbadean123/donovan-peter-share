#Used for ports of devices
class Port 
  include Comparable
  # Initalizes a new TapeDrive object.
  def initialize(width=1)
    @width = width
    @callbacks = []
    @value = "X"*width
  end
  # Returns the current value of the port
  # @return [String]
  def value
    @value
  end
  # Sets the ports value
  # @param name [String] New value
  # @return [void]
  def value=(new_value)
    #set method
    if value.length != @width then
      raise ArgumentError, "New value is incorrect width"
    end
    @value = new_value
    #send new value to each listener
    @callbacks.each do |callback|
      callback.call(@value)
    end
  end
  # Adds a callback
  # @param name [Proc] Callback to add
  # @return [void]
  def add_callback(&callback)
    #add block to the list
    @callbacks.push(callback)
  end
  # Returns true if all bits are defined
  # @return [Boolean]
  def is_defined?()
    0...@width.each do |bit|
      if @value[bit] == 'X' || @value[bit] == 'Z' then
        return false
      end
    end
    return true
  end
  # Returns the numeric value of the port.
  # @return [Fixnum]
  def numeric_value()
    numval = 0
    bitvalue = 1
    0...@width.each do |bit|
      if @value[bit] == "1" then
        numval += bitvalue
      end
      bit_value = bitvalue * 2
    end
    return numval
  end  
  # Returns the width of the port.
  # @return [Fixnum]
  def width()
    @width
  end
  
  def &(other)
    return AndGate.new(self,other).output
  end
  
  def |(other)
    return OrGate.new(self,other).output
  end
  
  def +(other)
    adder=Adder.new(self,other)
    return adder.sum,adder.carry
  end
  
  def -(other)
    notb=NotGate.new(other)
    adder=Adder.new(self,notb.output,true)
    borrow=NotGate.new(adder.carry)
    return adder.sum,borrow.output
  end
  def !
    return NotGate.new(self).output
  end
   
  def [](index)
    if index.class==Fixnum
      port=Port.new()
    else
      port=Port.new(index.size)
    end
    self.add_callback { |value| port.value=value[index]}
    return port
  end
  
  def join(other,last=false)
    port=Port.new(self.width+other.width)
    def update_port(last,port,other)
      if last
         port.value=other.value+self.value
      else
        port.value=self.value+other.value
      end
    end
    self.add_callback {|value| update_port(last,port,other)}
    other.add_callback {|value| update_port(last,port,other)}
    return port
  end
  
  def <=>(other)
    return self.numeric_value<=>other.numeric_value
  end
end

class NotGate
  def initialize(*args)
    if args.length==0
      @width=1
      @output = Port.new(@width)
    elsif args[0].class==Fixnum
      @width=args.shift
      @output = Port.new(@width)
      set_input(args[0])
     else
      @width=args[0].width
      @output = Port.new(@width)
      set_input(args[0])
    end
  end
  
  def set_input(input_port)
    if input_port.width != @width then
      raise ArgumentError, "Incorrect port width"
    end 
    @input = input_port
    input_port.add_callback {|value| self.input_changed(value)}
    input_changed(input_port.value)
  end
  
  def output
    return @output
  end
  
  def input_changed(new_value)
    #called any time the input changes, or when input set
    #invert each bit in the input
    new_output = @output.value
    (0...@width).each do |bit|
      case new_value[bit]
      when "0"
        new_output[bit] = "1"
      when "1"
        new_output[bit] = "0"
      else
        new_output[bit] = "X"
      end
    end
    @output.value = new_output
  end
  
end

class AndGate
  def initialize(*args)
    @inputs = []
    if args.length==0
      @width=1
      @output = Port.new(@width)
    elsif args[0].class==Fixnum
      @width=args.shift
      @output = Port.new(@width)
      args.each do |input|
        add_input(input)
      end
     else
      @width=1
      @output = Port.new(@width)
      args.each do |input|
        add_input(input)
      end
    end
  end
  
  def output
    return @output
  end

  def add_input(input_port)
    if input_port.width != @width then
      raise ArgumentError, "Incorrect port width"
    end
    @inputs.push(input_port)
    input_port.add_callback {|value| self.input_changed(value)}
    input_changed(input_port.value)
  end

  def input_changed(new_value)
    #called any time an input changes, or when input added
    #for each bit loop through all inputs to see if all are True
    new_output = @output.value
    (0...@width).each do |bit|
      unknowns = false
      found_zero = false
      @inputs.each do |inp|
        case inp.value()[bit]
        when "0"
          found_zero = true
          break
        when "X"
          unknowns = true
        when "Z"
          unknowns = true
        end
      end
      if found_zero then
        new_output[bit] = "0"
      elsif unknowns 
        new_output[bit] = "X"
      else 
        new_output[bit] = "1"
      end
    end #end of loop through each bit
    @output.value=new_output
  end
end

class OrGate
  def initialize(*args)
    @inputs = []
    if args.length==0
      @width=1
      @output = Port.new(@width)
    elsif args[0].class==Fixnum
      @width=args.shift
      @output = Port.new(@width)
      args.each do |input|
        add_input(input)
      end
     else
      @width=args[0].width
      @output = Port.new(@width)
      args.each do |input|
        add_input(input)
      end
    end
  end

  def output
    return @output
  end

  def add_input(input_port)
    if input_port.width != @width then
      raise ArgumentError, "Incorrect port width"
    end
    @inputs.push(input_port)
    input_port.add_callback {|value| self.input_changed(value)}
    input_changed(input_port.value)
  end

  def input_changed(new_value)
    #called any time an input changes, or when input added
    #for each bit loop through all inputs to see if any are True
    new_output = @output.value
    (0...@width).each do |bit|
      unknowns = false
      found_one = false
      @inputs.each do |inp|
        case inp.value()[bit]
        when "1"
          found_one = true
          break
        when "X"
          unknowns = true
        when "Z"
          unknowns = true
        end
      end
      if found_one then
        new_output[bit] = "1"
      elsif unknowns
        new_output[bit] = "X"
      else
        new_output[bit] = "0"
      end
    end
    @output.value = new_output
  end
end

class Mux
  def initialize(data_width=1, select_width=1)
    @data_width = data_width
    @select_width = select_width
    @select = nil
    @inputs = [nil,] * (2**@select_width)
    @output = Port.new(@data_width)
  end

  def output
    return @output
  end
  
  def set_select(port)
    if port.width != @select_width then
      raise ArgumentError, "Incorrect port width"
    end
    @select = port
    port.add_callback {|value| self.select_changed(value)}
    select_changed(port.value)
  end

  def set_input(port, channel)
    if port.width != @select_width then
      raise ArgumentError, "Incorrect port width"
    end
    @inputs[channel] = port
    port.add_callback {|value| self.input_changed(channel, value)}
    input_changed(channel, input_port.value)
  end

  def select_changed(value)
    if @select.is_defined? then
      new_channel = @select.numeric_value
      if @inputs[new_channel] == nil then
        @output.unset
      else
        @output.value = @inputs[new_channel].value
      end
    else
      @output.unset
    end
  end

  def input_changed(channel, new_value)
    if @select.is_defined? && channel == @selct.numeric_value then
      @output.value = new_value
    end
  end
end

class Adder
  def initialize(*args)
    @inputs = []
    if args.length==0
      @width=1
      @sum = Port.new(@width)
      @carry = Port.new(1)
      @cin = 0
    elsif args[0].class==Fixnum
      @width=args.shift
      @sum = Port.new(@width)
      @carry = Port.new(1)
      add_input(args[0])
      add_input(args[1])
      @cin = args[2] #Not a port
      cin = false if cin == nil
     else
      @width=args[0].width
      @sum = Port.new(@width)
      @carry = Port.new(1)
      add_input(args[0])
      add_input(args[1])
      @cin = args[2] #Not a port
      cin = false if cin == nil
    end
  end

  def sum
    return @sum
  end

  def carry
    return @carry
  end
  
  def add_input(input_port)
    if input_port.width != @width then
      raise ArgumentError, "Incorrect port width"
    end
    @inputs.push(input_port)
    input_port.add_callback {|value| self.input_changed(value)}
    input_changed(input_port.value)
  end

  def input_changed(new_value)
    #called any time an input changes, or when input added
    #for each bit loop through all inputs to see if any are True
    new_sum = ""
    c = ""
    i=0
    (0...@width).each do |bit|
      unknowns = false
      bits = []
      @inputs.each do |inp|
        case inp.value()[bit]
        when "X"
          unknowns = true
        when "Z"
          unknowns = true
        else
          bits.push(inp.value()[bit].to_i)
        end
      end
      if unknowns
        new_sum[bit] = "X"
        c = "0"
      else
        tot=0
        puts "Bits:#{bits}"
        bits.each do |bit|
          tot+=bit
        end
        p tot
        if c=="1"
          tot+=1
          p tot
        end
        if @cin and i==0
          puts "adding 1:#{i}"
          tot+=1
          p tot
        end
        i+=1
        puts "Total:#{tot}"
        bval=tot.to_s(2).split("")
        bval="#{bval[-2]}#{bval[-1]}"
        bval=bval.to_s
        puts "Binary value:#{bval}"
        if bval.length==2
          s = bval[1]
          c = bval[0]
        else
          s = bval[0]
          c = "0"
        end
        new_sum = s + new_sum
      end
    end
    @sum.value = new_sum
    @carry.value = c
  end
end

class Reg
  def initialize(wr,data)
    @wr = wr
    @data = data
    @wr.add_callback {|value| self.input_changed(@data.value)}
    @data.add_callback {|value| self.input_changed(@data.value)}
    @output = Port.new(data.width)
    @val = nil
   end

  def output
    return @output
  end

  def set_input(input_port)
    if input_port.width != @width then
      raise ArgumentError, "Incorrect port width"
    end
    @input=input_port
    input_port.add_callback {|value| self.data_changed(value)}
    input_changed(input_port.value)
  end

  def input_changed(data_val)
    if @wr.value=="1"
      @output.value = data_val
    end
  end
end


class Dbg
  def initialize(ports)
    @names = []
    @ports = {}
    ports.each do |port,name|
      @names.push(name)
      @ports[name] = port
    end
  end

  def out
    watch_str = ""
    @names.each { |name| watch_str += "#{name}=#{@ports[name].value} " }
    puts watch_str
  end
end
in1=Port.new(4)
in2=Port.new(4)
difference,borrow=in1-in2
dbg=Dbg.new(in1=>"in1",in2=>"in2",difference=>"difference",borrow=>"borrow")
in1.value="1101"
in2.value="0001"
dbg.out