require "socket"
class FTP
  def initialize(ip,user,pass,debug=false)
    if debug
      control=TCPSocket.new(ip,21)
      puts control.gets
      puts "USER #{user}"
      control.puts "USER #{user}"
      puts control.gets
      puts "PASS #{pass}"
      control.puts "PASS #{pass}"
      puts control.gets
    else
      control=TCPSocket.new(ip,21)
      control.gets
      control.puts "USER #{user}"
      control.gets
      control.puts "PASS #{pass}"
      control.gets
    end
    @debug=debug
    @control=control
  end
  def pasv()
    if @debug
      puts "PASV"
    end
    @control.puts "PASV"
    line=@control.gets
    if @debug
      puts line
    end
    pdata=line.split(" ")[4].split("(")[1].split(")")[0].split(",")
    ip=pdata[0]+"."+pdata[1]+"."+pdata[2]+"."+pdata[3]
    port=pdata[4].to_i*256+pdata[5].to_i
    return TCPSocket.new(ip,port)
  end
  def list()
    result=[]
    data=pasv()
    if @debug
      puts "LIST"
      @control.puts "LIST"
      puts @control.gets
      while true
        if line=data.gets
          puts line
          result.push(line)
        else
          data.close
          break
        end
      end
      puts @control.gets
    else
      @control.puts "LIST"
      @control.gets
      while true
        if line=data.gets
          result.push(line)
        else
          data.close
          break
        end
      end
      @control.gets
    end
    return result
  end
  def get(file)
    data=pasv()
    result=[]
    if @debug
      puts "RETR #{file}"
      @control.puts "RETR #{file}"
      puts @control.gets
      while true
        if line=data.gets
          puts line
          result.push(line)
        else
          data.close
          break
        end
      end
      puts @control.gets
    else
      @control.puts "RETR #{file}"
      @control.gets
      while true
        if line=data.gets
          result.push(line)
        else
          data.close
          break
        end
      end
      @control.gets
    end
    return result
  end
  def put(contents,file)
    puts "In put"
    data=pasv()
    if @debug
      puts "STOR #{file}"
      @control.puts "STOR #{file}"
      puts @control.gets
      data.puts contents
      data.close
      puts @control.gets
    else
      @control.puts "RETR #{file}"
      @control.gets
      data.puts contents
      data.close
      @control.gets
    end
  end
end