require 'socket'
require 'stringio'

addr = "10.0.0.2"
port = 65534

server = TCPServer.new(addr, port)
puts "Started Server on #{port}"

begin
  maintain_connection = false
  loop do
    client = server.accept
    puts "New connection from #{client.local_address.to_s}" unless maintain_connection
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
        filename = client.gets
        file = File.open("w", filename)
        file.close
     while data = client.gets
        next if data =~ /^file/
        break if data =~ /^EOF/
        file = File.open("a", filename)
        file.puts data
      	file.close
      end
	file.close
    else
      "Unsure how to handle header: #{header}"
    end

    client.close
  end
ensure
  server.close rescue nil
end
