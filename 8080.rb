a=0
b=0
c=0
d=0
e=0
h=0
l=0
zf=0
cf=0
pc=0
sp=0
mem=Array.new(65536,0)
memmlist=[]
def gline(path, line)
  result = nil

  File.open(path, "r") do |f|
    while line > 0
      line -= 1
      result = f.gets
    end
  end

  return result
end
while true
	if ARGV[0]==nil 
  	print ">"
		op=gets.chomp!
	else
		op=gline(ARGV[0],pc) 
	end
	command=op.split(" ")[0]
	if op.split(" ").length > 1
		operands=op.split(" ")[1].split(",")
		i=0
	end
	jmpop=false
	case command.upcase
		when "EXIT"
			break
		when "MONIT"
			memmlist=[]
			operands.each do |adr|
				memmlist.push(adr.to_i)
			end
	  when "STA"
	  	mem[operands[0].to_i]=a
	  when "LDA"
	  	a=mem[operands[0].to_i]
		when "MVI"
			operands[1]=operands[1].to_i
			case operands[0]
				when "A"
					a=operands[1]
				when "B"
					b=operands[1]
				when "C"
					c=operands[1]
				when "D"
					d=operands[1]
				when "E"
					e=operands[1]
				when "H"
					h=operands[1]
				when "L"
					l=operands[1]
			end
		when "ADD"
			zf=0
			cf=0
			case operands[0]
					when "B"
						a=a+b
					when "C"
						a=a+c
					when "D"
						a=a+d
					when "E"
						a=a+e
					when "H"
						a=a+h
					when "L"
						a=a+h
				end
			if a==0
				zf=1
			end
			if a>=256
				cf=1
				a=0
			end
		when "INR"
			case operands[0]
					when "A"
						a=a+1
					when "B"
						b=b+1
					when "C"
						c=c+1
					when "D"
						d=d+1
					when "E"
						e=e+1
					when "H"
						h=h+1
					when "L"
						l=l+1
				end
		when "DCR"
			case operands[0]
					when "A"
						a=a-1
					when "B"
						b=b-1
					when "C"
						c=c-1
					when "D"
						d=d-1
					when "E"
						e=e-1
					when "H"
						h=h-1
					when "L"
						l=l-1
				end
		
	end
	puts "A:#{a}, B:#{b}, C:#{c}, D:#{d}, E:#{e}, H:#{h}, L:#{l}, PC:#{pc}, SP:#{sp}, ZF:#{zf}, CF:#{cf}"
	i=0
	pr=0
	puts memmlist.length
	memmlist.each do |adr|
		if pr==4
			print "\n"
			pr=0
		end
		if i<memmlist.length-1
			print "mem[#{adr}]=#{mem[adr]}, "
		else
			print "mem[#{adr}]=#{mem[adr]}"
		end
		i=i+1
		pr=pr+1
	end
	if memmlist.length>0
		puts ""
	end
end