$root="/Users/anneterpstra/Desktop/Peter\\'s\\ Folder/programming\\ stuff/runix"
def getdir(opath)
  path=opath.split("")
  if opath=="/"
    return $root
  elsif path[0]=="/"
    path.shift
    path=path.join("")
    newpath=$root+"/"+path
    return newpath
  elsif path[0]=="~"
    return getdir("/home/#{$user}")
  end
  return path.join("")
end
path="/bin"
command="tcp"
arguments="test"
puts `ruby #{getdir(path)+"/"+command} #{arguments}`