require "socket"
require "stringio"
class String
  def asplit(delimiter)
    result=[]
    escape=false
    string=""
    i=0
    self.each_char  do |c|
      if c=="\\"
        escape=true
      elsif c==delimiter
        unless escape
          result.push(string)
          string=""
        else
          string+=delimiter
          escape=false
        end
      else
        string+=c
      end
    end
    if string != ""
      result.push string
    end
    return result
  end
end
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
mserv = TCPServer.new(addr,1024)
puts "Started Server on #{addr}:#{port}"
while true
  Thread.start(server.accept) do |client|
    puts "got conn"
    client.puts "220 PFTP"
    while true
      data=client.gets.asplit(" ")
      data[0].chomp!
      puts "Got:#{data[0].inspect}"
      puts "Raw: #{data.inspect}"
      case data[0]
        when "USER"
          puts "Setting user to #{data[1]}"
          user=data[1]
          puts "User:#{user}"
          client.puts "331 Please specify the password."
        when "PASS"
          puts "Setting pass to #{data[1]}"
          pass=data[1]
          puts "Pass:#{pass}"
          client.puts "230 Login successful."
        when "RETR"
          puts "Retrieving #{data[1].chomp}"
          client.puts "101 Sending file."
          lines=File.read(data[1].chomp).split("\n")
          lines.each do |l|
            client.puts l
          end
          client.puts "205 Sent file."
        when "LIST"
          puts "Sending directory listing."
          listing=Dir.entries(".")
          client.puts "201 Here comes the directory listing."
          #client.puts "150 Here comes the directory listing."
          listing.each do |entry|
            unless entry[0]=="."
              puts "Sending entry"
              client.puts entry
              puts "Sent entry"
            end
          end
          #puts "Sent"
          client.puts "202 Direcory send OK."
          #client.puts "226 Directory send OK."
          #client.puts ""
          #puts "Sent OK"
        when "PASV"
					puts "Listening on 1024"
					puts "Sending pasv message"
					client.puts "227 Entering Passive Mode (10,0,0,33,4,0)."
					puts "Sent pasv message"
					puts "Accepting"
					conn=mserv.accept
					puts "Accepted"
        when "STOR"
          file=File.open(data[1],"w")
          client.puts "301 Send file."
          done=false
          until done
            line=client.gets
            puts "Got line:#{line.inspect}"
            if line=="102 Done.\n" || line=="102 Done.\r\n"
            	puts "We're done"
            	done=true
            	next
          	else
          		file.puts line
          	end
          end
          puts "OUUT!"
          client.puts "204 Stored"
          file.close
        when "CWD"
          puts "Changing directory to: #{data[1].inspect}"
          data[1].chomp!
          puts "Changing directory to: #{data[1].inspect}"
          Dir.chdir(data[1])
          puts "Changed"
          client.puts "206 Directory successfully changed."
      	when "PWD"
      		client.puts "207 Directory:#{Dir.pwd}"
        else
          puts "No such command"
          client.puts "502 Command not implemented."
      end
    end
  end
end