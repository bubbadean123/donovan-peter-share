$dl={0=>0,1=>1,2=>2,3=>2}
$dcl={0=>nil,1=>nil,2=>nil,3=>nil}
$dcll={0=>0,1=>0,2=>0,3=>0}
$ndp=12
def connect(port)
	puts "Switching to port #{port}"
	puts "Command out: 0"
	connected=gets.chomp!.to_i
	if connected==0
		puts "Command out: 1"
		id=gets.chomp!.to_i
		dcl1=gets.chomp!.to_i
		if dcl1==0
			$dl[port]=id
			$dcl[port]=nil
		else
			$dl[$ndp]=id
			$dcl[$ndp]=[dcl1,port]
			$ndp+=1
	  end
		$dcll[port]=0
	end
end
def switchport(port,dcl1)
	if $dcll[port]==dcl1
		puts "Switching to port #{port}"
  else
		
	end
end
#connect(0)
#connect(0)
puts $dl.inspect
puts $dcl
puts $dcll
puts $ndp