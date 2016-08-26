def new_enum(name,entrys)
  klass = Object.const_set(name,Class.new)
  klass.class_eval("@@values=[]")
  entrys.each do |key,value|
      klass.const_set(key.capitalize,value)
      klass.class_eval("@@values.push(value)")
  end
  klass.class_eval("def self.values;@@values;end")
end

new_enum("Size",{"Small"=>"small", "Medium"=>"medium", "Large"=>"large"})
new_enum("Drink",{"Milk"=>"milk", "Water"=>"water", "OrangeJuice"=>"orange juice", "AppleJuice"=>"apple juice"})

class Cup
  def initialize(size,drink = nil)
    if size.class != String
      raise TypeError, "size can't be of type " + size.class.to_s
    end
    if drink.class != String and drink.class != NilClass
      raise TypeError, "drink can't be of type " + drink.class.to_s
    end
    unless Drink.values.include? drink or drink == nil
      raise ArgumentError, "#{drink} is not a valid drink"
    end
    unless Size.values.include? size
      raise ArgumentError, "#{size} is not a valid size"
    end
    @size=size
    @drink=drink
  end
  
  def to_s(debug = false)
    if debug.class != TrueClass and debug.class != FalseClass
      raise TypeError, "debug can't be of type " + debug.class.to_s
    end
    if debug == false
      unless @drink == nil
        return "This is a #{@size} cup of #{@drink}"
      else
        return "This is a #{@size} cup"
      end
    else
     return "@drink:#{@drink.inspect} @size:#{@size.inspect}"
    end
  end
  
  def fill(drink)
    unless Drink.values.include? drink
      raise ArgumentError, "#{drink} is not a valid drink"
    end
    if drink.class == NilClass
      raise TypeError, "drink can't be of type " + drink.class.to_s + ". Use empty() instead."
    end
    if drink.class != String
      raise TypeError, "drink can't be of type " + drink.class.to_s
    end
    @drink=drink
  end
  
  def empty()
   @drink=nil
  end
end
begin
  cup = Cup.new(Size::Medium)
  puts cup.to_s()
  cup.fill(Drink::Water)
  puts cup.to_s()
  cup.empty
  puts cup.to_s()
rescue => e
    backtrace = e.backtrace
    puts backtrace.shift + ": " + e.message + " (" + e.class.to_s + ")"
    backtrace.each do |l|
      puts "    from " + l
    end
end