require 'set'
#print "Input text:"
input="abbaabbaababbaaaabaabba"
#puts input[0..1]
set=Set.new
dict={}
input.each_char do |c|
	set.add c
end
i=0
chars=set.to_a
chars.each do |c|
	dict[c]=i
	i+=1
end
#puts dict
#puts dict.values.inspect
cinput=[]
res=""
input.each_char do |c|
	nres=res+c
	puts "nres:#{nres},dict=#{dict.inspect}"
	if dict.keys.include? nres
		res=nres
		puts "res:#{res}"
	else
		puts "Pushing"
		cinput.push dict[res]
		puts "dict[res]=#{dict[res]},res=#{res},cinput=#{cinput.inspect}"
		dict[nres]=dict.size
		res=c
		puts dict.inspect
	end
end
cinput.push dict[res]
puts dict.inspect
puts cinput.compact.inspect
