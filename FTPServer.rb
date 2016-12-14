require "socket"
require "stringio"
Thread::abort_on_exception=true
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
    puts "Got connection from #{client.local_address.getnameinfo[0]}"
    client.puts "220 PFTP"
    while true
      data=client.gets
      puts "Raw:#{data.inspect}"
      if data==nil
        break
      end
      data=data.asplit(" ")
      cmd=data[0].chomp
      if data[1]==nil
        data[1]=""
      end
      arg=data[1].chomp
      puts "Got:#{cmd} #{arg.inspect}"
      case cmd
        when "USER"
          puts "Setting user to #{arg}"
          user=arg
          puts "User:#{user}"
          client.puts "331 Please specify the password."
        when "PASS"
          puts "Setting pass to #{arg}"
          pass=arg
          puts "Pass:#{pass}"
          client.puts "230 Login successful."
        when "RETR"
          puts "Retrieving #{arg}"
          client.puts "150 Opening ASCII mode connection for #{arg} (#{File.size(arg)} bytes)."
          if File.exist? arg
            file=File.read(arg).gsub("\n","\r\n")
            $conn.print file
            client.puts "226 Transfer complete."
            $conn.close
          else
            client.puts "502 File not found."
          end
        when "SIZE"
          client.puts "213 #{File.size(arg)}"
        when "MDTM"
          mtime=File.mtime(arg).getutc.strftime("%Y%m%d%H%M%S")
          client.puts "213 #{mtime}"
        when "LIST"
          puts "Sending directory listing."
          listing=Dir.entries(".")
          client.puts "150 Here comes the directory listing."
          listing.each do |entry|
            unless entry[0]=="."
              puts "Sending entry #{entry.inspect}"
              $conn.puts entry+"\r"
              puts "Sent entry"
            end
          end
          puts "Sent"
          client.puts "226 Directory send OK."
          $conn.close
          puts "Sent OK"
        when "PORT"
          addr=arg.split(",")
          i=0
          ip=""
          port=0
          addr.each do |val|
          	puts "Before, i:#{i},val:#{val},ip:#{ip},port:#{port}"
          	if i<=2
          		ip+=val+"."
          	elsif i==3
          		ip+=val
            elsif i==4
            	port+=val.to_i*256
            elsif i==5
            	port+=val.to_i
          	end
          	i+=1
          	puts "After, i:#{i},val:#{val},ip:#{ip},port:#{port}"
          end
          puts ip
          puts port
          puts "Connecting"
          $conn=TCPSocket.new(ip,port)
          puts "Connected"
        when "PASV"
          addr=arg.split(",")
          puts "Sent pasv message"
          puts "Accepting"
          $conn=mserv.accept
          puts "Accepted"
          puts $conn.inspect
          puts client.inspect
        when "STOR"
          file=File.open(arg,"w")
          client.puts "301 Send file."
          done=false
          until done
            line=client.gets.chomp!
            puts "Got line:#{line.inspect}"
            if line=="SENT"
            	puts "We're done"
            	done=true
            	next
          	else
          		file.puts line
          	end
          end
          client.puts "203 Stored."
          file.close
        when "CWD"
          puts "Changing directory to: #{arg.inspect}"
          Dir.chdir(arg)
          puts "Changed"
          client.puts "204 Directory successfully changed."
      	when "PWD"
      		client.puts "257 \"#{Dir.pwd}\" is the current directory."
        when "RNF"
          if File.exist? arg
            rnf=arg
            client.puts "302 Waiting for RNT"
          else
            client.puts "502 File not found."
          end
        when "RNT"
          File.rename(rnf,arg)
          client.puts "207 Renamed."
        when "DEL"
          if File.exist? arg
            File.delete(arg)
            client.puts "208 Deleted."
          else
            client.puts "502 File not found."
          end
        when "QUIT"
          client.puts "221 Goodbye."
          client.close
          break
        else
          puts "No such command"
          client.puts "501 Syntax error"
      end
    end
  end
end