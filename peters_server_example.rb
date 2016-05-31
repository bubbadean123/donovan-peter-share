require 'socket'
require 'stringio'

addr = "10.0.0.6"
port = 65534

server = TCPServer.new(addr, port)
puts "Started Server on #{port}"

begin
  maintain_connection = false
  loop do
    client = server.accept
    puts "New connection from #{client.local_address.inspect}" unless maintain_connection
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
