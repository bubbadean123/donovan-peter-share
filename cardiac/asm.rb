class String
  def fix(size, padstr=' ')
    self[0...size].rjust(size, padstr)
  end
end
insset={"INP"=>0,"LOD"=>1,"ADD"=>2,"TAC"=>3,"SFT"=>4,"OUT"=>5,"STO"=>6,"SUB"=>7,"JMP"=>8,"HRS" =>9}
conv={}
dat=[]
dlabeltable={}
plabeltable={}
memcounter=3
puts ".asm file:"
infile = gets.chomp
unless infile.include? ".asm"
  infile=infile+".asm"
end
outfile=infile.gsub(".asm",".cards")
infilef=File.open(infile,"r")
outfilef=File.open(outfile,"w")
outfilef.puts "002"
outfilef.puts "800"
infilef.each_line do |line|
  if line.include? ":"
    line=line.split(":")
    dlabeltable[line[0]]=memcounter
    memcounter += 1
  else
    memcounter += 1
  end
end
memcounter=3
infilef.rewind
infilef.each_line do |line|
  oline=line
  line=line.split(" ")
  if line[0] == "DAT"
    dat.push(line[1])
    next
  end
  result = Integer(line[1]) rescue false
  if result == false
    if oline.include? ":"
      sline=oline.split(":")
      sline[1].chomp!
      outfilef.puts "%03d" % dlabeltable[sline[0]]
      outfilef.puts sline[1].fix(3,"0")
      next
    else
      line[1]="%02d" % dlabeltable[line[1]]
      op=insset[line[0]].to_s
      if op == ""
        puts "Invalid opcode"
        next
      end
    end
  else
    op=insset[line[0]].to_s
  end
  arg=line[1]
  outfilef.puts "%03d" % memcounter
  puts op
  puts arg
  puts op+arg
  outfilef.puts op+arg
  memcounter=memcounter+1
end
outfilef.puts "002"
outfilef.puts "803"
dat.each do |val|
  outfilef.puts val.fix(3,"0")
end