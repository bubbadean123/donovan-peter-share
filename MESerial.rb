$devices={0=>nil,1=>nil,2=>nil,3=>nil,4=>nil,5=>nil,6=>nil,7=>nil,8=>nil,9=>nil,10=>nil,11=>nil}
def sendbyte(byte,port=nil)
  if port==nil
    puts "Output: #{byte}"
  else
    puts "Output on port #{port}: #{byte}"
  end
end

def getbyte(port=nil)
  if port==nil
    print "Input required: "
    return gets.chomp!.to_i
  else
    print "Input required on port #{port}: "
    return gets.chomp!.to_i
  end
end

def connect(port)
  sendbyte(255,port)
  sendbyte(0,port)
  sendbyte(0,port)
  type=getbyte(port)
  $devices[port]=type
end
 
def disconnect(port)
  $devices[port]=nil
end
connect(0)
connect(2)
connect(3)
puts $devices
string=""
while true
  character=getbyte(0).chr
  if character == "\r" or character == "\n"
    puts string
    string=""
  end
  if character == "\x04"
    break
  end
  string=string+character
end
disconnect(0)
puts $devices