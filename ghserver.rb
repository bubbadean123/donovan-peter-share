ghdata_path="/Users/anneterpstra/Desktop/Peter's Folder/programming stuff/ghserverdata"
require "socket"
class TCPSocket
def close
puts "Closing connection on #{self.inspect}"
super
end
end
Dir.chdir(ghdata_path)
port = 65535
addr ="10.0.0.2"
server = TCPServer.new(addr, port)
puts server.inspect
client = server.accept
while true
puts client.inspect
comm=client.gets.chomp 
if comm == "end"
client = server.accept
next
end
puts comm.inspect
if comm=="new"
Dir.chdir ghdata_path
data=client.gets.chomp
puts data.inspect
Dir.mkdir data rescue nil
Dir.mkdir data+"/"+"tgit" rescue nil
Dir.chdir data+"/"+"tgit"
f=File.open("commithistory","w")
puts "#<File:"+"commithistory"+":"+"fd"+" "+f.fileno.to_s+">"
Dir.chdir ".."
f.close
Dir.chdir "../.."
elsif comm=="commmit"
name=client.gets.chomp
puts name.inspect
flist = client.gets.chomp
puts flist.inspect
flist = flist.split( ",").map(&:chomp)
puts flist.inspect
elsif comm=="chwr"
data=client.gets.chomp
Dir.chdir data
puts Dir.pwd
end
   end 
server.close
client.close
