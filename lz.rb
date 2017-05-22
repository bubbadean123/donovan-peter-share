require 'set'
require "yaml"
#print "Input text:"
input="Vestibulum at odio ac ipsum dictum fringilla ultricies non dui. Duis ultrices vestibulum dolor a dictum. Etiam at elit non purus euismod fringilla. Donec non vestibulum nunc. Fusce id sem nisl. Nunc interdum iaculis erat, non congue sapien fringilla ut. Nulla dictum dolor et eleifend ullamcorper. Donec arcu elit, porttitor ac lacus a, eleifend viverra est. Sed egestas, elit sed blandit aliquet, eros lacus maximus mauris, a sagittis tortor velit nec justo. Etiam ultricies ligula non dictum accumsan. Praesent lacinia felis sit amet vehicula venenatis. Proin hendrerit elit eu ipsum sodales, vitae pulvinar arcu feugiat. Vivamus sagittis in arcu molestie varius. Phasellus mattis placerat odio vel laoreet. Vestibulum at ligula id mi commodo commodo.

Aliquam erat volutpat. Nulla quis iaculis lorem. Integer quis orci faucibus, venenatis massa ac, tempor odio. Integer ut sem ut nisl finibus euismod ut a ipsum. Sed sit amet ante consectetur, placerat magna quis, mollis turpis. Duis sit amet magna sollicitudin, lobortis turpis vel, varius lectus. Nullam aliquam a est ac dapibus. Nulla pharetra ante velit, quis fermentum nisi varius posuere. Nam ante nisi, viverra nec iaculis id, rhoncus sed felis. Aenean posuere dolor in arcu tincidunt cursus. Interdum et malesuada fames ac ante ipsum primis in faucibus. Praesent consequat nibh ut turpis suscipit, ac venenatis nisl posuere. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed eleifend interdum sapien, vitae mattis neque aliquet ut. Donec sed leo nec libero luctus accumsan. Duis luctus ante arcu, at vulputate sapien sagittis eu.

Maecenas pretium eleifend ultricies. Phasellus tincidunt lectus at nulla malesuada fermentum. In aliquam libero id volutpat mollis. Integer dictum enim quis accumsan interdum. Mauris porta metus neque, eu semper erat pulvinar in. Mauris vitae nisi lacus. Cras commodo a turpis ac semper.

Mauris dapibus id erat vitae mattis. Praesent tempor neque placerat, eleifend augue ac, sagittis ipsum. Donec in fringilla nisl, ac consequat sem. Proin ut sapien pretium, tristique nibh id, tempor ligula. Sed et volutpat tellus. Aliquam eu magna finibus, dignissim dui eu, accumsan augue. Praesent sed diam faucibus, pulvinar est sed, ultricies tellus. Morbi egestas sed lacus at fermentum. Proin pellentesque posuere turpis eget tincidunt. Etiam vel arcu pellentesque, varius tortor sit amet, fringilla erat.

Aenean in condimentum ante. Nam convallis sem eget arcu vehicula aliquam. Mauris vel rhoncus orci, ut vehicula est. Maecenas sit amet erat posuere, posuere neque sed, porta nulla. Nunc at lectus in felis varius varius at eu ipsum. Cras dapibus diam dolor, in tincidunt ipsum laoreet a. Nulla facilisi. Vivamus gravida in lectus non sollicitudin. Nam volutpat aliquam lobortis. Fusce molestie eros vitae orci pellentesque fermentum.

Nunc eu ipsum eros. Etiam id metus fermentum nunc feugiat eleifend vel vitae augue. Etiam vel tincidunt ex, eget fermentum neque. Sed suscipit dolor justo, vitae interdum velit lobortis vel. Proin eu lacus arcu. In hac habitasse platea dictumst. Nunc gravida risus arcu. In tristique at erat ut maximus. Integer eu hendrerit lectus. Quisque rutrum neque vel consequat tristique. Proin faucibus eget sem sit amet consequat. Proin viverra turpis nunc. Nam semper vestibulum augue, a eleifend purus dictum vitae. Nulla blandit neque tortor, vel cursus eros imperdiet a.

