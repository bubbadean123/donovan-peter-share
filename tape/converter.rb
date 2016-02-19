require "./tapedrive"

drive=TapeDrive.new
puts "Name:"
name=gets.chomp
drive.insert(name)
contents=drive.read()