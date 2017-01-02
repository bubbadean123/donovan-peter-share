def print_transition(t)
  temp=t[3]=="l" ? "left" : "right"
  if t[1]=="*"
    if t[2]=="*"
      if t[3]=="*"
        puts "The transition is: If the state is #{t[0]}, move the head #{temp}, and change the current state to #{t[4]}."
      else
        puts "The transition is: If the state is #{t[0]}, change the current state to #{t[4]}."
      end
    else
      puts "The transition is: If the state is #{t[0]}, change the current symbol to #{t[2]}, move the head #{temp}, and change the current state to #{t[4]}."
    end
  else
    if t[2]=="*"
      if t[3]=="*"
        puts "The transition is: If the state is #{t[0]}, and the current symbol is #{t[1]}, change the current state to #{t[4]}."
      else
        puts "The transition is: If the state is #{t[0]}, and the current symbol is #{t[1]}, move the head #{temp}, and change the current state to #{t[4]}."
      end
    else
      if t[3]=="*"
        puts "The transition is: If the state is #{t[0]}, and the current symbol is #{t[1]}, change the current symbol to #{t[2]}, and change the current state to #{t[4]}."
      else
        puts "The transition is: If the state is #{t[0]}, and the current symbol is #{t[1]}, change the current symbol to #{t[2]}, move the head #{temp}, and change the current state to #{t[4]}."
      end
    end
  end
end
tape=[]
print "Initial tape contents:"
tape=gets.chomp!.split(",")
puts tape.inspect
i=0
tape.each do |v|
  tape[i]="_" if v==" " or v==""
  i+=1
end
head=0
state="0"
tt=File.read("turing logic program.txt")
tt=tt.split("\n")
i=0
tt.each do |v|
  tt[i]=v.split(" ")
  i+=1
end
until state.split("-")[0]=="halt"
  tt.each do |v|
    if v[0]==state and v[1]==tape[head]
      $t=v
      break
    elsif v[0]==state and v[1]=="*"
      $t=v
      break
    end
  end
  t=$t
  puts "The state is #{state}"
  puts "The current tape is #{tape.inspect}"
  puts "The head is at position #{head} and the symbol at the head is #{tape[head]}"
  print_transition(t)
  unless t[2]=="*"
    tape[head]=t[2]
  end
  case t[3]
    when "r"
      head+=1
    when "l"
      head-=1
  end
  state=t[4]
end
tape.each do |v|
  tape[i]=" " if v=="_"
  i+=1
end