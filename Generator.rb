def gcd(a,b)
if b == 0
return a
else
return gcd(b, a%b)
end
end
def find_coprime(a,z)
if gcd(a,z) == 1
return z
end
find_coprime(a, z + 1)
end
print "Prime 1:"
p1=gets.chomp
p1=p1.to_i
print "Prime 2:"
p2=gets.chomp
p2=p2.to_i
pp=p1*p2
print "Name:"
name = gets.chomp
name = "Keys " + name + ".txt"
keyfile=File.open("./"+name,"w")
keyfile.print "Prime Product:"
keyfile.puts pp
t=(p1-1)*(p2-1)
puts t
e=find_coprime(t,2)
keyfile.print "Encryption Key:"
keyfile.puts e
d=0
i=1
none=true
while none
d=((i*t)+1)/e
if ((i*t)+1)%e == 0
none=false
end
i=i+1
end
keyfile.print "Decryption Key:"
keyfile.puts d