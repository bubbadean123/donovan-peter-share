require "sinatra"
require "json"
require "uri"
require "cgi"
def processBody(body)
  array=body.split("\r\n")
  data=[]
  i=0
  array.each do |v|
    temp=[]
    while true
      if i==0
        temp[0]=v.split("=")[0]
        i=i+1
      elsif i==1
        temp[1]=v.split("=")[1]
        i=0
        data.push(temp)
        break
      end
    end
  end
  return data
end
def find(key,array)
  array.each do |v|
    if v[0]==key
      return v[1]
    end
  end
end
items=[]
used=[]
get "/" do
  status 200
  headers({"Content-Type"=>"text/html"})
  body '<!DOCTYPE html><html><head><title>Form test</title></head><body><h1>Post</h1><form method="post" action="/items" enctype="text/plain">Data: <input type="text" name="data"><br><input type="submit" value="Submit"></form><h1>Get</h1><form method="get" action="/items">Index: <input type="text" name="index"><br><input type="submit" value="Submit"></form></body></html>'
end
post "/items" do
  request.body.rewind
  body=request.body.read
  values=processBody(body)
  data=find("data",values)
  i=0
  while true
    if used.index(i)==nil
      break
    end
    i=i+1
  end
  used.push(i)
  items[i]=data
  status 201
  headers({"Content-Type"=>"application/json"})
  body i.to_json
end
get "/items" do
  query=CGI.parse(URI.parse(request.fullpath).query)
  index=query["index"][0].to_i
  status 200
  headers({"Content-Type"=>"text/plain"})
  body items[index]
end
put "/items" do
  request.body.rewind
  data = request.body.read
  items=data.split(',')
  len=items.length;
  i=0
  used=[]
  while i<len
    used.push(i)
    i=i+1
  end
  status 200
  headers({"Content-Type"=>"application/json"})
end
delete "/items" do
  items=[]
  used=[]
  status 201
end
delete "/items/:id" do
  index=params[:id].to_i
  if (used.index(index)!=nil) 
    used.delete(used.index(index))
    items.delete(index)
  end
  status 201
end
put "/items/:id" do
  index=params[:id].to_i
  items[index]=data
  if (used.index(index)==nil)
    used.push(index)
  end
  status 201
end
  