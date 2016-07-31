require "socket"
class String
  def split_esc()
    escape_char=false
    strings=[]
    substring=""
    self.each_char do |char|
      if char=="\\" and escape_char==true
        substring+="\\"
        escape_char=false
      elsif char=="\\" and escape_char==false
        escape_char=true
      elsif char==" " and escape_char==true
         substring+=" "
         escape_char=false
      elsif char==" " and escape_char==false
         strings.push(substring)
         substring=""
         escape_char=false
      else
         substring+=char
         escape_char=false
      end
    end
    strings.push(substring)
    substring=""
    return strings
  end
end
cname=Socket.gethostname
fdir=File.expand_path(File.dirname(__FILE__))
file="#{fdir}/#{cname}-repos.txt"
puts "Load(Y/N)"
loadv=gets.chomp
if loadv=="y" or loadv=="Y"
  if File.exist?(File.expand_path(file))
    repos=File.open(File.expand_path(file),"r")
    list=repos.read.split("\n")
    path=""
    while !Dir.exist?(path)
      unless list.length==1
        i=1
        list.each do |repo|
          repo=repo.split("/")[-1]
          puts "#{i}. #{repo}"
          i=i+1
        end
        path=list[gets.chomp.to_i-1]
        if path==nil
          path=""
        end
      else
      path=list[0]
      if path==nil
        path=""
      end
      end
    end
    Dir.chdir(path)
    repos.rewind
    repos.close
  else
    puts "Sorry, you don't have any saved paths, please enter a path in"
    puts "Git repo:"
    dir=gets.chomp
    dir=File.expand_path(dir)
    while !Dir.exist?(dir)
    puts "Git repo:"
    dir=gets.chomp
    dir=File.expand_path(dir)
    end
    Dir.chdir(dir)
    puts "Save(Y/N)?"
    save=gets.chomp
    if save=="y" or save=="Y"
      if File.exist?(File.expand_path(file))
        repos=File.open(File.expand_path(file),"a")
        repos.puts Dir.pwd
        repos.rewind
        repos.close
      else
        repos=File.open(File.expand_path(file),"w")
        repos.puts Dir.pwd
        repos.rewind
        repos.close
      end
    end
  end
else
  puts "Git repo:"
  dir=gets.chomp
  dir=File.expand_path(dir)
  while !Dir.exist?(dir)
  puts "Git repo:"
  dir=gets.chomp
  dir=File.expand_path(dir)
  end
  Dir.chdir(dir)
  puts "Save(Y/N)?"
  save=gets.chomp
  if save=="y" or save=="Y"
    if File.exist?(File.expand_path(file))
      repos=File.open(File.expand_path(file),"a")
      repos.puts Dir.pwd
      repos.rewind
      repos.close
    else
      repos=File.open(File.expand_path(file),"w")
      repos.puts Dir.pwd
      repos.rewind
      repos.close
    end
  end
end 
command=""
while command[0] !="q" and command[0] !="Q"
  print "#{File.basename(Dir.pwd)}:"
  command=gets.chomp.split_esc
  case command[0]
  when "log"
    string=`git log`
  when "pull"
    string=`git pull`
  when "push"
    string=`git push`
  when "status"
    string=`git status`
  when "commit"
    string=`git commit -m #{command[1]}`
  when "branch"
    string=`git branch #{command[1]}`
  when "dbranch"
    string=`git branch -d #{command[1]}` 
  when "checkout"
    string=`git checkout #{command[1]}`
  when "merge"
    string=`git merge #{command[1]}`
  when "ls"
    string=`ls`
  when "cd"
    string=`cd #{command[1]}`
  when "pwd"
    string=`pwd`    
  when "add"
    string=`git add #{command[1]}`
  when "rm"
    string=`git rm #{command[1]}`  
  when "q","Q"
    string="Quiting"
  else
    string="Bad command"
  end
  unless string==""
    puts string
  end
end