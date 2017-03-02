require "socket"
socket=TCPSocket.new("localhost",1024)
print "Address:"
address=gets.chomp!
socket.puts address
cmd=""
while cmd != "done"
	print "send/get/done:"
	cmd=gets.chomp!
	if cmd=="done"
		next
	else
		socket.puts cmd
	end
	case cmd
	when "send"
		print "To:"
		to=gets.chomp!
		socket.puts to
		print "Body:"
		body=gets.chomp!
		socket.puts body
	when "get"
		stop=false
		until stop
			line=socket.gets.chomp!
			if line=="END MESSAGES"
				stop=true
				next
			end
			puts "Email from #{line} saying"
			line=socket.gets
			puts "#{line}"
		end
	end
end