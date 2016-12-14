require "socket"
def local_ip
  orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true
    UDPSocket.open do |s|
      s.connect '64.233.187.99', 1
      s.addr.last
    end
  ensure
    Socket.do_not_reverse_lookup = orig
end
server = TCPServer.new(local_ip, 1025)
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