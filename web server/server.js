const debug=true
const http = require('http');
const fs = require('fs');
const index = fs.readFileSync('index.html');
const blog = fs.readFileSync('Blog.html');
const books = fs.readFileSync('Books.html');
const css = fs.readFileSync('site.css');
const pimg = fs.readFileSync('Pictures.jpg');
const vimg = fs.readFileSync('Videos.jpg');
const blimg = fs.readFileSync('Blog.jpg');
const boimg = fs.readFileSync('Books.jpg');
const himg = fs.readFileSync('Home.jpg');
http.createServer(function (request, response) {
  var method = request.method;
  var url = request.url;
  var headers = request.headers;
  var accept = headers['accept'];
  if (debug) {
    console.log(method);
    console.log(url);
    console.log(accept);
  }

  if (url=='/' || url=='/index.html') {
    response.writeHead(200, {
      'Content-Type': 'text/html',
    });
    response.end(index);
    console.log("200 OK: "+url);
  } else if (url=='/Blog.html' ) {
    response.writeHead(200, {
      'Content-Type': 'text/html',
    });
    response.end(blog);
    console.log("200 OK: "+url);
   } else if (url=='/Books.html' ) {
     response.writeHead(200, {
       'Content-Type': 'text/html',
     });
     response.end(books);
    console.log("200 OK: "+url);
  } else if (url=='/css/site.css') {
    response.writeHead(200, {
      'Content-Type': 'text/css',
    });
    response.end(css);
    console.log("200 OK: "+url);
  } else if (url=='/pics/Pictures.jpg') {
    response.writeHead(200, {
      'Content-Type': 'image/jpg',
    });
    response.end(pimg);
    console.log("200 OK: "+url);
  } else if (url=='/pics/Videos.jpg') {
      response.writeHead(200, {
        'Content-Type': 'image/jpg',
      });
      response.end(vimg);
      console.log("200 OK: "+url);
  } else if (url=='/pics/Blog.jpg') {
      response.writeHead(200, {
        'Content-Type': 'image/jpg',
      });
      response.end(blimg);
      console.log("200 OK: "+url); 
  } else if (url=='/pics/Books.jpg') {
      response.writeHead(200, {
        'Content-Type': 'image/jpg',
      });
      response.end(boimg);
      console.log("200 OK: "+url);
   } else if (url=='/pics/Home.jpg') {
       response.writeHead(200, {
         'Content-Type': 'image/jpg',
       });
       response.end(himg);
       console.log("200 OK: "+url); 
  } else {
    response.writeHead(404);
    response.end('<html><head><title>404</title></head><body><h1>404</h1></html>');
    console.log("404 File not found: "+url); 
  }
}).listen(3000);