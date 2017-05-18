require "yaml"
class Repository
  def initialize(path)
    @dir=path
    if !File.exists? @dir
      Dir.mkdir(@dir)
    end
    Dir.chdir(@dir)
    if File.exists? "vcs.db"
      hash=YAML.load(File.read("vcs.db"))
      if hash
        @commits=hash["commits"]
        @cid=hash["cid"]
        @last=hash["last"]
        return
      end
    end
    f=File.open("vcs.db","w")
    f.close
    @commits={}
    @cid=0
    @last=nil
  end
  def commit(message)  
    entries=Dir.entries(".")
    entries=entries.delete(".").delete("..")
    hash={"message"=>message,"flist"=>entries,"parent"=>@last,"changed"=>chfiles}
    @commits[@cid]=hash
    @last=@cid
    @cid+=1
    save()
  end
  def log(id=nil)
    if id==nil
      id=@last    
    end
    commit=@commits[id]
    if commit["parent"]
      parent=@commits[commit["parent"]]
    end
    cfiles=commit["changed"].keys
    clist=commit["flist"]
    message=commit["message"]
    puts message+":"
    if parent
      plist=parent["flist"]
      plist.each do |name|
        if cfiles.include? name
          puts "M #{name}"
        end
        if !clist.include? name
          puts "- #{name}"
        end
      end
      clist.each do |name|
        if !plist.include? name
          puts "+ #{name}"
        end
      end
    else
      cfiles.each do |name|
        puts "+ #{name}"
      end
      return
    end
    log(id-1)
  end
  private
  def chfiles()
    commit=@commits[@last]
    if !commit
      return wdirtoh
    end
    flist=commit["flist"]
    cfiles=commit["changed"]
    chfiles={}
    wdirtoh.each do |name,contents|
      ccont=cfiles[name]
      if !flist.include? name
        chfiles[name]=contents
      end
      if ccont
        if ccont != contents
          chfiles[name]=contents
        end
      end
    end
    return cfiles
  end
  def wdirtoh()
    hash={}
    vignore=File.read("vignore").split("\n")
    Dir.foreach(".") do |name|
      if name == '.' or name == '..' or name == "vcs.db" or vignore.include? name
        puts "Ignoring #{name}"
        next
      end
      puts "Adding #{name}"
      hash[name]=File.read(name)
    end
    puts "Final hash:#{hash}"
    return hash
  end
  def save()
    yaml=YAML.dump({"commits"=>@commits,"cid"=>@cid,"last"=>@last})
    file=File.open("vcs.db","w")
    file.puts(yaml)
    file.close()
  end
end
puts "VCS v1.0 Console"
open=false
repo=nil
while true do
  print ">"
  cmd=gets.chomp!.split(" ")
  op=cmd.shift
  case op
  when "help"
    puts "Command reference:"
    puts "help-Prints this command reference"
    puts "open <name>-Opens a repository"
    puts "commit <message>-Commit all changes"
    puts "log-Show the commit log"
  when "open"
    open=true
    repo=Repository.new(cmd[0])
  when "commit"
    if open
      repo.commit(cmd.join(" "))
    else
      puts "You must open a repository to use this command!"
    end
  when "log"
    if open
      repo.log
    else
      puts "You must open a repository to use this command!"
    end
  end
end
