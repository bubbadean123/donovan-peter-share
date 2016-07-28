require "socket"
require "io/wait"
require "base64"
puts Dir.pwd
Thread::abort_on_exception=true
$users={"admin"=>0,"user"=>1}
$status=["admin","normal"]
$pass=["1638","pass"]
$users.each do |key,value|
  if $status[value] == "admin"
    puts "User #{key} is an admin with password #{$pass[value]}"
  elsif $status[value] == "normal"
    puts "User #{key} is a normal user with password #{$pass[value]}"
  end
end
server = TCPServer.new 2000
debug=true
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
def procces_req(url,headers,good,bad,nou,noa,notf)
  ext=File.extname(url)
  if ext[1]!="s"
    ext[0]=""
    ext=".s"+ext
  end
  urls=File.dirname(url)+"/"+File.basename(url,File.extname(url))+ext
  puts urls
  puts File.exist?(urls) 
  if File.exist?(url) or File.exist?(urls) 
    if headers["Authorization"]
      auth=headers["Authorization"].split(" ")[1]
      auth=Base64.decode64(auth).split(":")
      user=auth[0]
      pass=auth[1]
      auth=[user,pass]  
    else
      auth="No auth"
    end
    unless auth == "No auth"
      if $users.has_key? user
        if $pass[$users[user]]==pass
          good.call
        else
          bad.call
        end
      else
        nou.call  
      end
    else
      noa.call
    end
  else
    notf.call
  end
end
def type(url)
  case File.extname(url)
  when ".html"
    return "text/html"
  when ".txt"
    return "text/plain"
  when ".css"
    return "text/css"
  when ".js"
    return "application/javascript"
  when ".jpg","jpeg"
    return "image/jpg"
  when ".png"
    return "image/png"
  when ".mp3"
    return "audio/mpeg"
  when ".ogg"
    return "audio/ogg"
  when ".mp4"
    return "video/mp4"
  when ".webm"
    return "video/webm"
  else
    return "text/html"
  end
end
def fix(url)
  case File.extname(url)
  when ".html"
    return url
  when ".shtml"
    return url
  when ".txt"
    return url
  when ".stxt"
    return url
  when ".css"
    return url
  when ".scss"
    return url
  when ".js"
    return url
  when ".sjs"
    return url
  when ".jpg",".jpeg"
    return url
  when ".sjpg",".sjpeg"
    return url
  when ".png"
    return url
  when ".scss"
    return url
  when ".mp3"
    return url
  when ".smp3"
    return url
  when ".ogg"
    return url
  when ".sogg"
    return url
  when ".mp4"
    return url
  when ".smp4"
    return url
  when ".webm"
    return url
  when ".swebm"
    return url
  else
    return url+".html"
  end
end
def secure(url)
  ext=File.extname(url)
  if ext[1]=="s"
    ext[1]=""
  end
  urln="./"+File.dirname(url)+"/"+File.basename(url,File.extname(url))+ext
  ext=File.extname(url)
  if ext[1]!="s"
    ext[0]=""
    ext=".s"+ext
  end
  urls="./"+File.dirname(url)+"/"+File.basename(url,File.extname(url))+ext
  if File.exist?(urls)
    return true
  elsif File.exist?(urln)
    return false
  else
    return false
  end
end
puts File.exist?("./Videos/Intro.smp4")
puts File.exist?("./Videos/Intro.mp4")
puts secure("./Videos/Intro.smp4")
def sfile(file,headers,type,client,url,debug)
  total=movie.length
  range=headers["Range"]
  positions=range.split("=")[1].split("-")
  start=positions[0].to_i(10)
  m_end=positions[1] ? positions[1].to_i(10) : total - 1;
  chunksize=(m_end-start)+1
  chunk=movie[start, m_end+1]
  if type=="mp4"
    r_headers={"Content-Range"=>"bytes #{start}-#{m_end}/#{total}","Accept-Ranges"=>"bytes","Content-Length"=>chunksize,"Content-Type"=>"video/mp4"}
  elsif type=="webm"
    r_headers={"Content-Range"=>"bytes #{start}-#{m_end}/#{total}","Accept-Ranges"=>"bytes","Content-Length"=>chunksize,"Content-Type"=>"video/webm"}
  elsif type=="mpeg"
    r_headers={"Content-Range"=>"bytes #{start}-#{a_end}/#{total}","Accept-Ranges"=>"bytes","Content-Length"=>chunksize,"Content-Type"=>"audio/mpeg"}
  elsif type=="ogg"
    r_headers={"Content-Range"=>"bytes #{start}-#{a_end}/#{total}","Accept-Ranges"=>"bytes","Content-Length"=>chunksize,"Content-Type"=>"audio/ogg"}
  end
  return send_response("206 Partial Content",r_headers,chunk,client,url,debug)
