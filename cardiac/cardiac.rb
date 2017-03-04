class Integer
  def digits
    Enumerator.new do |x|
      to_s.chars.map{|c| x << c.to_i }
    end
  end
end
in_cards=[]
out_cards=[]
loading=true
mem=[001,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,800]
acc=0
pc=0
print ".cards file:"
infile=gets.chomp
unless infile.include? ".cards"
  infile=infile+".cards"
end
File.readlines(infile).each do |line|
in_cards.push(line.to_i)  
end
puts "Step/Run(s/r):"
steprun=gets.chomp
while true
  ins=mem[pc]
  p ins
  pc=pc+1
  op=ins/100
  addr=ins%100
  unless loading
    puts "Op:#{op}"
    puts "Addr:#{addr}"
    case op
    when 0
      if in_cards.length==0
          puts "No more cards"
          puts "Cards:"
          puts out_cards
          break
      else
          card=in_cards.shift
          puts "Setting mem[#{addr}] to card #{card}"
          mem[addr]=card
        end
    when 1
      puts "Setting accumulator to mem[#{addr}]"
      acc=mem[addr]
    when 2
      puts "Setting accumulator to accumulator plus mem[#{addr}]"
      acc=acc+mem[addr]
    when 3
      if acc < 0
        puts "Accumulator negative, jumping to #{addr}"
        pc = addr
      end
    when 4
      l=a/10
      r=a%10
      puts "Shifting accumulator left #{l} digits and right #{r} digits"
      acc=accx10^l/10^r
    when 5
      puts "Outputting mem[#{addr}]"
      out_cards.push(mem[addr])
    when 6
      puts "Setting mem[#{addr}] to accumulator"
      mem[addr]=acc
     when 7
      puts "Setting accumulator to accumulator minus mem[#{addr}]"
      acc=acc-mem[addr]
     when 8
      puts "Storing program counter in location 99 and jumping to location #{addr}"
      d=pc.digits.to_a
      mem[99]=d.unshift(8)
      pc=addr
     when 9
      puts "Halted"
      pc=a
      puts "Cards:"
      puts out_cards
      break
     end
    puts "PC:#{pc}"
    puts "Accumulator:#{acc}"
    if steprun=="s"
      puts "Stop/Continue(s/c)"
      temp=gets.chomp
      if temp=="s"
        break
      end
    end
  else
    case op
    when 0
      if in_cards.length==0
        break
      else
        card=in_cards.shift
        mem[addr]=card
      end
    when 8
      d=pc.digits.to_a
      mem[99]=d.unshift(8)
      pc=addr
      if addr==3
        loading=false
      end
    end
  end
end

memfile=File.open(infile.gsub(".cards",".mem"),"w")
outfile=File.open(infile.gsub(".cards",".out"),"w")
mem.each do |v| 
  memfile.puts v
end
out_cards.each do |v|
  outfile.puts v
end
memfile.rewind
memfile.close
outfile.rewind
outfile.close