require_relative "./FTP.rb"
def plist(listing)
  i=0
  listing.each do |entry|
   isd=entry[0]
   listing[i]=[]
   listing[i][0]=isd
   listing[i][1]=entry.split(" ")[-1]
   i+=1
  end
  i=0
  listing.each do |entry|
    if entry[0]=="d"
      listing[i]=nil
    end
    i+=1
  end
  listing=listing.compact
  return listing
end
ftp=FTP.new("10.0.0.17","pjht","5002",true)
num=""
begin
while true
  print "upload/download(u/d):"
  op=gets.chomp!
  dir=ftp.list
  dir=plist(dir)
  case op
  when "d"
    i=0
    dir.each do |entry|
      if entry[0]=="-"
        puts "#{i}:#{entry[1]}"
        i+=1
      end
    end
    print "File number:"
    num=gets.chomp!
    if num=="q"
      break
    end
    puts ftp.get(dir[num.to_i][1])
  when "u"
    print "Name:"
    name=gets.chomp!
    string=""
    done=false
    puts "Contents:(Blank line to end)"
    until done
      line=gets.chomp!
      if line==""
        done=true
        next
      end
      string+="#{line}\n"
    end
    puts "Out!!"
    puts "Putting"
    ftp.put(string,name)
    puts "Put successful"
  else
    puts "Please specify u/d"
  end
end
end