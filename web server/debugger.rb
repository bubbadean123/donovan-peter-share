http=Net::HTTP.new("localhost", "8080")
while true
  print "Path:"
  path=gets.chomp
  print "Body?(Y/N):"
  body=gets.chomp.downcase
  response=http.get(path)
  puts "Code:#{response.code}"
  puts "Type:#{response['content-type']}"
  if body=="y"
    puts "Body:\n#{response.body}"
  end
end