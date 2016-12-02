require "socket"
require "io/wait"
require "base64"
Thread::abort_on_exception=true
server = TCPServer.new 2000
debug=true
$sfiles={}
$users={}
$redirects={}
$status=[]
$pass=[]
$umod_time=nil
$smod_time=nil
$rmod_time=nil

def read_redirects()
  if $rmod_time!=File.mtime("redirects.txt")
    lines=File.readlines("redirects.txt")
    i=0
    lines.each do |line|
      if line[0]!="#"
        line=line.chomp.split(",")
        $redirects[line[0]]=line[1]
        i=i+1
      end  
    end
    $rmod_time=File.mtime("redirects.txt")
  end
end
def read_users()
  if $umod_time!=File.mtime("users.txt")
    lines=File.readlines("users.txt")
    i=0
    lines.each do |line|
      if line[0]!="#"
        line=line.chomp.split(",")
        $users[line[0]]=i
        $status[i]=line[1]
        $pass[i]=line[2]
        i=i+1
      end  
    end
    $umod_time=File.mtime("users.txt")
  end
end

def read_sfiles()
  if $smod_time!=File.mtime("secure.txt")
    lines=File.readlines("secure.txt")
    lines.each do |line|
     line=line.chomp.split(",")
     $sfiles["./"+line[0]]=line[1]
    end
    $smod_time=File.mtime("secure.txt")
  end
end

def get_data(client)
  lines=[]
  line=client.gets
  puts "Got line: #{line.inspect}"
  while line !="\r\n"
    lines<<line
    line=client.gets
    puts "Got line: #{line.inspect}"
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
  unless debug
    if status.split(" ")[0]=="404"
      puts "Could not find file #{url}"
    end
  else 
    puts status
  end
  header=""
  headers.each do |key,value|
    header+="#{key}: #{value}\n"
  end
  client.puts "HTTP/1.1 #{status}\n#{header}\n#{body}"
  client.close
end

def procces_req(url,headers,client,debug,good,bad,nou,noa,notf)
  if url == "./echo.html"
    noa.call
    return
  end
  if $redirects.has_key? url
    send_response("301 Moved Permanently",{"Location"=>$redirects[url]},"",client,url,debug)
  end
  if File.exist?(url)
    if headers["Authorization"]
      auth=headers["Authorization"].split(" ")[1]
      auth=Base64.decode64(auth).split(":")
      user=auth[0]
      pass=auth[1]
      if $users.has_key? user
        if $pass[$users[user]]==pass
          good.call($status[$users[user]])
        else
          bad.call
        end
      else
        nou.call  
      end  
    else
      noa.call
      return
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
  when ".jpg",".jpeg"
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
  if File.extname(url) == ""
    return url+".html"
  else
    return url
  end
end
def secure(url)
  read_sfiles()
  if $sfiles.include? url
    return true
  else
    return false
  end
end

def uok(url,level)
  read_sfiles()
  if $sfiles.include? url
    if $sfiles[url]==level or ($sfiles[url]=="normal" and level=="admin")
      return true
    else
      return false
    end
  else
    return true
  end
end

def sfile(file,headers,type,client,url,debug)
  total=file.length
  range=headers["Range"]
  positions=range.split("=")[1].split("-")
  start=positions[0].to_i(10)
  m_end=positions[1] ? positions[1].to_i(10) : total - 1;
  chunksize=(m_end-start)+1
  chunk=file[start, m_end+1]
  if type=="mp4"
    r_headers={"Content-Range"=>"bytes #{start}-#{m_end}/#{total}","Accept-Ranges"=>"bytes","Content-Length"=>chunksize,"Content-Type"=>"video/mp4"}
  elsif type=="webm"
    r_headers={"Content-Range"=>"bytes #{start}-#{m_end}/#{total}","Accept-Ranges"=>"bytes","Content-Length"=>chunksize,"Content-Type"=>"video/webm"}
  elsif type=="mpeg"
    r_headers={"Content-Range"=>"bytes #{start}-#{m_end}/#{total}","Accept-Ranges"=>"bytes","Content-Length"=>chunksize,"Content-Type"=>"audio/mpeg"}
  elsif type=="ogg"
    r_headers={"Content-Range"=>"bytes #{start}-#{m_end}/#{total}","Accept-Ranges"=>"bytes","Content-Length"=>chunksize,"Content-Type"=>"audio/ogg"}
  end
  return send_response("206 Partial Content",r_headers,chunk,client,url,debug)
end
puts "Server running on localhost:2000"
loop do
    Thread.start(server.accept) do |client|
    begin
      puts "Got connection"
      read_users()
      read_redirects()
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
      procces_req(url,headers,client,debug,lambda { |level|
          #Good Auth
          if uok(url,level)
            if type(url)=="video/mp4"
              sfile(File.open(url, "rb") {|io| io.read},headers,"mp4",client,url,debug)
            elsif type(url)=="video/webm"
              sfile(File.open(url, "rb") {|io| io.read},headers,"webm",client,url,debug)
            elsif type(url)=="audio/mpeg"
              sfile(File.open(url, "rb") {|io| io.read},headers,"mpeg",client,url,debug)
            elsif type(url)=="audio/ogg"
              sfile(File.open(url, "rb") {|io| io.read},headers,"ogg",client,url,debug)
            elsif url=="./users.txt" && (method=="PUT" || method=="POST")
              if method == "POST"
                users=File.open("./users.txt","w")
                users.puts body
                users.close
                send_response("204 No Content",{},"",client,url,debug)
              end
            else
              send_response("200 OK",{"Content-Type"=>type(url)},File.read(url),client,url,debug)
            end
          else
            send_response("401 Unauthorized",{"WWW-Authenticate"=>"Basic realm=''","Content-Type"=>"text/html"},File.read("./empty.html"),client,url,debug)
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
            if url == "./echo.html"
              nheaders={}
              headers.each do |n,v|
                if n == "Content-Length"
                  nheaders["Original-Content-Length"]=v
                else
                  nheaders[n]=v
                end
              end
              send_response("200 OK",nheaders,body,client,url,debug)
            elsif type(url)=="video/mp4"
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
          end
      }, lambda {
        #Not Found
        send_response("404 Not Found",{"Content-Type"=>"text/html"},File.read("./empty.html"),client,url,debug) 
      })
    rescue Exception=>e
      puts e
      puts e.backtrace
    end
  end
end