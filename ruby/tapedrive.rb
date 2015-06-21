def new(name)
tape = {}
tape["intadress"] = 0
t = File.open("/Users/anneterpstra/Desktop/tapes/" + name, "w")
Marshal.dump(tape, t)
t.rewind()
t.close()
end
def write(data)
if $tape != nil
adress = $tape["intadress"]
$tape[adress] = data
$tape["intadress"] += 1
else
return "No tape!"
end	 
end
def read()
if $tape != nil
adress = $tape["intadress"]
data = $tape[adress]
$tape["intadress"] += 1	
return data
else
return "No tape!"
end	
end
def rewind(bytes)
if $tape != nil
$tape["intadress"] -= bytes
else
return "No tape!"
end	
end
def fastforward(bytes)
if $tape != nil
$tape["intadress"] += bytes
else
return "No tape!"
end
end

def insert(name)
$name = name
t = File.open("/Users/anneterpstra/Desktop/tapes/" + name, "r")
$tape = Marshal.load(t)
t.rewind()
t.close() 
end

def eject()
if $tape != nil
t = File.open("/Users/anneterpstra/Desktop/tapes/" + $name, "w")
Marshal.dump($tape, t)
t.rewind()
t.close()
$name = nil
$tape = nil
else
return "No tape!"
end
end
while true
puts "Op:"
op = gets.chomp
if op == "new"
puts "Name:"
name = gets.chomp
new(name)
end
if op == "write"
puts "Data:"
data = gets.chomp
error = write(data)
if error == "No Tape!"
puts "Error:"
puts error
end
if error != "No Tape"
name = $name
eject()
insert(name)
name = nil
end
if op == "read"
error = read()
if error == "No Tape!"
puts "Error:"
puts error
else
puts "Data:"
puts error
end
end
if op == "rewind"
puts "Bytes:"
bytes = gets.chomp
error = rewind(Integer(bytes))
if error == "No Tape!"
puts "Error:"
puts error
end
end
if op == "fast forward"
puts "Bytes:"
bytes = gets.chomp
error = fastforward(Integer(bytes))
if error == "No Tape!"
puts "Error:"
puts error
end
end
if op == "insert"
puts "Name:"
name = gets.chomp
error = insert(name)
if error == "No Tape!"
  puts "Error:"
  puts error
end
end
if op == "eject"
 error = eject()
 if error == "No Tape!"
  puts "Error:"
  puts error
 end
end
if $tape != nil
puts "Tape:"
puts $tape
end
end