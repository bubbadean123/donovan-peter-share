require "drb/drb"
def connectDRb(port)
  obj=DRbObject.new_with_uri("druby://localhost:"+port.to_s)
  return obj
end
lastport=""
begin
print "Port:"
port=gets.chomp!
if port == ""
  port=lastport
end
cpu=connectDRb(port.to_i)
cpu.set_io(0,cpu.get_io(0)).inspect
rescue
puts "Connection refused"
lastport=port
retry
end
while true
  op=gets.chomp!.split("+")
  num1=op[0].to_i
  cpu.set_io(0,num1)
  num2=op[1].to_i
  cpu.set_io(1,num2)
  print "#{num1}+#{num2}="
  puts cpu.get_io(2)
end