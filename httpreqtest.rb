require "./HTTPClient"
puts "Host:"
host=gets.chomp
puts "Port:(Enter for 80)"
port=gets.chomp
if port==""
  port="80"
end
http = HTTPClient.new(host, port)
while true
  puts "Addr:"
  addr=gets.chomp
  if addr=="q" or addr=="Q"
    break
  elsif addr=="a" or addr=="A"
    puts "Host:"
    host=gets.chomp
    puts "Port:(Enter for 80)"
    port=gets.chomp
    if port==""
      port="80"
    end
    http = HTTPClient.new(host, port)
  end
  http.get(addr)
  puts http.res.to_hash
  puts http.res.body
end
