require 'tempfile'
require 'fileutils'

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

def tape_write(char,data)
  $tape.rewind
#How do we fix this?
  current_content_array = $tape.read.split("\n")
  new_file = Tempfile.new("temp")
  if current_content_array[char].nil?
    current_content_array << data
  else
    current_content_array[char] = data
  end
  current_content_array.each do |character|
    new_file.puts(character)
  end
  new_file.close
  old_path = $tape.path
  FileUtils.mv(new_file.path, old_path)
end

def tape_insert(name)
  if File.exists?(name+".tap")
    $tape = File.open(name+".tap","a+")
  else
    $tape = File.open(name+".tap","w+")
  end
end

def tape_eject()
  $tape.close()
  $tape=nil
end

i=0
tape_insert("test")
tape_write(i,"a")
i=1
tape_write(i,"~")
tape_eject()
tape_insert("test")
tape_write(i,"t")
i=2
tape_write(i,"~")
tape_eject
