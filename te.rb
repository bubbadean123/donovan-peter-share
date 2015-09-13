puts"Welcome to Ruby Text Editor v1.0"
puts "Name:"
name=gets.chomp
doc=[]
input=""
i=0
while input!="s" 
input=gets.chomp
case input
when "e" 
line=gets.chomp
line=Integer(line)
input=gets.chomp
doc[line]=input
when "s"
next
else
doc[i]=input
i=i+1
end
end
puts doc
docfile=File.open(File.expand_path(name),"w")
doc.each do |line|
docfile.puts line
end
docfile.close