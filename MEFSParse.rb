file=File.open("disk.medsk","r")
i=0
filename=""
ext=""
file.each_char do |b|
  case i
    when 0..31
      unless b==" "
       filename+=b
      end
    when 32..35
      unless b==" "
       ext+=b
      end
    when 36..58
     puts "Sector Id byte:#{b.ord.to_s(16)},i:#{i/3}"
    when 59
     puts "Sector Id byte:#{b.ord.to_s(16)}"
     break
  end
  i+=1
end
file.close
puts filename+"."+ext