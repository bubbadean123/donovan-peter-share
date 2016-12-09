require_relative "./FTPClient.rb"
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
ftp=FTP.new("10.0.0.17",nil,nil,false)
num=""
begin
while true
  print "ftp>"
  arg=gets.chomp!.asplit(" ")
  cmd=arg.shift
  case cmd
  when "ls"
    ftp.list
  when "get"
    ftp.get(arg[0])
  when "put"
    string=""
    done=false
    puts "Contents:(Blank line to end)"
    until done
      line=gets.chomp!
      if line==""
        done=true
        next
      end
      string+="#{line}\n"
    end
    ftp.put(string,arg[0])
  when "cd"
    ftp.cd(arg[0])
  when "quit"
    ftp.quit
    exit
  when "pwd"
    ftp.pwd
  when "toggle"
    case arg[0]
      when "debug"
        ftp.debug=!ftp.debug
    end
  when "show"
    case arg[0]
      when "debug"
        puts ftp.debug
    end
  else
    puts "?Invalid command."
  end
end
end