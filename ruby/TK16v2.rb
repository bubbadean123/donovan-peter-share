# A simulator for the high-performance Terpstra-Krauter TK16 microprocessor


class TK16
	def initialize
		@a = 0
		@b = 0
		@r = 0
		@p = 0
		@ram = {}
		@stack = []
		@functstack = []
		@pc = 0
		@prog = {}  #program memory
		#map opcodes to methods
		@opcode_map = {
			0 => self.method(:ram_to_a),
			1 => self.method(:ram_to_b),
			2 => self.method(:r_to_ram),
			3 => self.method(:imload_a),
			4 => self.method(:imload_b),
			12 => self.method(:add),
			13 => self.method(:sub),
			14 => self.method(:mult),
			15 => self.method(:div),
			22 => self.method(:a_to_r),
			23 => self.method(:b_to_r),
			24 => self.method(:jump),
			25 => self.method(:jump_if_r0),
			26 => self.method(:jump_if_rnot0),
			30 => self.method(:call_op),
			31 => self.method(:return_op),
			32 => self.method(:push),
			33 => self.method(:pop)
		}	
			
	end

	#accessors for reading registers and RAM
	def a() return @a end
	def b() return @b end
	def r() return @r end
	def p() return @p end
	def ram() return @ram end
	def prog() return @prog end
	def stack() return @stack end
	def functstack() return @functstack end
	def pc() return @pc end 
	def prog() return @prog end
	def debug()
	puts "PC:"
	puts @pc
	puts "A:"
	puts @a
	puts "B:"
	puts @b
	puts "R:"
	puts @r
	puts "P:"
	puts @p
	puts "RAM:"
	puts @ram
	puts "Program:"
	puts @prog
	puts "Function stack:"
	puts @functstack
	puts "Stack:"
	puts @stack	
	end
	def execute_next()
		instruction = @prog[@pc]
		op = instruction>>16
		argument = instruction & 0xFF
		@opcode_map[op].call(argument)
		@pc += 1
	end
	
	#methods for opcodes
	#each op has to take an argument even if it does not use it
	def ram_to_a(address)
		if @ram[address] == nil
			puts "WARNING reading undefined RAM at #{address}"
			@a = 0
		else
			@a = @ram[address]
		end
end
	
	def ram_to_b(address)
		if @ram[address] == nil
			puts "WARNING reading undefined RAM at #{address}"
			@b = 0
		else
			@b = @ram[address]
		end
end
	
	def r_to_ram(adress)
		@ram[adress] = @r
end
	
	def imload_a(value)
		@a = value
end
	
	def imload_b(value)
		@b = value
end
	
	def r_to_p(arg)
		@p = @r
end
	
	def add(arg)
		@r = @a + @b
end

	def sub(arg)
		@r = @a - @b
end
	
	def mult(arg)
		@r = @a * @b
end
	def div(arg)
		@r = @a / @b
end
	
	def a_to_r(arg)
		@r = @a
end
	
	def b_to_r(arg)
		@r = @b
		end
	
	def jump(address)
		@pc = address
	end
	
	def jump_if_r0(address)
		if @r == 0
			@pc = address
		else
			
		end
	end

	def jump_if_rnot0(address)
		if @r != 0
			@pc = address
		else
			
		end
	end
	
	def call_op(address)
		@functstack.push(@pc+1)
		@pc = address
	end

	def return_op(arg)
		@pc = @functstack.pop
	end
	
	def push(adress)
	    @stack.push(@ram[adress])
    end
    def pop(adress)
      @RAM[adress] = @stack.pop
   end    
end #end of TK16 class definition
	

tk16 = TK16.new	
puts "Number to inc by:"
tk16.ram[0] = Integer(gets.chomp)
puts "Runs:"
runs = Integer(gets.chomp)
tk16.ram[1] = 0
#put the function/program into program memory
tk16.prog[0] = (0<<16) + 0 #LOADA 0
tk16.prog[1] = (1<<16) + 1 #LOADB 1
tk16.prog[2] = (12<<16) + 0 #ADD
tk16.prog[3] = (2<<16) + 1 #STORE 1
tk16.prog[4] = (24<<16) + 0 #JUMP 0
i = 0
while i < runs * 4
	tk16.execute_next
i += 1
if i == runs * 4
res = tk16.ram[1]
puts "Res:"
puts res
end
end