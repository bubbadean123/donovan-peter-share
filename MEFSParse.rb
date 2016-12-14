puts "MEFS sector:"
sector=gets.chomp!
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
  end
  i+=1
end
puts filename+"."+ext