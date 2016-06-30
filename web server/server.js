const http = require('http');

const hostname = '127.0.0.1';
const port = 3000;
const fs = require('fs');
var index = fs.readFileSync('index.html');
var css = fs.readFileSync('site.css');
http.createServer(function (request, response) {
  var method = request.method;
  var url = request.url;
  var headers = request.headers;
  var accept = headers['accept'];
  console.log(method);
  console.log(url);
  console.log(accept);
  if (accept=='text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8') {
    response.writeHead(200, {
      'Content-Type': 'text/html',
    });
    response.end(index);
  } else if (accept=='text/css,*/*;q=0.1') {
    response.writeHead(200, {
      'Content-Type': 'text/css',
    });
    response.end(css);
  } else {
    response.writeHead(404);
    response.end();
  }
}).listen(port);