Dir.chdir("/Users/anneterpstra/Desktop/Peter's Folder/programing stuff/ruby/accounts")
def new_hash(name)
Dir.mkdir(name)
end
def new_hash_entry(name,key,value)
entry = File.open(name+'/'+key, 'w')
entry.print value
entry.rewind()
entry.close()
end
def get_hash_entry(name,key)
entry = File.open(name+'/'+key, 'r')
value = entry.gets
entry.rewind()
entry.close()
return value
end
i = 0
while true
print "Op:"
op = gets.chomp
if op == "new"
print "Name:"
name = gets.chomp
print "Pass:"
pass = gets.chomp
new_hash(name)
new_hash_entry("passwords",name,pass)
new_hash_entry("login\ status", name, "no")
end
if op == "write"
print "Name:"
name = gets.chomp
if get_hash_entry("login\ status",name) == "yes"
print "Adress:"
adress = gets.chomp
print "Data:"
data = gets.chomp
new_hash_entry(name,adress,data)
else
puts "Not logged in"
end
end
if op == "read"
print "Name:"
name = gets.chomp
if get_hash_entry("login\ status",name) == "yes"
print "Adress:"
adress = gets.chomp
data = get_hash_entry(name,adress)
puts data
else
puts "Not logged in"
end
end
if op == "stop"
break
end
if op == "login"
print "Name:"
name = gets.chomp
print "Pass:"
pass = gets.chomp
if Integer(pass) == Integer(get_hash_entry("passwords",name))
new_hash_entry("login\ status", name, "yes")
else
puts "Invalid Password"
end
end
if op == "logout"
print "Name:"
name = gets.chomp
new_hash_entry("login\ status", name, "no")
end
end