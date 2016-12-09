require "socket"
server = TCPServer.new("10.0.0.33", 1025)
client=server.accept
while true
  data=client.gets
  unless data==nil
    puts data
  else
    client.close
    client=server.accept
  end
end