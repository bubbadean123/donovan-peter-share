require "socket"
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
server=nil
while true
  print "pftp>"
  arg=gets.chomp!.asplit(" ")
  cmd=arg.shift
  if server
    case cmd
    when "get"
      server.puts "RETR "+arg[0]
      while true
        line=server.gets.chomp!
        puts line
        if line=="201 Sent file." or line=="502 File not found."
          break
        end
      end
    when "ls"
      server.puts "LIST"
      while true
        line=server.gets.chomp!
        puts line
        if line=="202 Directory send OK."
          break
        end
      end
    when "put"
      string=""
      length=0
      while true
        line=gets.chomp!
        unless line==""
          length+=1
        else
          break
        end
        string+="#{line}\n"
      end
      server.puts "STOR "+arg[0]
      puts server.gets
      puts string
      server.puts string
      server.puts "SENT"
      puts server.gets
    when "rn"
      server.puts "RNF #{arg[0]}"
      line=server.gets.chomp!
      puts line
      unless line=="502 File not found."
        server.puts "RNT #{arg[1]}"
        puts server.gets
      end
    when "rm"
      server.puts "DEL #{arg[0]}"
      puts server.gets
    when "quit","exit"
      server.close
      exit
    when "close"
      if server
        server.close
      end
    when "LIST"
      server.puts cmd
      puts server.gets
      puts server.gets
    else
      puts arg.inspect
      if arg==[]
        server.puts cmd
      else
        server.puts cmd+" "+arg[0]
      end  
      puts server.gets
    end
  else
    case cmd
    when "quit","exit"
      exit
    when "open"
      if server
        puts "Already connected to use close first"
      else
        begin
          server=TCPSocket.new(arg[0],arg[1])
          puts server.gets.chomp!
        rescue => e
          puts "Can't connect to #{arg[0]}: #{e.message}"
        else
          puts "Connected to #{arg[0]}"
        end
      end
    else
      puts "Not connected."
    end
  end
end