while true
	puts"Op:w/nd/r/s"
	op=gets.chomp
	case op
	when "w"
		puts"Deck:"
		deck=gets.chomp
		cardnum=File.read(File.expand_path("./"+deck+"/cardnum.txt"))
		cardnum=Integer(cardnum)
		cardnum=cardnum+1
		file=File.open(File.expand_path("./"+deck+"/cardnum.txt"),"w")
		file.puts cardnum
		file.close
		while true
			input=gets.chomp
			if input.length>80
				break
		end
		card=File.open(File.expand_path("./"+deck+"/CARD"+String(cardnum)+".txt"),"w")
		card.puts input
		card.close
		break
	end
	when "nd"
		puts"Deck:"
		deck=gets.chomp
		Dir.mkdir(File.expand_path("./"+deck))
		Dir.chdir(File.expand_path("./"+deck))
		cardnum=File.open("cardnum.txt","w")
		cardnum.puts "0"
		cardnum.close
	when "r"
		puts "Deck:"
		deck=gets.chomp
		puts"Number:"
		num=gets.chomp
		puts File.read(File.expand_path("./"+deck+"/CARD"+num+".txt"))
	when "s"
		exit
	end
end
