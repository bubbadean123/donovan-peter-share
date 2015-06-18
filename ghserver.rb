require "socket"
Dir.chdir("ghserverdata")
puts Dir.pwd()
port = 65535
addr ="10.0.0.2"
server = TCPServer.new(addr, port)
client = server.accept
while true
puts client.inspect
comm = client.gets 
comm = comm.split(" ")
puts comm.inspect
if comm.shift == "new"
data=comm.shift
puts data.inspect
Dir.mkdir(data) rescue nil
Dir.chdir(data)
Dir.mkdir "tgit" rescue nil
Dir.chdir "tgit"
f=File.open("commithistory","w")
Dir.chdir ".."
f.close
elsif comm == "commmit"
name = comm.shift
puts name.inspect
flist = comm.shift
puts flist.inspect
flist = flist.split( ",").map(&:chomp)
puts flist.inspect
end
client.close
   end 
server.close
client.close
