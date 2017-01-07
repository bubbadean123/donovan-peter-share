window=File.read("README.txt").bytes
i=0
rpl={}
encountered={}
window.each do |b|
  if encountered.keys.include? b
    encountered[b]+=1
    puts "Found repetition of: #{b}"
  else
    encountered[b]=1
    puts "New: #{b}"
  end
i+=1
end
p encountered.sort_by{|b,oc| oc} 
file=File.open("README.pcomp","w")
encountered.each do |k,v|
  if v<=1
    puts "Not replacing: #{k}"
  else
    puts "Replacing: #{k}"
  end
i+=1
end
file.close
puts encountered