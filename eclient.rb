require "socket"
socket=TCPSocket.new("localhost",1024)
print "Address:"
address=gets.chomp!
print "send/get:"
cmd=gets.chomp!
socket.puts cmd
case cmd
when "send"
  socket.puts address
  print "To:"
  to=gets.chomp!
  print "Body:"
  body=gets.chomp!
  socket.puts body
  socket.puts to
when "get"
  socket.puts address
  stop=false
  until stop
    line=socket.gets.chomp!
    if line=="END MESSAGES"
      stop=true
      next
    end
    puts "Email from: #{line} saying"
    line=socket.gets
    puts "#{line}"
  end
end