end
puts "Server running on localhost:2000"
loop do
  Thread.start(server.accept) do |client|
    begin
      temp=get_data(client)
      lines=temp["lines"]
      headers=temp["headers"]
      method=temp["method"]
      url=temp["url"]
      url="."+url
      if url=="./"
        url="./index.html"
      end
      url=fix(url)
      body=temp["body"]
      url=url.gsub("%20"," ")
      if debug
        puts "#{method} #{url}"
      end
      procces_req(url,headers,lambda {
          ext=File.extname(url)
          if ext[1]!="s"
            ext[0]=""
            ext=".s"+ext
          end
          urls=File.dirname(url)+"/"+File.basename(url,File.extname(url))+ext
          if File.exist?(url)
            if type(url)=="video/mp4"
              sfile(File.open(url, "rb") {|io| io.read},headers,"mp4",client,url,debug)
            elsif type(url)=="video/webm"
              sfile(File.open(url, "rb") {|io| io.read},headers,"webm",client,url,debug)
            elsif type(url)=="audio/mpeg"
              sfile(File.open(url, "rb") {|io| io.read},headers,"mpeg",client,url,debug)
            elsif type(url)=="audio/ogg"
              sfile(File.open(url, "rb") {|io| io.read},headers,"ogg",client,url,debug)
            else
              send_response("200 OK",{"Content-Type"=>type(url)},File.read(url),client,url,debug)
            end
          else
            if type(urls)=="video/mp4"
              sfile(File.open(url, "rb") {|io| io.read},headers,"mp4",client,url,debug)
            elsif type(urls)=="video/webm"
              sfile(File.open(url, "rb") {|io| io.read},headers,"webm",client,url,debug)
            elsif type(urls)=="audio/mpeg"
              sfile(File.open(url, "rb") {|io| io.read},headers,"mpeg",client,url,debug)
            elsif type(urls)=="audio/ogg"
              sfile(File.open(url, "rb") {|io| io.read},headers,"ogg",client,url,debug)
            else
              send_response("200 OK",{"Content-Type"=>type(urls)},File.read(urls),client,url,debug)
            end  
          end
      },lambda {
          #Bad Auth
          send_response("401 Unauthorized",{"WWW-Authenticate"=>"Basic realm=''","Content-Type"=>"text/html"},File.read("./empty.html"),client,url,debug)    
      },lambda {
          #No User
          send_response("401 Unauthorized",{"WWW-Authenticate"=>"Basic realm=''","Content-Type"=>"text/html"},File.read("./empty.html"),client,url,debug)  
      },lambda {
          #No Auth
          if secure(url)
            send_response("401 Unauthorized",{"WWW-Authenticate"=>"Basic realm=''","Content-Type"=>"text/html"},File.read("./empty.html"),client,url,debug)
          else
            if type(url)=="video/mp4"
              svid(File.open(url, "rb") {|io| io.read},headers,"mp4",client,url,debug)
            elsif type(url)=="video/webm"
              svid(File.open(url, "rb") {|io| io.read},headers,"webm",client,url,debug)
            elsif type(url)=="audio/mpeg"
              saud(File.open(url, "rb") {|io| io.read},headers,"mpeg",client,url,debug)
            elsif type(url)=="audio/ogg"
              saud(File.open(url, "rb") {|io| io.read},headers,"ogg",client,url,debug)
            else
              send_response("200 OK",{"Content-Type"=>type(url)},File.read(url),client,url,debug)
            end
          end
      }, lambda {
        #Not Found
        send_response("404 Not Found",{"Content-Type"=>"text/html"},File.read("./empty.html"),client,url,debug) 
      })
    rescue Exception=>e
    end
  end
end