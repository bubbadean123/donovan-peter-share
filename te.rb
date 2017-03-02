puts "Welcome to Ruby Text Editor v1.0"
puts "Name:"
name=gets.chomp
doc=File.read(name).split("\n")
input=""
i=0
docfile=File.open(name,"r+")
while input!="s"
	puts "#{i}: #{doc[i]}"
	print "New (Enter to keep):"
	input=gets.chomp
	case input
	when "l"
		print "Lineno: "
		i=gets.chomp.to_i
	when "s"
		next
	when ""
		i+=1
	else
		doc[i]=input
		i+=1
	end
end
doc.each do |line|
	docfile.puts line
end
docfile.close
