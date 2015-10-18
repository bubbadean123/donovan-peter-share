$tape=nil
def tape_read(char)
$tape.rewind()
return $tape.read.split("\n")[char]
end
def tape_write(char,data)
tcont=$tape.read.split("\n")
if tcont[char]==nil
tcont.unshift(data)
else
tcont[char]=data
end
puts tcont.inspect
tcont=tcont.join("\n")
$tape.rewind()
$tape.puts(tcont)
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
