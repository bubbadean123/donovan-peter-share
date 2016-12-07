require "socket"
class FTP
  attr_accessor :debug
  def initialize(ip,user,pass,debug=false)
    control=TCPSocket.new(ip,21)
    if user==nil
      puts control.gets
      print "Name (10.0.0.17):"
      user=gets.chomp!
      if debug
        puts "USER #{user}"
        control.puts "USER #{user}"
      else
        control.puts "USER #{user}"
      end
      puts control.gets
      print "Password:"
      pass=gets.chomp!
      if debug
        puts "PASS #{pass}"
        control.puts "PASS #{pass}"
      else
        control.puts "PASS #{pass}"      
      end
      puts control.gets
    else
      if debug
        puts "USER #{user}"
        control.puts "USER #{user}"
        puts control.gets
        puts "PASS #{pass}"
        control.puts "PASS #{pass}"
        puts control.gets
      else
        control.gets
        control.puts "USER #{user}"
        control.gets
        control.puts "PASS #{pass}"
        control.gets
      end
    end
    @debug=debug
    @control=control
  end
  def quit()
    if @debug
      puts "QUIT"
    end
    @control.puts "QUIT"
    puts @control.gets
    @control.close
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
    end
    return result
  end
  def put(contents,file)
    data=pasv()
    if @debug
      puts "STOR #{file}"
      @control.puts "STOR #{file}"
      puts @control.gets
      puts contents
      data.puts contents
      data.close
      puts @control.gets
    else
      @control.puts "STOR #{file}"
      puts @control.gets
      data.puts contents
      data.close
      puts @control.gets
    end
  end
  def cd(dir)
    if @debug
      puts "CWD #{dir}"
      @control.puts "CWD #{dir}"
      puts @control.gets
    else
      @control.puts "CWD #{dir}"
      puts @control.gets
    end
  end
  def pwd()
    if @debug
      puts "PWD"
      @control.puts "PWD"
      puts @control.gets
      puts dir
    else
      @control.puts "PWD"
    end
  end
end