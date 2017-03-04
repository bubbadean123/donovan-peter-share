# Ruby Circuit Simulator
# Library file


# holds a digital value
# can call listener callbacks when value changes
class Port 
  def initialize(width=1)
    @width = width
    @callbacks = []
    @value = "X"*width
  end 
  def value
    @value
  end
  def value=(new_value)
    #set method
    if @value != new_value then
      if value.length != @width then
        raise ArgumentError, "New value is incorrect width"
      end
      @value = new_value
      #send new value to each listener
      for callback in @callbacks do
        callback.call(@value)
      end  
    end
  end

  def add_callback(&callback)
    #add block to the list
    p callback
    @callbacks.push(callback)
  end

  def is_defined?()
    #returns true if all bits are defined
    for bit in (0...@width) do
      if @value[bit] == 'X' || @value[bit] == 'Z' then
        return false
      end
    end
    return true
  end

  def numeric_value()
    numval = 0
    bitvalue = 1
    for bit in (0...@width) do
      if @value[bit] == "1" then
        numval += bitvalue
      end
      bit_value = bitvalue * 2
    end
    return numval
  end  

  def width()
    @width
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
    puts "Input changed to #{new_value}"
    new_output = @output.value
    for i in 0...@width do
      case new_value[i]
        when "0"
          new_output[i] = "1"
        when "1"
          new_output[i] = "0"
        else
          new_output[i] = "X"
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
    puts "An input changed to #{new_value}"
    #called any time an input changes, or when input added
    #for each bit loop through all inputs to see if all are True
    new_output = @output.value
    for bit in 0...@width do
      unknowns = false
      found_zero = false
      for inp in @inputs do
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
    #loop through all inputs to see if any are True
    new_output = @output.value
    for bit in 0...@width do
      unknowns = false
      found_one = false
      for inp in @inputs do
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
=begin
in1 = Port.new
in2 = Port.new
andgate = AndGate.new(in1,in2)
notgate = NotGate.new(andgate.output)
dbg=Dbg.new({in1=>"in1",in2=>"in2",notgate.output=>"out"})
in1.value = "0"
in2.value = "0"
dbg.out
in1.value = "0"
in2.value = "1"
dbg.out
in1.value = "1"
in2.value = "0"
dbg.out
in1.value = "1"
in2.value = "1"
dbg.out
=end
in=Port.new
