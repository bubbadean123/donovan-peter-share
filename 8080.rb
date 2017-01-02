class CPU
	def initialize(keybd)
		@a=0
		@b=0
		@c=0
		@d=0
		@e=0
		@h=0
		@l=0
		@zf=0
		@cf=0
		@pc=0
		@sp=0
		@mem=Array.new(65536,0)
		@memmlist=[]
		@io=Array.new(255,0)
		@keybd=keybd.split("")
	end

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
	
	def execute(op)
		string=""
		command=op.split(" ")[0]
		if op.split(" ").length > 1
			operands=op.split(" ")[1].split(",")
			i=0
		end
		jmpop=false
		string+=op.upcase+"\n"
		case command.upcase
			when "EXIT"
				return
			when "MONIT"
				memmlist=[]
				operands.each do |adr|
					memmlist.push(adr.to_i)
				end
		  when "STA"
		  	@mem[operands[0].to_i]=@a
		  when "LDA"
		  	@a=@mem[operands[0].to_i]
			when "MVI"
				operands[1]=operands[1].to_i
				case operands[0]
					when "A"
						@a=operands[1]
					when "B"
						@b=operands[1]
					when "C"
						@c=operands[1]
					when "D"
						@d=operands[1]
					when "E"
						@e=operands[1]
					when "H"
						@h=operands[1]
					when "L"
						@l=operands[1]
				end
			when "ADD"
				@zf=0
				@cf=0
				case operands[0]
						when "B"
							@a=@a+@b
						when "C"
							@a=@a+@c
						when "D"
							@a=@a+@d
						when "E"
							@a=@a+@e
						when "H"
							@a=@a+@h
						when "L"
							@a=@a+@l
					end
				if @a==0
					@zf=1
				end
				if @a>=256
					@cf=1
					@a=0
				end
		when "SUB"
			@zf=0
			@cf=0
			case operands[0]
					when "B"
						@a=@a-@b
					when "C"
						@a=@a-@c
					when "D"
						@a=@a-@d
					when "E"
						@a=@a-@e
					when "H"
						@a=@a-@h
					when "L"
						@a=@a-@l
				end
			if @a==0
				@zf=1
			end
			if @a>=256
				@cf=1
				@a=0
			end
		when "CMP"
			@zf=0
			@cf=0
			case operands[0]
					when "A"
					string+="A\n"
					temp=@a-operands[1].to_i
					when "B"
						temp=@b-operands[1].to_i
					when "C"
						temp=@c-operands[1].to_i
					when "D"
						temp=@d-operands[1].to_i
					when "E"
						temp=@e-operands[1].to_i
					when "H"
						temp=@h-operands[1].to_i
					when "L"
						temp=@l-operands[1].to_i
				end
			if temp==0
				@zf=1
			end
			if temp>=256
				@cf=1
			end
			when "INR"
				case operands[0]
						when "A"
							@a=@a+1
						when "B"
							@b=@b+1
						when "C"
							@c=@c+1
						when "D"
							@d=@d+1
						when "E"
							@e=@e+1
						when "H"
							@h=@h+1
						when "L"
							@l=@l+1
					end
			when "DCR"
				case operands[0]
						when "a"
							@a=@a-1
						when "B"
							@b=@b-1
						when "C"
							@c=@c-1
						when "D"
							@d=@d-1
						when "E"
							@e=@e-1
						when "H"
							@h=@h-1
						when "L"
							@l=@l-1
					end
			when "MOV"
				instance_variable_set("@"+operands[0].downcase,instance_variable_get("@"+operands[1].downcase))
			when "OUT"
				case operands[0].to_i
				when 0
					case @mesport
					when 0
						print @a.chr
					end
			  when 1
					@mesport=@a
				end
			when "IN"
				case operands[0].to_i
				when 0
					case @mesport
					when 1
						@a=@keybd.shift
						if @a==nil
							@a=0
					  else
							@a=@a.ord
					  end
					end
				end
			when "JMP"
				jmp=true
				@pc=operands[0].to_i
			when "JNZ"
				jmp=true if @zf==0
				@pc=operands[0].to_i if @zf==0
		end
		unless jmp
			@pc=@pc+1
		end
		jmp=false
		i=0
		pr=0
		string+="A:#{@a}, B:#{@b}, C:#{@c}, D:#{@d}, E:#{@e}, H:#{@h}, L:#{@l}, PC:#{@pc}, SP:#{@sp}, ZF:#{@zf}, CF:#{@cf}"
		@memmlist.each do |adr|
			if pr==4
				string+="\n"
				pr=0
			end
			if i<@memmlist.length-1
				string+="mem[#{adr}]=#{mem[adr]}, "
			else
				string+="mem[#{adr}]=#{mem[adr]}"
			end
			i=i+1
			pr=pr+1
		end
		if @memmlist.length>0
			string+="\n"
		end
		return string
	end
	
	def pc()
		return @pc
	end
	
	def reset()
		@a=0
		@b=0
		@c=0
		@d=0
		@e=0
		@h=0
		@l=0
		@zf=0
		@cf=0
		@pc=0
		@sp=0
  end

	def run(fname)
		while true
	  	prog=File.readlines(fname)
			if prog[@pc]=="HLT"
				return
		  else
				execute(prog[@pc].chomp)
			end
		end
	end
end
cpu=CPU.new("hello")
cpu.run("echo.txt")