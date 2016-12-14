file=File.open("disk.medsk","r")
sector=file.gets.chomp!
puts sector.inspect
(512-sector.length).times do
  sector+=" "
end
i=0
filename=""
ext=""
sector.each_char do |b|
  case i
    when 0..31
      unless b==" "
       filename+=b
      end
    when 32..36
      unless b==" "
       ext+=b
      end
    when 37..61
     puts "Sector Id byte:#{b.to_i(16)}"
  end
  i+=1
end
file.close
puts filename+"."+ext