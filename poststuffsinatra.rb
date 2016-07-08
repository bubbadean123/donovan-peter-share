require "sinatra"
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
  headers {"Content-Type"=>"application/json"}
  body i.to_json
end
get "/items" do
  status 200
  headers {"Content-Type"=>"application/json"}
  body items.to_json
end
head "/items" do
  status 200
  headers {"Content-Type"=>"application/json"}
end
put "/items" do
  request.body.rewind
  data = request.body.read
  items=data.split(',');
  len=items.length;
  i=0;
  used=[];
  while i<len
    used.push(i);
    i=i+1;
  end
  status 200
  headers {"Content-Type"=>"application/json"}
end