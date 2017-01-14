coins=12
puts "Welcome to Ruby NIM"
while coins>0
print "How many coins do you take?(1-3)"
amount=gets.chomp!.to_i
coins-=amount
puts "I take #{4-amount}"
coins-=4-amount
puts "There are #{coins} coins remaining"
end
puts "I win!"