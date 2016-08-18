def new(name)
  tape = {}
  tape["intadress"] = 0
  t = File.open("/Users/anneterpstra/Desktop/Peter's Folder/programming stuff/tapedrive/tapes" + name, "w")
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
  t = File.open("/Users/anneterpstra/Desktop/Peter's Folder/programming stuff/tapedrive/tapes" + name, "r")
  $tape = Marshal.load(t)
  t.rewind()
  t.close() 
end

def eject()
  if $tape != nil
    t = File.open("/Users/anneterpstra/Desktop/Peter's Folder/programming stuff/tapedrive/tapes" + $name, "w")
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
  elsif op == "write"
    puts "Data:"
    data = gets.chomp
    error = write(data)
    if error == "No Tape!"
      puts "Error:"
      puts error
    end
    if error != "No Tape"
    name = $name
    name = nil
    end
  elsif op == "read"
    data = read()
    if data == "No Tape!"
      puts "Error:"
      puts error
    else
      puts "Data:"
      puts data
    end
  elsif op == "rewind"
    puts "Bytes:"
    bytes = gets.chomp
    error = rewind(Integer(bytes))
    if error == "No Tape!"
      puts "Error:"
      puts error
    end
  elsif op == "fast forward"
    puts "Bytes:"
    bytes = gets.chomp
    error = fastforward(Integer(bytes))
    if error == "No Tape!"
      puts "Error:"
      puts error
    end
  elsif op == "insert"
    puts "Name:"
    name = gets.chomp
    error = insert(name)
    if error == "No Tape!"
      puts "Error:"
      puts error
    end
  elsif op == "eject"
    error = eject()
    if error == "No Tape!"
      puts "Error:"
      puts error
     end
  elsif $tape != nil
    puts "Tape:"
    puts $tape
  end
end