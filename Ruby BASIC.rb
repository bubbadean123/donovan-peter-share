$sline=0
$vname=""
$max=0
$step=0
$breakline=0
$b=binding
def nextline(prog,lineno)
  keys=prog.keys 
  lnoi=keys.index(lineno) || -1
  return keys[lnoi+1]
end
def prevline(prog,lineno)
  best=0
  prog.each_key do |k|
    if k < lineno && best < k
      best=k
    elsif k==lineno
      return best
    end
  end
end
def extract(string)
  extracted=""
  instring=false
  string.each_char do |c|
    if c=="\"" or c=="'"
      if instring
        break
      else
        instring=true
      end
    else
      if instring
        extracted+=c
      end
    end
  end
  return extracted
end
def subvars()
end
def execute(lineno,line,retlist,debug,nextl,nextl2)
  cmd=line[0]
  case cmd
  when "FOR"
    if debug
      puts "FOR #{line[1]} = #{line[3]} to #{line[5]}"
    end
    if $sline == 0
      $breakline=0
      eval("#{line[1].downcase}=#{line[3]}",$b)
      $sline=lineno
      $vname=line[1]
      $max=line[5].to_i
      $step=line[7].to_i
      if $step==0
        $step=1
      end
    end
  when "NEXT"
    $breakline=nextl
    if debug
      puts "NEXT"
    end
    var=eval($vname.downcase,$b)
    var+=$step
    if var > $max
      $sline=0
    else
      eval("#{$vname.downcase}=#{var}",$b)
      return $sline,true,retlist
    end
  when "BREAK"
    $sline=0
    if $breakline==0
      puts "Cannot break, in first iteration"
    end
    return $breakline+1,true,retlist
  when "PRINT"
    if debug
      puts "PRINT #{line[1]}"
    end
    if line[1].class==String
      old=line[1]
      temp=extract(line[1])
      if temp==""
        temp=eval(old.downcase,$b)
      end
    end
    puts temp
  when "IF"
  if debug
    puts "IF #{line[1]} #{line[2]} #{line[3]} #{line[4]} #{line[5]} #{line[6]}"
  end
  if line[1].class==String
    old=line[1]
    temp=extract(old)
    if temp==""
      temp=eval(old.downcase,$b)
    end
  end
  l1=temp
  cond="\"#{l1.downcase}\" #{line[2]} \"#{line[3].downcase}\""
  res=eval(cond)
  if res
    puts "#{cond}, so running #{line[5]} #{line[6]}"
    line,cont,retlist=execute(lineno,[line[5],line[6]],retlist,debug,nextl2,0)
    return line,cont,retlist
  end
  when "GOTO"
    if debug
      puts "GOTO #{line[1]}"
    end
    current=line[1].to_i
  when "INPUT"
    if debug
      puts "INPUT #{line[1]}"
    end
    inp=gets.chomp!
    eval("#{line[1].downcase}="+"\""+inp+"\"",$b)
  when "LET"
    if debug
      puts "LET #{line[1]}"
    end
    eval(line[1],$b)
  when "GOSUB"
    if debug
      puts "GOSUB #{line[1]}"
    end
    oldl=lineno
    lineno=line[1].to_i
    retlist.push(oldl+1)
  when "RETURN"
    if debug
      puts "RETURN"
    end
    lineno=retlist.pop
    puts "New lineno:#{lineno}"
  when "END"
    if debug
      puts "END"
    end
    return lineno,false,retlist
  end
  return nil,true,retlist
end
def run(prog,debug)
  lineno=nextline(prog,0)
  while true do
    retlist=[]
    line=prog[lineno]
    nextl=nextline(prog,lineno)
    nlineno,cont,retlist=execute(lineno,line,retlist,debug,nextl,nextline(prog,nextl))
    if !nlineno
      unless line[0]=="GOTO" or line[0]=="GOSUB" or line[0]=="RETURN"
        lineno=nextline(prog,lineno)
      end
    else
      lineno=nlineno
    end
    unless cont
      break
    end
  end
end
prog={}
debug = false
while true do
  print ">"
  cmd,*args=gets.chomp!.split(" ")
  cmd=cmd.upcase
  case cmd
  when "RUN"
    run(prog,debug)
  when "LIST"
    prog.each do |lno,v|
      print "#{lno} "
      v.each do |v|
        print v+" "
      end
      puts
    end
  when "CLEAR"
    prog=""
  when "DEBUG"
    if args[0].upcase=="ON"
      puts "ON"
      debug=true
    elsif args[0].upcase=="OFF"
      puts "OFF"
      debug=false
    else
      if debug
        puts "YES"
      else
        puts "NO"
      end
    end
  else
    i=0
    args.each do |v|
      args[i]=v.upcase
      i+=1
    end
    prog[cmd.to_i]=args
  end
end