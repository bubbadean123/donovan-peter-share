require_relative 'recipe'

class Barista
  class << self
    attr_accessor :inventory, :menu

    def restock
      @inventory ||= {}
      INGREDIENT_COSTS.keys.each do |ingredient|
        @inventory[ingredient] = 9999999
      end
    end

    def set_menu(recipes)
      @menu = []
      recipes.each do |name, ingredients|
        @menu << Recipe.new(name, ingredients)
      end
      @menu.sort!{|a, b| a.name <=> b.name}
    end

    def in_stock?(recipe)
      !inventory.any?{|k, v| v < recipe.requirement(k)}
    end

    def make_drink(recipe_number)
      return nil, false if recipe_number < 1 || recipe_number > @menu.size
      recipe = @menu[recipe_number - 1]
      return recipe, false unless in_stock?(recipe)
      recipe.ingredients.each do |name, units|
        inventory[name] = inventory[name] - units
      end
      return recipe, true
    end

    def print_inventory
      puts "Inventory:"
      inventory.keys.sort.each do |name|
        puts "#{name},#{inventory[name]}"
      end
    end

    def print_menu
      puts "Menu:"
      @menu.each_with_index do |recipe, index|
        printf("%d,%s,$%1.2f,%s\n", index + 1, recipe.name, recipe.cost, in_stock?(recipe))
      end
    end
  end
end