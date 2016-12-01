require "io/console"
filelimit=3
$cname="comp"
$path="/bin:."
$root="#{Dir.pwd()}"  
$user=""
$pmod_time=nil
$passwd={}
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
class Dir
  def self.empty?(directory)
    return Dir.entries(directory) == ['.', '..']
  end
end
def read_passwd()
  if $pmod_time!=File.mtime("etc/passwd")
    lines=File.readlines("etc/passwd")
    lines.each do |line|
     if line[0]!="#"
       line=line.chomp.split(",")
       $passwd[line[0]]=line[1]
     end
    end
    $pmod_time=File.mtime("etc/passwd")
  end
end
def getdir(opath)
  path=opath.split("")
  if opath=="/"
    return $root
  elsif path[0]=="/"
    path.shift
    path=path.join("")
    newpath=$root+"/"+path
    return newpath
  elsif path[0]=="~"
    return getdir("/home/#{$user}")
  end
  return path.join("")
end
def login()
  read_passwd()
  uok=false
  until uok
    print "#{$cname} login:"
    $user=gets.chomp!
    print "Password for #{$user}:"
    $password=gets.chomp!
    if $passwd[$user]==$password
      unless $user=="root"
        begin
          Dir.chdir(getdir("/home/#{$user}"))
          uok=true
        rescue
          puts "Login incorrect"
        end
      else
        Dir.chdir(getdir("/root"))
        uok=true
      end
    else
      puts "Login incorrect"
    end
  end
end
login()
while true
	if Dir.pwd==getdir("/home/#{$user}") || ($user=="root" && Dir.pwd==getdir("/root"))
   	print "#{$user}@#{$cname}:~"
  elsif Dir.pwd==getdir("/")
    print "#{$user}@#{$cname}:/"
 	else
    print "#{$user}@#{$cname}:#{Dir.pwd.split("/")[-1]}"
	end
	unless $user=="root"
		print "$ "
	else
		print  "# "
	end
  cmd=gets.chomp!.asplit(" ")
  case cmd[0]
    when "eval"
      eval(cmd[1])
    when "logout"
      login()
    when "shutdown"
      exit
    when "adduser"
      Dir.mkdir("home/#{cmd[1]}")
    when "ls"
      if cmd[1]=="-fl"
        filelimit=cmd[2].to_i
        next
      end
      if cmd[1]
      	if cmd[1][0]=="-"
      		if cmd[2]
      			listing=Dir.entries(cmd[2])
      		end
      	else
      		listing=Dir.entries(cmd[1])
      	end
      else
      	listing=Dir.entries(".")
      end
      unless cmd[1]=="-l" || cmd[1]=="-al"
        i=0
        listing.each do |file|
          unless cmd[1]=="-a"
            unless file[0]=="."
              print file+"  "
              i+=1
            end
          else
            print file+"  "
            i+=1
          end
          if i==filelimit
            puts ""
            i=0
          end
        end
        if i!=0
          puts ""
        end
      else
        unless cmd[1] == "-al"
          listing.each do |file|
            unless file[0] == "."
              puts file+"  "
            end
          end
        else
          listing.each do |file|
            puts file+"  "
          end
        end
      end
    when "cat"
      begin
        lines=File.read(cmd[1]).split("\n")
      rescue
        puts "cat: #{cmd[1]}: No such file or directory"
        next
      end
      lines.each do |l|
        puts l
      end
    when "echo"
      puts cmd[1]
    when "pwd"
      puts Dir.pwd()
    when "touch"
      file=File.open(cmd[1],"w")
      file.close()
    when "cd"
      unless $user=="root" && cmd[1]=="~"
        Dir.chdir(getdir(cmd[1]))
      else
        Dir.chdir(getdir("/root"))
      end
    when "mv"
      File.rename(cmd[1],cmd[2])
    when "mkdir"
    	Dir.mkdir(getdir(cmd[1]))
    when "rm"
    	cmd.shift
    	cmd.each do |file|
    		if File.directory?(file)
    			puts "rm: #{file}: is a directory"
    		else
    			File.delete(file)
    		end
    	end
    when "rmdir"
      if Dir.empty?(getdir(cmd[1]))
      	if File.exist?(getdir(cmd[1]))
        	Dir.rmdir(getdir(cmd[1]))
        else
        	puts "rmdir: #{cmd[1]}: No such file or directory"
        end
      else
        puts "rmdir: failed to remove #{cmd[1]}: Directory not empty"
      end
    else
      path=$path.split(":")
      i=0
      plen=path.length-1
      path.each do |path|
        begin
          file=File.read(getdir(path)+"/"+cmd[0])
          reader, writer = IO.pipe
          fork do
            reader.close
            cmd.shift
            i=0
            args=[]
            cmd.each do |arg|
            	args[i]=arg
            	i+=1
            end
            eval(file)
            writer.puts("Done")
            puts "Sent done"
          end
          writer.close
          while true
          	message=reader.read
          	puts "Got message:#{message.inspect}"
          	if message == "Done\n"
          		break
          	end
          end
          next
        rescue
          if i==plen
            puts "runix: #{cmd[0]}: No such file or directory"
          end
        end
        i=i+1
     end
  end
end