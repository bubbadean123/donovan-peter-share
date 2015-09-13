puts"Welcome to Ruby Text Editor v1.0"
puts "Name:"
name=gets.chomp
puts"Extension:"
type=gets.chomp
doc=[]
input=""
i=0
while input!="s" 
	input=gets.chomp
	case input
	when input=="e" 
		line=gets.chomp
		line=Integer(line)
		input=gets.chomp
		doc[line]=input
	when input=="s"
		next
	else
	doc[i]=input
	i=i+1
	end
end
i=0
docfile=File.open(name+"."+type,"w")
while i < doc.length 
		docfile.puts doc[i]
i++
end
docfile.close