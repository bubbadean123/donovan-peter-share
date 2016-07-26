require "socket"
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
while command !="q" or command !="Q"
  puts "Command:"
  command=gets.chomp
  case command
  when "log"
    puts `git log`
  when "q","Q"
    puts "Quiting"
  else
    puts "Bad command"
  end
end