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
def fix(cmd)
cmdst=cmd[0]
cmd.shift
return cmdst+" "+cmd.join(" ").gsub(" ","\\ ")
end
begin
  server=TCPSocket.new("10.0.0.33","65534")
rescue => e
  puts e
  exit
else
end
puts server.gets
while true
  print "pftp>"
  cmd=gets.chomp!.asplit(" ")
  case cmd[0]
  when "LPWD"
    puts "Local directory: #{Dir.pwd}"
  when "GET","LIST"
    server.puts fix(cmd)
    lines=server.gets.to_i
    lines.times do
      puts "#{server.gets}"
    end
  when "PUT"
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
    server.puts fix(cmd)
    server.puts length
    server.puts string
  when "QUIT"
    server.close
  else
    server.puts fix(cmd)
    puts server.gets
  end
end