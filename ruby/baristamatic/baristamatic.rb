require_relative "models/barista"

INGREDIENT_COSTS = {
  "Coffee" => 0.75,
  "Decaf Coffee" => 0.75,
  "Sugar" => 0.25,
  "Cream" => 0.25,
  "Steamed Milk" => 0.35,
  "Foamed Milk" => 0.35,
  "Espresso" => 1.10,
  "Cocoa" => 0.90,
  "Whipped Cream" => 1.00
}

Barista.restock
Barista.set_menu({
  "Coffee" => {"Coffee" => 3, "Sugar" => 1, "Cream" => 1},
  "Decaf Coffee" => {"Decaf Coffee" => 3, "Sugar" => 1, "Cream" => 1},
  "Caffe Latte" => {"Espresso" => 2, "Steamed Milk" => 1},
  "Caffe Americano" => {"Espresso" => 3},
  "Caffe Mocha" => {"Espresso" => 1,"Cocoa" => 1,"Steamed Milk" => 1, "Whipped Cream" => 1},
  "Cappuccino" => {"Espresso" => 2, "Steamed Milk" => 1, "Foamed Milk" => 1}
  })

loop do
  Barista.print_inventory
  Barista.print_menu

  input = STDIN.gets.strip
  break if input.downcase == 'q'
  next if input.empty?
  if input.match(/^\d+$/)
    recipe, in_stock = Barista.make_drink(input.to_i)
    if recipe
      if in_stock
        puts "Dispensing: #{recipe.name}"
      else
        puts "Out of stock: #{recipe.name}"
      end
    else
      puts "Invalid selection: #{input}"
    end
  elsif input.downcase == 'r'
    Barista.restock
  else
    puts "Invalid selection: #{input}"
  end
end
