# Ruby Circuit Simulator
#


# holds a digital value
# can call listener callbacks when value changes
class Port 
  def initialize
    @callbacks = []
    @value = "X"
  end 

  def set(value)
    if @value != value then
      @value = value
      if @value=="1"
        @value=true
      end
      if @value=="0"
        @value=false
      end
      #send new value to each listener
      for callback in @callbacks do
        callback.call(@value)
      end  
    end
  end

  def get()
    return @value
  end

  def add_callback(&callback)
    #add block to the list
    @callbacks.push(callback)
  end

end

class NotGate
  def initialize()
    @inputs = []
    @output = Port.new()
  end
  
  def add_input(input_port)
    @inputs.push(input_port)
    input_port.add_callback {|value| self.input_changed(value)}
    input_changed(input_port.get)
  end
  
  def output
    return @output
  end
  
  def input_changed(new_value)
    unknowns = false
    case @inputs[0].get
    when false
      @output.set(true)
    when true
      @output.set(false)
    when "X"
      unknowns = true
    when "Z"
      unknowns = true
    end
    if unknowns then 
      @output.set("X")
    end
  end
end

class AndGate
  def initialize()
    @output = Port.new()
    @inputs = []
  end
  
  def output
    return @output
  end

  def add_input(input_port)
    @inputs.push(input_port)
    input_port.add_callback {|value| self.input_changed(value)}
    input_changed(input_port.get)
  end

  def input_changed(new_value)
    #called any time an input changes, or when input added
    #loop through all inputs to see if all are True
    unknowns = false
    for inp in @inputs do
      case inp.get()
      when false
         @output.set(false)
         return
      when "X"
         unknowns = true
      when "Z"
         unknowns = true
      end
    end
    if unknowns then 
      @output.set("X")
    else 
      @output.set(true)
    end
  end
end

class OrGate
  def initialize()
    @output = Port.new()
    @inputs = []
  end

  def output
    return @output
  end

  def add_input(input_port)
    @inputs.push(input_port)
    input_port.add_callback {|value| self.input_changed(value)}
    input_changed(input_port.get)
  end

  def input_changed(new_value)
    #called any time an input changes, or when input added
    #loop through all inputs to see if any are True
    unknowns = false
    for inp in @inputs do
      case inp.get()
      when true
        @output.set(true)
        return
      when "X"
        unknowns = true
      when "Z"
        unknowns = true
      end
    end
    if unknowns then
      @output.set("X")
    else
      @output.set(false)
    end
  end
end

class Mux
  def initialize(data_a,data_b,sel)
    @data_a = data_a
    @data_b = data_b
    @sel = sel
    @not = NotGate.new(@sel)
    @and1 = AndGate.new(@data_a,@not.output)
    @and2 = AndGate.new(@data_b,@sel)
    @or = OrGate.new(@and1.output,@and2.output)
    @output = @or.output
  end
  def output
    return @output
  end
end

def display(port)
  case port.get()
  when "X"
    return "X"
  when "Z"
    return "Z"
  when true
    return "1"
  when false
    return "0"
  else
    return "-"
  end
end
gateclases={"NOT"=>NotGate,"AND"=>AndGate,"OR"=>OrGate}
print "HDL file:"
file=gets.chomp!
file=File.open(file,"r")
lines=file.readlines
file.close
ports={}
gates={}
type={}
lines.each do |line|
  split=line.split(" ")
  cmd=split[0]
  case cmd
  when "PORT"
    type[split[1]]="port"
  when "GATE"
    type[split[1]]="gate"
    gateclases[split[2]].new()
  when "WIRE"
    wire=split[1].split("->")
    if type[wire[0]]=="port"
      ports[wire[0]]=Port.new()
      type[wire[0]]="in"
      gates[wire[1]].add_input(ports[wire[0]])
    end
    if type[wire[0]]=="gate"
      type[wire[1]]="out"
      ports[wire[1]]=gates[wire[0]].output
    end
  end
end
puts type
puts ports
gates.each do |gate|
  p gate
end
while true
  print("Input to change:")
  inp=gets.chomp!
  print("Value:")
  val=gets.chomp!
  ports[inp].set(val)
  ports.each do |name,port|
    if type[name]=="out"
      puts "#{name}=#{port.get}"
    end
  end
end