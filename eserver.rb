require "socket"
messages={}
Thread::abort_on_exception=true
server = TCPServer.new 1024
puts "Server running on localhost:1024"
loop do
    Thread.start(server.accept) do |client|
    begin
      puts "Got connection"
      cmd=client.gets.chomp!
      case cmd
      when "send"
        sender=client.gets.chomp!
        puts "Line:#{sender}"
        text=client.gets.chomp!
        puts "Line:#{text}"
        address=client.gets.chomp!
        puts "Line:#{address}"
        emails=messages[address]
        if !emails
          emails={}
        end
        emails[rand(2147483647)]={"text"=>text,"sender"=>sender}
        messages[address]=emails
        print messages
      when "get"
        sender=client.gets.chomp!
        messages[sender].each do |id,email|
          p email
          p email[sender]
          p email[text]
          client.puts email["sender"]
          client.puts email["text"]
        end
        client.puts "END MESSAGES"
      end
    rescue Exception=>e
      puts e
      puts e.backtrace
    end
  end
end