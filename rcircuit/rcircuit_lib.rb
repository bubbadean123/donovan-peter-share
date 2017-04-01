# Ruby Circuit Simulator
# Library file

# holds a digital value
# can call listener callbacks when value changes

require_relative "net"

classes=Object.constants
classes.each do |c|
  puts "Before, c=#{c.inspect}"
  c=Object.const_get(c)
  puts "After, c=#{c.inspect}"
  if c.class == Class
    if c.instance_methods.include? :test
      puts "Found test method on class:#{c}"
    end
  end
end
#add some extra functionality to the basic NetPort
class Port < NetPort
  include Comparable

  #override to handle bitstrings
  def value=(new_value)
    if new_value.class == String
      if new_value.length != self.width
        raise ArgumentError, "Wrong width for bitstring: #{new_value}"
      end
      numval = 0
      new_value.reverse.each do |bit|
        numval = numval << 1
	if bit == "1"
          numval += 1
        elsif bit != "0"
          raise ArgumentError, "String values (#{new_value}) must be binary"
        end
      end
      super(numval)
    else
      super(new_value)
    end
  end
 
  def convert_port(otherval)
    #checks if argument is a port or number
    #if it is a number, convert it to a contant port
    if otherval.class == Fixnum
      return PortConstant.new(self.width, otherval)
    else
      return otherval
    end
  end

  def &(other)
    other = convert_port(other)
    return AndGate.new(self,other).output
  end
  
  def |(other)
    other = convert_port(other)
    return OrGate.new(self,other).output
  end
  
  def ^(other)
    other = convert_port(other)
    return XorGate.new(self, other).output
  end

  def !
    return NotGate.new(self).output
  end
   
  def +(other)
    other = convert_port(other)
    return Adder.new(self.width,{"a"=>self,"b"=>other}).output
  end
  
  def -(other)
    other = convert_port(other)
    return Subtractor.new(self.width,{"a"=>self,"b"=>other}).output
  end
  
  def [](index)
    if index.class==Fixnum
      port=Port.new(1)  #single line
      mask = 1 << index
      shift = index
    else
      port=Port.new(index.size) #range
      mask = (2**(index.size) - 1) << index.first
      shift = index.first
    end
    #copies slice to new port
    self.add_callback do |new_value| 
      port.value = (new_value & mask) >> shift
    end
    return port
  end
  
  def join(other,last=false)
    port=Port.new(self.width+other.width)
    def update_port(last,port,other)
      if last
         port.value=(other.value << self.width) + self.value
      else
        port.value=(self.value << other.width) +other.value
      end
    end
    self.add_callback {|value| update_port(last,port,other)}
    other.add_callback {|value| update_port(last,port,other)}
    return port
  end
  
  def <=>(other)
    other = convert_port(other)
    return self.value<=>other.value
  end

  def >>(shiftbits)
    return LSR.new(self.width, shiftbits).inp(self).output
  end

  def <<(shiftbits)
    return LSL.new(self.width, shiftbits).inp(self).output
  end

  def bitstring
    if is_defined?
      mask = 1 << (self.width - 1)
      strval = ""
      self.width.times do
        if (self.value & mask) > 0
          strval += "1"
        else
          strval += "0"
        end
        mask = mask >> 1
      end
      strval
    else
      "X"*self.width
    end
  end
  
  def method_missing(m, *args, &block)
      return self
  end 
end

class PortConstant < Port
  def initialize(width, value)
    super(width)
    @assigned = false
    self.value = value
    @assigned = true
  end

  def _update(newvalue)
    if @assigned
      #not initial assigment
      raise RuntimeError, "Cannot change value of constant port"
    end
  end
end


class Gate
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

  def add_input(input_port)
    if input_port.width != @width then
      raise ArgumentError, "Incorrect port width"
    end
    @inputs.push(input_port)
    input_port.add_callback {|value| self.input_changed(value)}
    input_changed(input_port.value)
  end

  def output
    return @output
  end

end


class NotGate < Gate
  def initialize(*args)
    super
    @outmask = (2**@width)-1
  end

  def add_input(input_port)
    if @inputs.length > 0 then
      raise ArgumentError, "Cannot add multiple inputs to NotGate"
    end 
    super
  end

  alias set_input add_input
  
  def input_changed(new_value)
    inport=@inputs[0]
    if inport.is_defined?
      @output.value = (~inport.value) & @outmask
    else
      @output.undefine
    end
  end
  
end

class AndGate < Gate

  def input_changed(new_value)
    andval = nil
    @inputs.each do |inport|
      if inport.is_defined?
        if andval == nil
          andval = inport.value
        else
          andval = andval & inport.value
        end 
      else
        @output.undefine
        return
      end
    end
    @output.value = andval
  end

end

class OrGate < Gate

  def input_changed(new_value)
    orval = nil
    @inputs.each do |inport|
      if inport.is_defined?
        if orval == nil
          orval = inport.value
        else
          orval = orval | inport.value
        end 
      else
        @output.undefine
        return
      end
    end
    @output.value = orval
  end

end


class XorGate < Gate

  def input_changed(new_value)
    xorval = nil
    @inputs.each do |inport|
      if inport.is_defined?
        if xorval == nil
          xorval = inport.value
        else
          xorval = xorval ^ inport.value
        end 
      else
        @output.undefine
        return
      end
    end
    @output.value = xorval
  end

end


