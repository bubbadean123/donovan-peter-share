require "socket"
require "stringio"
def local_ip
  orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true
    UDPSocket.open do |s|
      s.connect '64.233.187.99', 1
      s.addr.last
    end
  ensure
    Socket.do_not_reverse_lookup = orig
end
addr = local_ip
port = 65534
server = TCPServer.new(addr, port)
puts "Started Server on #{addr}:#{port}"
begin
  maintain_connection = false
  loop do
    client = server.accept
    puts "New connection from #{client.local_address.getnameinfo[0]}" unless maintain_connection
    maintain_connection = true
    header = client.gets
    case header
    when /^text/
      puts "Processing text"
      while data = client.gets
        next if data =~ /^text/
        break if data =~ /^EOF/
        puts data
      end
    when /^file/
        filename = File.basename(client.gets.chomp)
        filename =  "~/Desktop/" + filename
        filename = File.expand_path(filename)
        file = File.open(filename, "w")
        file.close
        puts "Created File"
     while data = client.gets
        next if data =~ /^file/
        break if data =~ /^EOF/
        file = File.open(filename, "a")
        file.puts data
        puts "Wrote Data"
      	file.close
       	puts "Closed File"
      end
when /^test/
client.puts true
client.flush
    else
      "Unsure how to handle header: #{header}"
    end

    client.close
  end
ensure
  server.close rescue nil
end
