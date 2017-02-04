print "Program:"
pname=gets.chomp!
$vars={}
brkp=[]
print "Enter breakpoints separated by commas:"
brkp=gets.chomp!.split(",")
def rpl_var(str)
  str.chomp!
  vname=""
  pexp=""
  str.each_char do |c|
    if vname.length==0
      if /\d|[+-<>=!. ]/.match(c)
        if $vars.key? vname
          pexp+=$vars[vname].to_s+c
          vname=""
        else
         pexp+=vname+c
         vname=""
        end
      else
        vname+=c
      end
   else
     if /\W/.match(c)
      if $vars.key? vname
        pexp+=$vars[vname].to_s+c
        vname=""
      else
       pexp+=vname+c
       vname=""
      end
    else
      vname+=c
    end
    end
  end
  if $vars.key? vname
    pexp+=$vars[vname].to_s
  elsif vname!=nil
    pexp+=vname
  end
  return pexp
end
stpmode=false
prog=File.readlines(pname)
lineno=1
prog.each do |l|
  puts "Line:#{lineno}"
  if l.split("=").length==2
    exp=l.split("=")
    pexp=rpl_var(exp[1])
    $vars[exp[0]]=eval(pexp)
  else
    pexp=rpl_var(l)
    puts pexp
    eval(pexp)
  end
  if lineno==prog.length
    break
  end
  if brkp.include? lineno
    stpmode=true
    puts "STOOOP"
  end
  if stpmode
    stop=false
    until stop
      print "main[#{lineno}]"
      cmd=gets.chomp!
      case cmd
      when "next","n"
        stop=true 
      when "cont","c"
        stop=true
        stpmode=false
      else
        if $vars.key? cmd
          puts $vars[cmd]
        else
          pexp=""
          cmd.chomp.each_char do |c|
            if $vars.key? c
              pexp+=$vars[c].to_s
            else
              pexp+=c
            end
          end
          begin
            puts "#{eval(pexp)}"
          rescue NameError
            puts "nil"
          end
        end
      end
    end
  else
  end
  lineno+=1
end