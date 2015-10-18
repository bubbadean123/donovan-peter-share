$tape=nil

def tape_read(char)
  $tape.rewind()
  return $tape.read.split("\n")[char]
end

# def tape_write(char,data)
#   tcont=$tape.read.split("\n")
#   puts tcont.inspect
#   if tcont[char]==nil
#     tcont.unshift(data)
#   else
#     tcont[char]=data
#   end
#   puts tcont.inspect
#   tcont=tcont.join("\n")
#   puts "About to write string #{tcont}"
#   $tape.rewind
#   $tape.puts(tcont)
# end

def tape_write(char,data,content=[])
  $tape.rewind
  #How do we fix this?
  if content.empty?
    current_content_array = $tape.read.split("\n")
  else
    current_content_array = content
  end
  $tape.rewind
  puts "Current content in tape: #{current_content_array}"
  current_content_array[char] = data
  puts "Setting pos #{char} to #{data}, altered array: #{current_content_array}"
  current_content_array.compact!
  current_content_array.each do |character|
    puts "Writing #{character} to file"
    $tape.puts(character)
  end
end

def tape_insert(name)
  current_content = []
  if File.exists?(name+".tap")
    current_content = File.read(name+".tap").split("\n")
  end

  $tape = File.open(name+".tap","w+")
  return current_content
end

def tape_eject()
  $tape.close()
  $tape=nil
end

i=0
content = tape_insert("test")
tape_write(i,"a",content)
i=1
tape_write(i,"~",content)
tape_eject()
content = tape_insert("test")
tape_write(i,"t",content)
i=2
tape_write(i,"~",content)
tape_eject