class Device
  def define_port(name, width=1, &callback)
    #create a method with the same name as the input
    #to assign a port to the input
    var_name = "@" + name
    port = Port.new(width)
    instance_variable_set(var_name, port)
    define_singleton_method(name) do |other=nil|
      if other.class == NilClass  #avoids overloaded compare for Port
        #getter
        instance_variable_get(var_name)
      else     
	#connect to given port
        if other.class == Fixnum
          #convert constant
          other = PortConstant.new(width, other)
        end
        instance_variable_get(var_name).connect(other)  
	self #for chained init calls     
      end
    end
    if block_given?
      port.add_callback(&callback)
    end
    port
  end

  def define_input(name, width=1)
    #automatically connects to on_change method
    define_port(name, width) { |new_value| on_change(new_value) }
  end

  #call on the hash of arguments at init
  def init_assign(hash)
    hash.each do |name, port|
      #check if there is a defined method (port) that matches
      if self.respond_to?(name)
        method(name).call(port)
      else
        raise ArgumentError, "No defined input '#{name}'"
      end      
    end
  end

end

#logical shift right
class LSR < Device
  def initialize(width, bitshift, init_args={})
    define_input("inp", width)
    define_port("output", width)
    @bitshift = bitshift
    init_assign(init_args)
  end

  def on_change(data_val)
    if @inp.is_defined?
      @output.value = @inp.value >> @bitshift
    else
      @output.undefine
    end
  end
end

#logical shift left
class LSL < Device
  def initialize(width, bitshift, init_args={})
    define_input("inp", width)
    define_port("output", width)
    @bitshift = bitshift
    @outmask = (2**width) - 1
    init_assign(init_args)
  end

  def on_change(data_val)
    if @inp.is_defined?
      @output.value = (@inp.value << @bitshift) & @outmask
    else
      @output.undefine
    end
  end
end


class Reg < Device
  def initialize(width, init_args={})
    define_input("data_in", width)
    define_port("data_out", width)
    define_input("clk")
    define_input("en")
    define_input("rst") 
    init_assign(init_args)
  end

  def on_change(data_val)
    if @rst.value == 1
      @data_out.value = 0
    elsif @en.value == 1 && @clk.posedge?
      @data_out.value = @data_in.value
    end
  end
end

class Counter < Device
  def initialize(width, init_args={})
    define_input("count_in", width)
    define_port("output", width)
    define_input("clk")
    define_input("load")
    define_input("rst") 
    init_assign(init_args)
  end

  def on_change(data_val)
    if @rst.value == "1"
      @count_out.value = 0
    elsif @clk.posedge?
      if @load.value == "1"
        @count_out.value = @count_in.value
      else
        @count_out.value = @count_out.numeric_value + 1
      end
    end
  end
end

class Mux < Device
  def initialize(data_width=1, select_width=1, init_args={})
    num_inputs = 2**select_width
    i=0
    @inputs = []
    num_inputs.times do
      @inputs << define_input("in"+i.to_s, data_width)
      i += 1
    end
    define_input("sel", select_width)
    define_port("out", data_width)
    init_assign(init_args)
  end

  def on_change(new_value)
    if sel.is_defined?
     
      out.value = @inputs[sel.value].value
    else
      out.undefine
    end
  end
end
   

class Decoder < Device
  def initialize(width, init_args={})
    @width=width
    define_input("sel", width)
    num_of_outputs=2**width
    i=0
    @outputs = []
    num_of_outputs.times do
      #create an ordered list of all the outputs
      @outputs << define_port("o"+i.to_s)
      i+=1
    end
    init_assign(init_args)
  end

  def on_change(data_val)
    if sel.is_defined?
      channel=sel.value
      i=0
      (@width**2).times do
        if i==channel
          @outputs[i].value=1
        else
          @outputs[i].value=0
        end
        i+=1
      end
    else
      (@width**2).times do
        @outputs[i].undefine
      end
    end 
  end
end

class Adder < Device
  def initialize(width, init_args)
    define_input("a", width)
    define_input("b", width)
    define_port("output", width)
    init_assign(init_args)
    @mask = 2**width - 1
  end

  def on_change(data_val)
    if @a.is_defined? && @b.is_defined?
      @output.value = (@a.value + @b.value) & @mask
    else
      @output.undefine
    end
  end
end

class Subtractor < Device
  def initialize(width, init_args)
    define_input("a", width)
    define_input("b", width)
    define_port("output", width)
    init_assign(init_args)
    @mask = 2**width - 1
  end

  def on_change(data_val)
    if @a.is_defined? && @b.is_defined?
      @output.value = (@a.value - @b.value) & @mask
    else
      @output.undefine
    end
  end
end

class Ram < Device
  def initialize(data_width, addr_width, init_args={})
    @mem=[]
    define_input("data_in", data_width)
    define_port("data_out", data_width)
    define_input("addr", addr_width)
    define_input("clk")
    define_input("wr")
    init_assign(init_args)
  end

  def set_data(init_array)
    @mem = init_array
  end

  def on_change(data_val)
    if @wr.value == 1 && @clk.posedge?
      @mem[addr.value]=data_in.value
      data_out.undefine
    elsif addr.is_defined? && @mem[addr.value] != nil
      data_out.value=@mem[addr.value]
    else
      data_out.undefine
    end
  end
end

class Dbg
  def initialize(ports)
    @names = []
    @ports = {}
    ports.each do |name,port|
      @names.push(name)
      @ports[name] = port
    end
  end

  def out
    watch_str = ""
    @names.each { |name| watch_str += "#{name}=#{@ports[name].bitstring}(#{@ports[name].value}) " }
    puts watch_str
  end
end