require "./tapedrive"

drive=TapeDrive.new
puts "Name:"
name=gets.chomp
drive.insert(name)
contents=drive.read()
f = File.open("#{name}.txt","w")
contents.each_char do |val|
  unless val == "." or val == "!" or val == "?"
    f.print val
  else
    f.print "#{val}\n"
  end
end
f.rewind
f.close