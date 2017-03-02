require "socket"
socket=TCPSocket.new("localhost",1024)
addrlist=["addr1","addr2"]
socket.puts "junk"
addrlist.each do |addr|
	socket.puts "send"
	socket.puts addr
	socket.puts "Junk email"
end
socket.puts "done"
socket.close