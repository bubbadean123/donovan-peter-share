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
begin
  server=TCPSocket.new(local_ip,"65534")
rescue => e
  puts e
  exit
else
end
puts server.gets
while true
  print "pftp>"
  arg=gets.chomp!.asplit(" ")
  cmd=arg.shift
  case cmd
  when "get"
    server.puts "RETR "+arg[0]
    while true
      line=server.gets.chomp!
      puts line
      if line=="201 Sent file." or line=="501 File not found."
        break
      end
    end
  when "ls"
    server.puts "LIST"
    while true
      line=server.gets.chomp!
      puts line
      if line=="203 Directory send OK."
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
    server.puts string
    server.puts "102 Done."
    puts server.gets
  when "rn"
    server.puts "RNF #{arg[0]}"
    line=server.gets.chomp!
    puts line
    unless line=="501 File not found."
      server.puts "RNT #{arg[1]}"
      puts server.gets
    end
  when "quit"
    server.close
  else
    server.puts cmd+" "+arg[0]
    puts server.gets
  end
end