Maecenas pretium vel justo sed varius. Aliquam aliquam lacus risus, nec vehicula leo porta sed. Aenean ullamcorper molestie bibendum. Integer ante dolor, vehicula quis quam in, accumsan molestie mauris. Vivamus rhoncus, urna quis interdum scelerisque, ligula magna convallis erat, et iaculis leo mi at felis. Vestibulum molestie laoreet ligula eget porttitor. Donec aliquam urna et elit iaculis aliquam. Duis sit amet aliquet sem. Sed eleifend porttitor lorem, sed feugiat tellus. Mauris accumsan ultrices iaculis. Maecenas eleifend enim sit amet laoreet malesuada. Morbi quis mollis nisl, in dictum velit.

Nam eget fermentum metus, sit amet suscipit nulla. Fusce viverra rutrum tortor, eget ullamcorper enim efficitur id. Nunc rutrum scelerisque libero eu venenatis. Quisque turpis sapien, lacinia sit amet diam in, elementum sagittis nisi. Integer volutpat facilisis bibendum. Vestibulum vestibulum ultricies mi, vel sodales tortor. Morbi eleifend varius arcu, ac mattis sapien egestas vel. Nulla facilisi.

Nunc vitae leo at velit euismod varius eget nec nunc. Maecenas vitae mauris aliquet metus consectetur suscipit. Praesent nisl velit, viverra at mauris a, bibendum volutpat massa. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur bibendum placerat augue id ultrices. Cras sollicitudin sagittis ornare. Suspendisse eget vulputate purus. Nullam bibendum odio non nulla tempor condimentum. Nam rutrum arcu ex, et sagittis magna ullamcorper sit amet. Nam efficitur tincidunt felis, ac blandit mi tincidunt vitae. Nam volutpat ac ante vel tristique. Aliquam lobortis suscipit tellus, vel placerat purus laoreet et.

Fusce et nulla eget lorem finibus dapibus. Vivamus rutrum faucibus porttitor. Nunc vel ornare tortor. Pellentesque a ultrices nulla. Ut fringilla dictum euismod. Sed tempor ac neque at feugiat. Nulla blandit turpis at tellus malesuada, ac consectetur urna viverra.

Aenean rutrum ipsum non ex porttitor congue. Proin eget sagittis arcu. Nulla ac velit ut risus volutpat feugiat et nec lorem. Suspendisse et faucibus risus. Nam dignissim ornare augue, vitae ullamcorper tortor maximus non. Fusce blandit consectetur bibendum. Nullam pretium, magna non interdum viverra, odio dolor condimentum turpis, ac ullamcorper mauris turpis in nibh. Integer nisi sem, faucibus et est a, tempor sagittis mi. Proin vitae consequat mauris."
def compress(input)
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
		if dict.keys.include? nres
			res=nres
		else
			cinput.push dict[res]
			dict[nres]=dict.size
			res=c
		end
	end
	cinput.push dict[res]
	dict=dict.invert
	ndict={}
	aitems=Set.new
	cinput.each do |num|
		aitems.add num
	end
	dict.each do |k,v|
		if aitems.include? k
			ndict[k]=v
		end
	end
	return ndict,cinput
end	
def decompress(dict,cinput)
	dstring=""
	cinput.each do |num|
		dstring+=dict[num]
	end
	return dstring
end
class LoadSaveMarshal
	attr_accessor :items
	def initialize(*items)
		@items=items
  end
	def marshal_dump
		@items
  end
	def marshal_load(items)
		@items=items
	end
end
File.open("compressed.marshal","w") do |file|
	compressed=compress(input)
	puts compressed.inspect
	puts compressed.length
	puts input.length
	file.puts Marshal.dump(LoadSaveMarshal.new(compressed))
end