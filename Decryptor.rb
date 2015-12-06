print "Decryption key:"
d=gets.chomp
d=d.to_i
print "Prime Product:"
n=gets.chomp
n=n.to_i
print "Encrypted Data:"
r=gets.chomp
r=r.to_i
print "Data:"
puts (r**d)%n