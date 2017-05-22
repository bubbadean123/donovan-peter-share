class Fixnum
  def constrain(max,sub=false)
    if self > max
      if sub
        return self - max
      else
        return 0
      end
    else
      return self
    end
  end
end
#description at http://danieljabailey.github.io/c88-js/
LOAD="00000" # Load an address into the register
SWAP="00001" # Swap the register value and the value at some address
STORE="00010" # Store the register into an address
STOP="00011000" # Stop the program
TSG="00100000" # Test, skip if greater than zero
TSE="00110000" # Test, skip if equal to zero  
TSI="00111000" # Test, skip if not equal to zero
JMP="01000" # Jump to the specified address
JMA="01001" # Jump to the address stored at the specified address 
IOW="01100000"	# IO write, write register to output
IOR="01101000" # IO read, read input to register
IOS="01110000" # IO swap, write register to output then load input to register
IOC="01111000" # IO clear, write 0 to output register
ADD="10000" # Add value at address to register, result in register
SUB="10001" # Subtract value at address from register, result in register
MUL="10010" # Multiply value at address by register, result in register
DIV="10011" # Divide register by value at address, result in register
CMP="10100" # Subtract value at address from register and skip if equal to zero, discard result
INC="11100000" # Increment register by one
DEC="11101000" # Decrement register by one
DOUBLE="11110000" # Double the value of the register
HALF="11111000" # Half the value of register
$mem=[IOR,STORE+"111",IOW,INC,CMP+"111",JMP+"001",STOP,11]
reg=0
pc=0
def splitins(ins)
  binrep=ins.to_s(2).rjust(8,"0")
  return binrep[0..4].to_i(2),binrep[5..7].to_i(2)
end
def getmem(addr)
  val=$mem[addr]
  if val.class==String
    val=val.to_i(2)
  end
  if val==nil
    val=0
  end
  return val
end
while true do
  #puts "mem=#{mem},reg=#{reg},pc=#{pc}"
  ins=getmem(pc)
  pc=(pc+1).constrain(7)
  op,addr=splitins(ins)
  #puts "op=#{op},addr=#{addr}"
  case op
  when 0
    reg=getmem(addr).constrain(255)
  when 1
    t=reg
    reg=getmem(addr).constrain(255)
    $mem[addr]=t
  when 2
    $mem[addr]=reg
  when 3
    break
  when 4
    if reg > 0
      pc=(pc+1).constrain(7)
    end
  when 5
    # Negative checks not applicable for this simulator
  when 6
    if reg == 0
      pc=(pc+1).constrain(7)
    end
  when 7
    if reg != 0
      pc=(pc+1).constrain(7)
    end
  when 8
    pc=addr
  when 9
    v,temp=splitins(getmem(addr))
    pc=var
  when 10,11
    next
  when 12
    puts "Output:#{reg}"
  when 13
    print "Input:"
    reg=gets.chomp!.to_i.constrain(255)
  when 14
    puts "Output:#{reg}"
    print "Input:"
    reg=gets.chomp!.to_i.constrain(255)
  when 15
    # IO Clear not applicable for this simulator
  when 16
    reg=(reg+getmem(addr)).constrain(255)
  when 17
    reg=(reg-getmem(addr)).constrain(255)
  when 18
    reg=(reg*getmem(addr)).constrain(255)
  when 19
    reg=(reg/getmem(addr)).constrain(255)
  when 20
    res=(reg-getmem(addr)).constrain(255)
    if res == 0
      pc=(pc+1).constrain(7)
    end
  when 21,22,23,24,25,26,27
    # Shift and rotate hard to implement 
    # Unsigned versions of aritmetic not applicable for this simulator
  when 28
    reg=(reg+1).constrain(255)
  when 29
    reg=(reg-1).constrain(255)
  when 30
    reg=(reg*2).constrain(255)
  when 31
    reg=(reg/2).constrain(255)
  end
end