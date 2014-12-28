class Recipe
  class Invalid < Exception; end
  attr_reader :name, :ingredients
  def initialize(name, ingredients)
    @name = name
    @ingredients = ingredients
    @ingredients.keys.each do |ingredient|
      raise Invalid unless INGREDIENT_COSTS[ingredient]
    end
  end

  def requirement(ingredient_name)
    ingredients[ingredient_name] || 0
  end

  def cost
    c = 0.0
    @ingredients.each do |ingredient, quantity|
      c += INGREDIENT_COSTS[ingredient] * quantity
    end
    return c
  end
end