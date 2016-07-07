var items=[];
var used=[];
const parser = require('url');
const http = require("http");
var arraySearch = function(arr,val) {
    for (var i=0; i<arr.length; i++)
        if (arr[i] === val)                    
            return i;
    return -1;
  }
var get_body = function(request,callback) {
  var data = '';
  request.on('data', function(chunk) {
      data += chunk;                                                                 
  });
  request.on('end', function() {
      return callback(data);
  });
}
http.createServer(function(request,response){
  var method = request.method;
  var url = request.url;
  console.log(method+':'+url)
  if (url=='/items') {
    if (method=='POST') {
      get_body(request,function(data){
        i=0
        while (true) {
          if (used.indexOf(i)==-1) {
            break;
          }
          i=i+1
        }
        used.push(i);
        console.log(used);
        items[i]=data;
        response.writeHead(201, {
          'Content-Type': 'application/json',
        });
        response.end(JSON.stringify(i));
      });
    } else if (method=='GET') {
      response.writeHead(200, {
        'Content-Type': 'application/json',
      });
      response.end(JSON.stringify(items));
    } else if (method=='HEAD') {
      response.writeHead(200, {
        'Content-Type': 'application/json',
      });
      response.end();
    } else if (method=='PUT') {
      get_body(request,function(data) {
        items=data.split(',');
        len=items.length();
        i=0;
        used=[];
        while (i<len) {
          used.push(i);
          i=i+1;
        }
      });
    } else if (method=='DELETE') {
      items=[];
      used=[];
      response.writeHead(201);
      response.end();
    } else if (method=='OPTIONS') {
      response.writeHead(200, {
        'Content-Type': 'application/json',
      });
      response.end(JSON.strigify('GET\nPUT\nPOST\nDELETE\nOPTIONS\nHEAD'));
    } else {
      response.writeHead(405);
      response.end();
    }
  } else if (url.match(/^\/items\/[0-9]+$/) != null) {
    if (method=='GET') {
      urlarray=url.split('/');
      index=parseInt(urlarray[2]);
      if (items[index]!=undefined) {
        response.writeHead(200, {
          'Content-Type': 'application/json',
        });
      response.end(JSON.stringify(items[index]));
      } else {
        response.writeHead(404);
        response.end();
      }
    } else if (method=='HEAD') {
      urlarray=url.split('/');
      index=parseInt(urlarray[2]);
      if (items[index]!=undefined) {
        response.writeHead(200, {
          'Content-Type': 'application/json',
        });
      response.end();
      } else {
        response.writeHead(404);
        response.end();
      }
    } else if (method=='DELETE') {
      urlarray=url.split('/');
      index=parseInt(urlarray[2]);
      if (arraySearch(used,index)!=-1) {
        delete used[arraySearch(used,index)];
        delete items[index];
      }
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
    } else if (method=='OPTIONS') {
      response.writeHead(200, {
        'Content-Type': 'text/plain',
      });
      response.end('GET\nPUT\nDELETE\nOPTIONS\nHEAD');
    } else {
      response.writeHead(405);
      response.end();
    }
  } else {
    response.writeHead(404);
    response.end();
  }
}).listen(8080);