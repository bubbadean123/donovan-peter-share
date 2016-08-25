def new_enum(name,entrys)
  klass = Object.const_set(name,Class.new)
  entrys.each do |key,value|
      klass.const_set(key.capitalize,value)
  end
end

new_enum("Size",{"Small"=>"small", "Medium"=>"medium", "Large"=>"large"})
new_enum("Drink",{"Milk"=>"milk", "Water"=>"water", "OrangeJuice"=>"orange juice", "AppleJuice"=>"apple juice"})

class NilError < StandardError
  def initialize(var)
    super(var + " can't be nil!")
  end
end

class Cup
  def initialize(size,drink = nil)
    if size == nil
      raise NilError, "size"
    end
    if size.class != String
      raise TypeError, "size can't be of type " + size.class.to_s
    end
    if drink.class != String and drink.class != NilClass
      raise TypeError, "drink can't be of type " + drink.class.to_s
    end
    @size=size
    @drink=drink
  end
  
  def to_s(debug = false)
    if debug == false
      unless @drink==nil
        return "This is a #{@size} cup of #{@drink}"
      else
        return "This is a #{@size} cup"
      end
    else
     return "@drink:#{@drink.inspect} @size:#{@size.inspect}"
    end
  end
  
  def fill(drink)
    @drink=drink
  end
  
  def empty()
   @drink=nil
  end
end

cup = Cup.new(Size::Medium)
puts cup.to_s(true)
cup.fill(Drink::Water)
puts cup.to_s(true)
cup.empty
puts cup.to_s(true)