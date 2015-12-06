print "Encryption key:"
e=gets.chomp
e=e.to_i
print "Prime Product:"
n=gets.chomp
n=n.to_i
print "Data:"
d=gets.chomp
d=d.to_i
print "Encrypted Data:"
puts (d**e)%n