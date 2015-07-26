require "fileutils"
if File.exists?("./os/invisible")
else
File.open('invisible.txt', "w")
end
exec './kernelaunch.sh'
