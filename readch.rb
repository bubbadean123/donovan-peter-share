require 'io/console'

while true
	input = STDIN.getch
	if input == "\u0003"
		exit
	end
	puts "Input:#{input.inspect}"
end