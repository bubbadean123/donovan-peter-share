require "socket"
class PFTP
  attr_accessor :debug
  def initialize(ip,debug=false)
    conn=TCPSocket.new(ip,65534)
    @debug=debug
    @conn=conn
    return @conn.gets.chomp!
  end
  def get(file)
    puts "RETR #{file}" if @debug
    @conn.puts "RETR #{file}"
    result=[]
    while true
      line=@conn.gets.chomp!
      puts line if debug
      if line=="201 Sent file." 
        return result
      elsif line=="502 File not found."
        return nil
      else
        result.push line
      end
    end
  end
  def put(file,contents)
    @conn.puts "STOR #{file}"
    puts @conn.gets if debug
    @conn.gets unless debug
    puts contents if debug
    @conn.puts contents
    @conn.puts "SENT"
    puts @conn.gets if debug
    @conn.gets unless debug
  end
  def ls()
    puts "LIST" if @debug
    @conn.puts "LIST"
    result=[]
    line=@conn.gets.chomp!
    until line=="202 Directory send OK."
      result.push line
      line=@conn.gets.chomp!
    end
    return result
  end
  def quit()
    @conn.close
  end
end
pftp=PFTP.new("10.0.0.33")
listing=pftp.ls
i=1
files=[]
listing.each do |entry|
  if entry.split(".").length==2
    puts "#{i}. #{entry}"
    files[i]=entry
    i+=1
  end
end
print "Number:"
num=gets.chomp.to_i
puts pftp.get(files[num])