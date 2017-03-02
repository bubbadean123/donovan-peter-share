require "socket"
messages={}
Thread::abort_on_exception=true
server = TCPServer.new 1024
puts "Server running on localhost:1024"
loop do
    Thread.start(server.accept) do |client|
    begin
      puts "Got connection"
    	addr=client.gets.chomp!
    	cmd=""
    	while cmd != "done"
      	cmd=client.gets.chomp!
      	case cmd
      	when "send"
      		address=client.gets.chomp!
        	text=client.gets.chomp!
        	emails=messages[address]
        	if !emails
        	  emails={}
        	end
        	emails[rand(2147483647)]={"text"=>text,"sender"=>addr}
        	messages[address]=emails
      	when "get"
        	messages[addr].each do |id,email|
          client.puts email["sender"]
          client.puts email["text"]
        end
        client.puts "END MESSAGES"
        messages[addr]={}
      end
  	end
    rescue Exception=>e
      puts e
      puts e.backtrace
    end
  end
end