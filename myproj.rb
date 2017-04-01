require 'webrick'
require 'uri'
Thread::abort_on_exception=true
debug=false
$server = WEBrick::HTTPServer.new :Port => 8000
time=Time.now()
monthnames=[nil,"January","February","March","April","May","June","July","August","September","October","November","December"]
posts={}
$b=binding
def add(url,&block)
  file,start=block.source_location
  f=File.open(file,"r")
  start.times do
    f.gets
  end
  code=""
  no_break=[]
  while true
    line=f.gets
    if line.include? "do" or line.include? "unless" or line.include? "if"
      no_break.push 0
    end
    if line.include? "end" and no_break==[]
      break
    end
    if line.include? "end" and no_break!=[]
      no_break.pop
    end
    code+=line
  end
  if $b
    proc=eval("Proc.new { |req,res| #{code}}",$b)
    $server.mount_proc(url,proc)
  else
    raise "Put this code after your variable definitons:$b=binding"
   end
end
add '/' do
  body=""
  $temp="<p>"
  Hash[posts.to_a.reverse].each do |time,message|
    if time.hour>12
      hour=time.hour-12
      ampm="PM"
    else
      hour=time.hour
      ampm="AM"
    end
    message[1]=message[1].split("+").join(" ")
    body=body.split("+").join(" ")
    if message[1]
      $temp+="On #{hour}:#{time.min} #{ampm} #{monthnames[time.mon]} #{time.mday}, #{time.year}, #{message[1]} posted:<br>"
      $temp+="#{URI.unescape(message[0])}<br>"  
    else
      $temp+="On #{hour}:#{time.min} #{ampm} #{monthnames[time.mon]} #{time.mday}, #{time.year}, someone posted:<br>"
      $temp+="#{URI.unescape(message[0])}<br>"  
    end
  end
  body+=$temp
  body+="</p>"
  body+='<p> Submit new post:<br>
        <form action="/formhandle" method="post">
        <textarea name="body" rows="10" cols="30"></textarea>
        <br>
        Name:<input type="text" name="name">
        <br>
        <input type="submit" value="Post">
        </form>
        </p>'
  res.body=body
  res["Content-Type"]="text/html"
end
add '/formhandle' do
  puts "body:#{req.body}"
  temp=req.body.split("&")
  formvals={}
  temp.each do |v|
    temp1=v.split("=")
    formvals[temp1[0]]=temp1[1]
  end
  time=Time.now()
  body=formvals["body"]
  if formvals["name"]
    name=formvals["name"]
  end
  if name
    posts[time]=[body,name]
  else
    posts[time]=[body]
  end
  res.status=303
  res["Location"]="/"
end
$server.start