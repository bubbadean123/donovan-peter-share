print "Disk image name:"
name=gets.chomp
cside=0
ctrack=0
csect=0
cbyte=0
file=File.open(name,"w")
stop=false
until stop
	puts "in loop"
	file.puts "S#{cside}T#{ctrack}S#{csect}B#{cbyte}\n0"
	cbyte+=1
	if cbyte==256
		cbyte=0
		csect+=1
		if csect==20
			csect=0
			ctrack+=1
			if ctrack==40
				ctrack=0
				cside=1
				if cside==2
					stop=true
				end
			end
		end
	end
end