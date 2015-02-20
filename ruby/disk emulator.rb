require "FileUtils"

Dir.chdir("/Users/anneterpstra/Desktop/disks")
def new_disk(name)
end
def new_disk_entry(name, segment, sector, line, data)
Dir.chdir("/Users/anneterpstra/Desktop/disks")
if Dir.exists?("/Users/anneterpstra/Desktop/disks/" + name)
else
puts "Disk does not exist!"
return NilClass
end
if Dir.exists?("/Users/anneterpstra/Desktop/ejected disks/" + name)
puts "Disk is ejected!"
return NilClass
end
Dir.chdir(name + "/" + "segment " + String(segment) + "/" + "sector " + String(sector))
line = File.open("line " + String(line), "w")
line.puts data
line.rewind()
line.close()
end
def get_disk_entry(name, segment, sector, line)
Dir.chdir("/Users/anneterpstra/Desktop/disks/")
if Dir.exists?("/Users/anneterpstra/Desktop/disks/" + name)
else
puts "Disk does not exist!"
return "error"
end
if Dir.exists?("/Users/anneterpstra/Desktop/ejected disks/" + name)
puts "Disk is ejected!"
return "error"
end
Dir.chdir(name + "/" + "segment " + String(segment) + "/" + "sector " + String(sector))
line = File.open("line " + String(line), "r")
data = line.gets
line.rewind()
line.close()
return data
end
def eject_disk(name)
Dir.chdir("/Users/anneterpstra/Desktop/disks")
if Dir.exists?("/Users/anneterpstra/Desktop/disks/" + name)
else
puts "Disk does not exist!"
return NilClass
end
if Dir.exists?("/Users/anneterpstra/Desktop/ejected disks/" + name)
puts "Disk is already ejected!"
return NilClass
end
Dir.chdir("/Users/anneterpstra/Desktop/disks")
FileUtils.mv(name,"/Users/anneterpstra/Desktop/ejected disks/" + name)
end
def insert_disk(name)
if Dir.exists?("/Users/anneterpstra/Desktop/disks/" + name)
puts "Disk is already inserted!"
return NilClass
end
Dir.chdir("/Users/anneterpstra/Desktop/ejected disks")
FileUtils.mv(name,"/Users/anneterpstra/Desktop/disks/" + name)
end
def remove_disk(name)
FileUtils.rm_rf("/Users/anneterpstra/Desktop/ejected disks/"+name, secure: true)
FileUtils.rm_rf("/Users/anneterpstra/Desktop/disks/"+name, secure: true)
end
while true
puts "Op:"
op = gets.chomp
if op == "new disk"
puts "Name:"
name = gets.chomp
new_disk(name)
end
if op == "new entry"
error = false
puts "Name:"
name = gets.chomp
if Dir.exists?("/Users/anneterpstra/Desktop/ejected disks/" + name)
puts "Disk is ejected!"
error = true
else
if Dir.exists?("/Users/anneterpstra/Desktop/disks/" + name)
else
puts "Disk does not exist!"
error = true
end
end
if error == false
puts "Segment:"
segment = gets.chomp
puts "Sector:"
sector = gets.chomp
puts "Line:"
line = gets.chomp
puts "Data:"
data = gets.chomp
new_disk_entry(name, segment, sector, line, data)
end
end
if op == "get entry"
error = false
puts "Name:"
name = gets.chomp
if Dir.exists?("/Users/anneterpstra/Desktop/ejected disks/" + name)
puts "Disk is ejected!"
error = true
else
if Dir.exists?("/Users/anneterpstra/Desktop/disks/" + name)
else
puts "Disk does not exist!"
error = true
end
end
if error == false
puts "Segment:"
segment = gets.chomp
puts "Sector:"
sector = gets.chomp
puts "Line:"
line = gets.chomp
data = get_disk_entry(name, segment, sector, line)
if data != "error"
puts "Data:"
puts data
end
end
end
if op == "eject disk"
puts "Name:"
name = gets.chomp
eject_disk(name)
end
if op == "insert disk"
puts "Name:"
name = gets.chomp
insert_disk(name)
end
if op == "remove disk"
puts "Name:"
name = gets.chomp
remove_disk(name)
end
if op == "stop"
break
end
end