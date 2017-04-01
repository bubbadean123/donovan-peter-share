def makemove(num,who,coins)
	if who=="p"
		if num==1
			puts "Player takes #{num} coin"
		else
			puts "Player takes #{num} coins"
		end
	else
		if num==1
			puts "Computer takes #{num} coin"
	  else
			puts "Computer takes #{num} coins"
	  end
	end
	if num>3
		if who=="p"
			puts "Player cheat, computer wins"
			return 0
		else
			puts "Computer cheat, player wins"
			return 0
  	end
	end
	coins-=num
	if coins==0
		if who=="p"
			puts "Player wins"
		else
			puts "Computer wins"
	  end
	end
	return coins
end
coins=rand(12..13)
puts "Welcome to Ruby NIM"
if coins==12
	puts "I predict the computer will win"
else
	puts "I predict the player will win"
end
while true
	print "How many coins do you take?(1-3)"
	amount=gets.chomp!.to_i
	coins=makemove(amount,"p",coins)
	break if coins==0
	coins=makemove(4-amount,"c",coins)
	break if coins==0
	puts "There are #{coins} coins remaining"
end