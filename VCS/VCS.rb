require "digest/sha1"
require "fileutils"
class BranchError < StandardError
end
class Repo
  def initialize(folder)  
    if !File.exists? folder
      Dir.mkdir(folder)
      Dir.mkdir("#{folder}/objects")
      Dir.mkdir("#{folder}/refs")
      Dir.mkdir("#{folder}/refs/heads")
      Dir.mkdir("#{folder}/refs/tags")
      f=File.open("#{folder}/HEAD","w")
      f.puts "heads/master"
      f.close
    end
    @dir=folder
  end
  def new_obj(type,contents)
    hash=sha1(contents)
    if !File.exists? "#{@dir}/objects/#{hash}"
      f=File.open("#{@dir}/objects/#{hash}","w")
      f.puts "#{type}\n"+contents
      f.close
    end
    return hash
  end
  def new_blob(contents)
    return new_obj("blob",contents)
  end
  def new_tree(tree)
    string=""
    tree.each do |name,hash|
      string+="#{hash} #{name}\n"
    end
    return new_obj("tree",string)
  end
  def new_commit(tree,message,parent=nil)
    if parent
      hash=new_obj("commit","tree:#{tree}\nparent:#{parent}\nmessage:#{message}")
    else
      hash=new_obj("commit","tree:#{tree}\nmessage:#{message}")
    end
    return hash
  end
  def commit_parent(hash)
    commit=rd_obj(hash).split("\n")
    chash={}
    commit.each do |line|
      sline=line.split(":")
      chash[sline[0]]=sline[1]
    end
    commit=chash
    return commit["parent"]
  end
  def commit_message(hash)
    commit=rd_obj(hash).split("\n")
    chash={}
    commit.each do |line|
      sline=line.split(":")
      chash[sline[0]]=sline[1]
    end
    commit=chash
    return commit["message"]
  end
  def obj_type(hash)
    f=File.open("#{@dir}/objects/#{hash}","r")
    type=f.gets.chomp!
    f.close
    return type
  end
  def ls_objs()
    objs={}
    listing=Dir.entries("#{@dir}/objects")
    listing.each do |hash|
      unless hash == "." or hash == ".." or hash == ".DS_Store"
        objs[hash]=obj_type(hash)
      end
    end
    return objs
  end
  def rd_obj(hash)
    f=File.open("#{@dir}/objects/#{hash}","r")
    contents=f.readlines
    contents=contents[1..contents.length-1].join("")
    f.close
    return contents
  end
  def update_ref(name,commit)
    f=File.open("#{@dir}/refs/#{name}","w")
    f.puts commit
    f.close
  end
  def read_ref(name)
    f=File.open("#{@dir}/refs/#{name}","r")
    commit=f.gets.chomp!
    f.close 
    return commit 
  end
  def head()
    f=File.open("#{@dir}/HEAD","r")
    mhead=f.gets.chomp!
    return mhead
  end
  def head=(nhead)
    f=File.open("#{@dir}/HEAD","w")
    f.puts nhead
    f.close
  end
  def commit(wdir,message,parent=nil)
    wdir.each do |name,contents|
      blob=new_blob(contents)
      wdir[name]=blob
    end
    tree=new_tree(wdir)
    commit=new_commit(tree,message,parent)
    update_ref("#{head}",commit)
    return commit
  end
  def branch(name)
    update_ref("heads/#{name}",read_ref(head))
  end
  def branches()
    listing=Dir.entries("#{@dir}/refs/heads")
    listing.delete(".")
    listing.delete("..")
    listing.delete(".DS_Store")
    return listing
  end
  def checkout(name)
    if File.exists? "#{@dir}/refs/heads/#{name}"
      head=("heads/#{name}")
    else
      raise BranchError,"Branch #{name} does not exist"
    end
  end
  private
  def sha1(text)
    return Digest::SHA1.hexdigest(text)
  end
end
def log(repo)
  commit=repo.read_ref(repo.head)
  branches=repo.branches
  while true do
    print "("
    i=0
    hprinted=false
    branches.each do |branch|
      if repo.read_ref("heads/#{branch}")==commit
        if hprinted
          print ","
        else
          hprinted=true
        end
        if "heads/#{branch}"==repo.head
          print "*"
        end
        print branch
      end
      i+=1
    end
    print ") "
    puts repo.commit_message(commit)
    commit=repo.commit_parent(commit)
    if !commit
      break
    end
  end
end
FileUtils.rm_r "repo"
repo=Repo.new("repo")
icommit=repo.commit({"hello.txt"=>"hello","hi.txt"=>"hi"},"Initial commit")
log(repo)
repo.branch("release")
log(repo)
repo.checkout("release")
log(repo)
rcommit=repo.commit({"hello.txt"=>"hello","hi.txt"=>"hi","version.txt"=>"1.0"},"Release commit",icommit)
log(repo)