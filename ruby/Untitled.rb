def printdisp(string)
string.split("")
d = File.open("display","w")
if string.length <= 16
for x in 0..15
d.print string[x]
end
else
for i in 0..1
for x in 0..15
d.print string[x]
end
d.puts""
end
end
end
printdisp("0=9")
