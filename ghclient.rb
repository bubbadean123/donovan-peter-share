require "socket"
dest_server_address = "10.0.0.2"
dest_server_port = 65535
connection = TCPSocket.new(dest_server_address, dest_server_port)
while true
data=gets.chomp
if data == "send"
connection.close
connection = TCPSocket.new(dest_server_address, dest_server_port)
else
connection.print data
end
end