def sum(list)
	if list.length==1
		puts "End found, returning #{list[0]}"
		return list[0]
	else
		first=list.shift
		puts "Calling sum with #{list}"
		rsum=sum(list)
		puts "Sum of remaining items is #{rsum}"
		puts "Full sum is #{first+rsum}"
		return first+rsum
	end
end
puts sum([0,1,2,3,4,5,6,7,8,9,10])