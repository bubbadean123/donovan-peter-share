require 'socket'
require 'io/wait'
require "base64"
Thread::abort_on_exception=true
server = TCPServer.new 2000
debug=false
index=<<eos
  <DOCTYPE html>
  <html>
    <head>
      <title>Test</title>
      <link rel="stylesheet" href="site.css"/>
    </head>
    <body>
      <h1 class="centertext">Test page</h1>
      <img src="/Home.jpg" class="centerimg">
      <br>
      <video controls class="centerimg">
        <source src="Intro.webm" type="video/webm">
        <source src="Intro.mp4" type="video/mp4">
        Your browser does not support the video tag.
      </video>
      <br>
      <audio controls class="centerimg">
        <source src="dun dun dun1.mp3" type="audio/mpeg">
        <source src="dun dun dun1.ogg" type="audio/ogg">
        Your browser does not support the audio tag.
      </audio> 
    </body>
  </html>
eos
css=File.open("site.css", "rb") {|io| io.read}
home=File.open("Home.jpg", "rb") {|io| io.read}
intro_mp=File.open("Intro.mp4", "rb") {|io| io.read}
intro_wm=File.open("Intro.webm", "rb") {|io| io.read}
dundundun_mp=File.open("dun dun dun1.mp3", "rb") {|io| io.read}
dundundun_og=File.open("dun dun dun1.ogg", "rb") {|io| io.read}
def svid(movie,headers,type,client,url,debug)
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
  end
  return send_response("206 Partial Content",r_headers,chunk,client,url,debug)
end
def saud(audio,headers,type,client,url,debug)
  total=audio.length
  range=headers["Range"]
  positions=range.split("=")[1].split("-")
  start=positions[0].to_i(10)
  a_end=positions[1] ? positions[1].to_i(10) : total - 1;
  chunksize=(a_end-start)+1
  chunk=audio[start, a_end+1]
  if type=="mpeg"
    r_headers={"Content-Range"=>"bytes #{start}-#{a_end}/#{total}","Accept-Ranges"=>"bytes","Content-Length"=>chunksize,"Content-Type"=>"audio/mpeg"}
  elsif type=="ogg"
    r_headers={"Content-Range"=>"bytes #{start}-#{a_end}/#{total}","Accept-Ranges"=>"bytes","Content-Length"=>chunksize,"Content-Type"=>"audio/ogg"}
  end
  return send_response("206 Partial Content",r_headers,chunk,client,url,debug)
end
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
  client.flush
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
      body=temp["body"]
      temp=url.gsub("%20"," ")
      if debug
        puts "#{method} #{temp}"
      end
      if url=="/"
        send_response("200 OK",{"Content-Type"=>"text/html"},index,client,url,debug)
      elsif url=="/Home.jpg"
        send_response("200 OK",{"Content-Type"=>"image/jpg"},home,client,url,debug)
      elsif url=="/Intro.mp4"
        svid(intro_mp,headers,"mp4",client,url,debug)
      elsif url=="/Intro.webm"    
        svid(intro_wm,headers,"webm",client,url,debug)
      elsif url=="/dun%20dun%20dun1.mp3"
        saud(dundundun_mp,headers,"mpeg",client,url,debug)
      elsif url=="/dun%20dun%20dun1.ogg"
        saud(dundundun_og,headers,"ogg",client,url,debug)
      elsif url=="/site.css"
        send_response("200 OK",{"Content-Type"=>"text/css"},css,client,url,debug)
      else
        send_response("404 Not Found",{"Content-Type"=>"text/html"},"<DOCTYPE html><html><head></head><body></body></html>",client,url,debug)
      end
      client.close
    rescue Exception=>e
    end
  end
end