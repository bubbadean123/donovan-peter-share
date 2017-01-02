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
def cd(dir)
	unless File.exists? dir
		Dir.mkdir(dir)
  end
	Dir.chdir(dir)
end
mem=[]
puts "Commands"
puts "P-Switch primary drive. 1 for hard drive, 0 for floppy."
puts "S-Save memory onto primary disk"
puts "W-Write bytes into memory."
puts "D-Display memory."
pdrive=1
while true
	print "#{pdrive}>"
	op=gets.chomp.asplit(" ")
	case op[0]
	when "P"
		pdrive=op[1].to_i
	when "S"
		cd("hdd")
		cd("s#{op[1]}")
		cd("t#{op[2]}")
		sector=File.open("s#{op[3]}","w")
		vals=mem[op[4].to_i..255+op[4].to_i]
		i=0
		vals.each do |v|
			if v==nil and i==vals.length-1
				sector.print "0"
			elsif v==nil
			  sector.print "0 "
			elsif i==vals.length-1
				sector.print "#{v}"
			else
				sector.print "#{v} "
			end
			i+=1
		end
		i=(i-1)+op[1].to_i
		unless i==255+op[4].to_i
			sector.print " "
			i1=0
			while i1<=(255+op[4].to_i)-i-1
				if i1==(255+op[4].to_i)-i-1
					sector.print "0"
			  else
					sector.print "0 "
				end
				i1+=1
			end
		end
		cd("../../../../")
		sector.close
	when "W"
		op.shift
		smem=op.shift.to_i
		i=0
		op.each do |v|
			mem[smem+i]=v.to_i
			i+=1
		end
	when "D"
		vals=mem[op[1].to_i..op[2].to_i]
		i=0
		vals.each do |v|
			if v==nil and i==vals.length-1
				print "0"
			elsif v==nil
			  print "0, "
			elsif i==vals.length-1
				print "#{v}"
			else
				print "#{v}, "
			end
			i+=1
		end
		i=(i-1)+op[1].to_i
		if i==op[2].to_i
			puts ""
		else
			print ", "
			i1=0
			while i1<=op[2].to_i-i-1
				if i1==op[2].to_i-i-1
					puts "0"
			  else
					print "0, "
				end
				i1+=1
			end
		end
	end
end