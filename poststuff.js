var items=[];
var used=[];
const parser = require('url');
const http = require("http");
var fs = require('fs');
var readline = require('readline');
var arraySearch = function(arr,val) {
    for (var i=0; i<arr.length; i++)
        if (arr[i] === val)                    
            return i;
    return false;
  }
var load_array = function(filename) {
  i=0
  array=[]
  readline.createInterface({
      input: fs.createReadStream(filename),
      terminal: false
  }).on('line', function(line) {
    array[i]=line;
    i=i+1
  });
  return array
}
var get_body = function(request,callback) {
  var data = '';
  request.on('data', function(chunk) {
      data += chunk;                                                                 
  });
  request.on('end', function() {
      console.log(data);
      return callback(data);
  });
}
http.createServer(function(request,response){
  var method = request.method;
  console.log(method)
  var url = request.url;
  if (url=='/items') {
    if (method=='POST') {
      get_body(request,function(data){
        i=0
        while (true) {
          if (used.indexOf(i)==-1) {
            break;
          }
        }
        used.push(i);
        items[i]=data;
        response.writeHead(201, {
          'Content-Type': 'application/json',
        });
        response.end(JSON.stringify(i));
      });
    } else if (method=='GET') {
      response.writeHead(201, {
        'Content-Type': 'application/json',
      });
      response.end(JSON.stringify(used));
    } else if (method=='PUT') {
      get_body(request,function(data) {
        items=data.split(',');
        len=items.length
        i=0
        used=[]
        while (i<len) {
          used.push(i);
          i=i+1;
        }
      });
    } else {
      response.writeHead(405);
      response.end();
    }
  } else if (url.match(/^\/items\/[0-9]+$/) != null) {
    if (method=='GET') {
      console.log('Returning value')
      urlarray=url.split('/');
      index=parseInt(urlarray[2]);
      response.writeHead(200, {
        'Content-Type': 'application/json',
      });
      response.end(JSON.stringify(items[index]));
    } else if (method=='DELETE') {
      get_body(request,function(data){
        if (arraySearch(used,data)!=false) {
          delete used[arraySearch(used,data)];
          delete items[data];
        }
      });
      response.writeHead(201);
      response.end();
    } else if (method=='PUT') {
      get_body(request,function(data){
      urlarray=url.split('/');
      index=parseInt(urlarray[2]);
      items[index]=data
      if (arraySearch(used,index)==false) {
        used.push(index);
      } 
      });
      response.writeHead(201);
      response.end();
    } else {
      response.writeHead(405);
      response.end();
    }
  } else {
    response.writeHead(404);
    response.end();
  }
}).listen(8080);