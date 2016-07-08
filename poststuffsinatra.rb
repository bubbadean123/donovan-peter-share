require "sinatra"
require "json"
items=[]
used=[]
post "/items" do
  request.body.rewind
  data = request.body.read
  i=0
  while true
    if (used.index(i)==nil)
      break;
    end
    i=i+1
  end
  used.push(i);
  items[i]=data;
  status 201
  headers({"Content-Type"=>"application/json"})
  body i.to_json
end
get "/items" do
  status 200
  headers({"Content-Type"=>"application/json"})
  body items.to_json
end
head "/items" do
  status 200
  headers({"Content-Type"=>"application/json"})
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
options "/items" do
  status 200
  headers({"Content-Type"=>"text/plain"})
  body "GET\nPUT\nPOST\nDELETE\nOPTIONS\nHEAD"
end
get "/items/:id" do
  status 200
  headers({"Content-Type"=>"application/json"})
  body items[params[:id].to_i].to_json
end
head "/items/:id" do
  status 200
  headers({"Content-Type"=>"application/json"})
end
delete "/items/:id" do
  index=params[:id].to_i
  if (used.index(index)==nil) 
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
  