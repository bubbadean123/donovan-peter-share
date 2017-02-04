class String
	def asplit(delimiter)
		result=[]
		escape=false
		string=""
		i=0
		self.each_char  do |c|
			if c=="\\"
				escape=true
			elsif c==delimiter
				unless escape
					result.push(string)
					string=""
				else
					string+=delimiter
					escape=false
				end
			else
				string+=c
			end
		end
		if string != ""
			result.push string
		end
		return result
	end
end
def irbold()
	i=1
	while true
		rubyv=`ruby -v`.split(" ")[1].split("p")[0]
		padi=i.to_s.rjust(3, '0')
		print rubyv+" "+":#{padi}"+" "+"> "
		line=gets.chomp!
		if line=="quit" or line=="exit"
			return
		end
		begin
			puts " => "+eval(line)
	  rescue SyntaxError=>e
			puts e.message
		rescue StandardError=>e
			puts e.message
		end
	end
end
def irb()
`irb`
end
def ruby(file)
eval(File.readlines(file))
end
puts "Uh-oh, your computer has experienced an error!"
puts "You must write programs to get your computer working again."
puts "You can only use ruby and irb."
while true
	print "$ "
	cmd=gets.chomp!.asplit(" ")
	case cmd[0]
	when "irb"
		irb()
	when "ruby"
		ruby(cmd[1]+".rb")
	end
end