filelimit=3
$path="/bin:."
$root="#{Dir.pwd()}"
$user=""
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
def getdir(path)
  path=path.split("")
  if path[0]=="/"
    path.shift
    path=path.join("")
    newpath=$root+"/"+path
    return newpath
  elsif path[0]=="~"
    return getdir("/home/#{$user}")
  end
  return path.join("")
end
cname="comp"
print "#{cname} login:"
$user=gets.chomp!
unless $user=="root"
  Dir.chdir(getdir("/home/#{$user}"))
end
while true
	unless Dir.pwd==getdir("/home/#{$user}")
 		print "#{$user}@#{cname}:#{Dir.pwd.split("/")[-1]}"
 	else
 		print "#{$user}@#{cname}:~"
	end
	unless $user=="root"
		print "$ "
	else
		print  "# "
	end
  cmd=gets.chomp!.asplit(" ")
  case cmd[0]
    when "login","logout"
      print "#{cname} login:"
      $user=gets.chomp!
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
      Dir.chdir(getdir(cmd[1]))
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
            eval(file)
            writer.write("Done")
          end
          writer.close
          while true
          	if reader.read == "Done"
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