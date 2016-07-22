require "socket"
require "io/wait"
require "base64"
require "securerandom"
Thread::abort_on_exception=true
users={"admin"=>0,"user"=>1}
status=["admin","normal"]
pass=["1638","pass"]
users.each do |key,value|
  if status[value] == "admin"
    puts "User #{key} is an admin with password #{pass[value]}"
  elsif status[value] == "normal"
    puts "User #{key} is a normal user with password #{pass[value]}"
  end
end
server = TCPServer.new 2000
debug=true
secure=<<eos
  <!DOCTYPE html>
  <html>
    <head>
      <title>Secure</title>
    </head>
    <body>
      <h1>Secure page</h1>
  </html>
eos
bad=<<eos
  <!DOCTYPE html>
  <html>
    <head>
      <title></title>
    </head>
    <body>
    <h1> Bad User/Password combo</h1>
    </body>
  </html>
eos
noauth=<<eos
  <!DOCTYPE html>
  <html>
    <head>
      <title></title>
    </head>
    <body>
    <h1>Authorization Required</h1>
    </body>
  </html>
eos
nouser=<<eos
  <!DOCTYPE html>
  <html>
    <head>
      <title></title>
    </head>
    <body>
    <h1>No User</h1>
    </body>
  </html>
eos
def get_data(client)
  lines=[]
  line=client.gets
  while line !="\r\n"
    lines<<line
    line=client.gets
  end
  i=0
  lines.each do |value|
    lines[i]=value.chomp
    i=i+1
  end
  temp=lines.shift
  method=temp.split(" ")[0]
  url=temp.split(" ")[1]
  headers={}
  lines.each do |value|
    temp=value.split(": ")
    headers[temp[0]]=temp[1]
  end
  body=[]
  while client.ready?
    body<<client.gets.chomp
  end
  return {"lines"=>lines,"headers"=>headers,"url"=>url,"method"=>method,"body"=>body}
end
def send_response(status,headers,body,client,url,debug)
  if debug
    puts status
  else
    if status.split(" ")[0]=="404"
      puts "Could not find file #{url}"
    end
  end
  header=""
  headers.each do |key,value|
    header+="#{key}: #{value}\n"
  end
  client.puts "HTTP/1.1 #{status}\n#{header}\n#{body}\000"
  client.close
end
def get_auth(headers)
  if headers["Authorization"]
    auth=headers["Authorization"].split(" ")[1]
    auth=Base64.decode64(auth).split(":")
    user=auth[0]
    pass=auth[1]
    puts "User #{user} logging in with password #{pass}"
    return [user,pass]  
  else
    return "No auth"
  end
end
puts "Server running on localhost:2000"
loop do
  Thread.start(server.accept) do |client|
    temp=get_data(client)
    lines=temp["lines"]
    headers=temp["headers"]
    method=temp["method"]
    url=temp["url"]
    body=temp["body"]
    temp=url.gsub("%20"," ")
    if debug
      puts "#{method} #{temp}"
    end
    auth=get_auth(headers)
    unless auth == "No auth"
      user=auth[0]
      password=auth[1]
      if users.has_key? user
        if pass[users[user]]==password
          puts "Good auth"
          send_response("200 OK",{"Content-Type"=>"text/html"},secure,client,url,debug)
        else
          puts "Bad auth"
          send_response("401 Unauthorized",{"WWW-Authenticate"=>"Basic realm=''","Content-Type"=>"text/html"},bad,client,url,debug)
        end
      else
        puts "No user"
        send_response("401 Unauthorized",{"WWW-Authenticate"=>"Basic realm=''","Content-Type"=>"text/html"},nouser,client,url,debug)
      end
    else
      puts "No auth"
      send_response("401 Unauthorized",{"WWW-Authenticate"=>"Basic realm=''","Content-Type"=>"text/html"},noauth,client,url,debug)
    end
  end
end