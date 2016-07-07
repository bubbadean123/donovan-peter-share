function svid (movie,req,res,url,audio) {
  var total = movie.length;
  var range = req.headers.range;
  var positions = range.replace(/bytes=/, "").split("-");
  var start = parseInt(positions[0], 10);
  var end = positions[1] ? parseInt(positions[1], 10) : total - 1;
  var chunksize = (end-start)+1;
  if (audio) {
    res.writeHead(206, { "Content-Range": "bytes " + start + "-" + end + "/" + total,
    "Accept-Ranges": "bytes",
    "Content-Length": chunksize,
    "Content-Type":"audio/mpeg"
    });
  } else {
    res.writeHead(206, { "Content-Range": "bytes " + start + "-" + end + "/" + total,
    "Accept-Ranges": "bytes",
    "Content-Length": chunksize,
    "Content-Type":"video/mp4"
    });
  };
  res.end(movie.slice(start, end+1), "binary");
  console.log("206 Partial Content: "+url);
  return;
}
const debug=false;
const down=false;
const rtest=true;
var requests=0;
const http = require('http');
const fs = require('fs');
const css = fs.readFileSync('css/site.css');
const fcss = fs.readFileSync('css/jquery.fancybox-1.3.4.css');
const fimg = fs.readFileSync('css/fancybox.png');
const fximg = fs.readFileSync('css/fancybox-x.png');
const fyimg = fs.readFileSync('css/fancybox-y.png');
const fbimg = fs.readFileSync('css/blank.gif');
const jscript = fs.readFileSync('js/jquery-1.4.3.min.js');
const escript = fs.readFileSync('js/jquery.easing-1.3.pack.js');
const fscript = fs.readFileSync('js/jquery.fancybox-1.3.4.js');
const fscriptp = fs.readFileSync('js/jquery.fancybox-1.3.4.pack.js');
const mscript = fs.readFileSync('js/jquery.mousewheel-3.0.4.pack.js');
const index = fs.readFileSync('index.html');
const blog = fs.readFileSync('Blog.html');
const books = fs.readFileSync('Books.html');
const videos = fs.readFileSync('Videos.html');
const pictures = fs.readFileSync('Pictures.html');
const pimg = fs.readFileSync('pics/Pictures.jpg');
const vimg = fs.readFileSync('pics/Videos.jpg');
const blimg = fs.readFileSync('pics/Blog.jpg');
const boimg = fs.readFileSync('pics/Books.jpg');
const himg = fs.readFileSync('pics/Home.jpg');
const poimg = fs.readFileSync('pics/The Pond.jpg');
const poimgt = fs.readFileSync('pics/thumbnails/Pond.jpg');
const limg = fs.readFileSync('pics/A Largemouth Bass.jpg');
const limgt = fs.readFileSync('pics/thumbnails/Largemouth Bass.jpg');
const peimg = fs.readFileSync('pics/Peter with a fish.jpg');
const peimgt = fs.readFileSync('pics/thumbnails/Peter with fish.jpg');
const simg = fs.readFileSync('pics/Snugs 1.jpg');
const simgt = fs.readFileSync('pics/thumbnails/Snugs 1.jpg');
const s2img = fs.readFileSync('pics/Snugs 2.jpg');
const s2imgt = fs.readFileSync('pics/thumbnails/Snugs 2.jpg');
const s3img = fs.readFileSync('pics/Snugs 3.jpg');
const s3imgt = fs.readFileSync('pics/thumbnails/Snugs 3.jpg');
const bimg = fs.readFileSync('pics/Best pals.jpg');
const bimgt = fs.readFileSync('pics/thumbnails/Best pals.jpg');
const dimg = fs.readFileSync('pics/Dominoes.jpg');
const dimgt = fs.readFileSync('pics/thumbnails/Dominoes.jpg');
const cimg = fs.readFileSync('pics/Pitting Cherries.jpg');
const cimgt = fs.readFileSync('pics/thumbnails/Pitting Cherries.jpg');
const primg = fs.readFileSync('pics/Pretzel.jpg');
const primgt = fs.readFileSync('pics/thumbnails/Pretzel.jpg');
const rimg = fs.readFileSync('pics/A reach under cache.jpg');
const rimgt = fs.readFileSync('pics/thumbnails/A reach under cache.jpg');
const wimg = fs.readFileSync('pics/Whats under here.jpg');
const wimgt = fs.readFileSync('pics/thumbnails/Whats under here.jpg');
const caimg = fs.readFileSync('pics/Camo cache.jpg');
const caimgt = fs.readFileSync('pics/thumbnails/Camo cache.jpg');
const foimg = fs.readFileSync('pics/Found it.jpg');
const foimgt = fs.readFileSync('pics/thumbnails/Found it.jpg');
const nimg = fs.readFileSync('pics/Our first nano.jpg');
const nimgt = fs.readFileSync('pics/thumbnails/Our first nano.jpg');
const hiimg = fs.readFileSync('pics/Hidey hole.jpg');
const hiimgt = fs.readFileSync('pics/thumbnails/Hidey hole.jpg');
const taud = fs.readFileSync('audio/they lied.mp3');
const daud = fs.readFileSync('audio/dun dun dun1.mp3');
const saud = fs.readFileSync('audio/smelly bathroom.mp3');
const ivid = fs.readFileSync('Videos/Intro.mp4');
const stvid = fs.readFileSync('Videos/Standing Dive.mp4');
const fvid = fs.readFileSync('Videos/10 Feet!.mp4');
const snvid = fs.readFileSync('Videos/Snugs Attacks.mp4');
const tvid = fs.readFileSync('Videos/Tire Swing.mp4');
const hvid = fs.readFileSync('Videos/Hair Trick.mp4');
const bvid = fs.readFileSync('Videos/Basic Computer Explanation.mp4');
const mvid = fs.readFileSync('Videos/ME Serial Explanation.mp4');
const ividw = fs.readFileSync('Videos/Intro.webm');
const stvidw = fs.readFileSync('Videos/Standing Dive.webm');
const fvidw = fs.readFileSync('Videos/10 Feet!.webm');
const snvidw = fs.readFileSync('Videos/Snugs Attacks.webm');
const tvidw = fs.readFileSync('Videos/Tire Swing.webm');
const hvidw = fs.readFileSync('Videos/Hair Trick.webm');
const bvidw = fs.readFileSync('Videos/Basic Computer Explanation.webm');
const mvidw = fs.readFileSync('Videos/ME Serial Explanation.webm');
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
  if (down) {
    response.writeHead(500);
    response.end();
  } else if (rtest&&requests==0) {
    requests=requests+1
    response.writeHead(404);
    response.end();
  } else {
    requests=requests+1
    switch (url) {
      case '/':
      case '/index.html':
        response.writeHead(200, {
          'Content-Type': 'text/html',
        });
        response.end(index);
        console.log("200 OK: "+url);
        break;
      case '/Blog.html': 
        response.writeHead(200, {
          'Content-Type': 'text/html',
        });
        response.end(blog);
        console.log("200 OK: "+url);
        break;
      case '/Books.html': 
        response.writeHead(200, {
          'Content-Type': 'text/html',
        });
        response.end(books);
        console.log("200 OK: "+url);
        break;
      case '/Videos.html':
        response.writeHead(200, {
          'Content-Type': 'text/html',
        });
        response.end(videos);
        console.log("200 OK: "+url);
        break;
      case '/Pictures.html':
        response.writeHead(200, {
          'Content-Type': 'text/html',
        });
        response.end(pictures);
        console.log("200 OK: "+url);
        break;
      case '/css/site.css':
        response.writeHead(200, {
          'Content-Type': 'text/css',
        });
        response.end(css);
        console.log("200 OK: "+url);
      case '/css/jquery.fancybox-1.3.4.css':
        response.writeHead(200, {
          'Content-Type': 'text/css',
        });
        response.end(fcss);
        console.log("200 OK: "+url);
      case '/css/fancybox.png':
        response.writeHead(200, {
          'Content-Type': 'image/png',
        });
        response.end(fimg);
        console.log("200 OK: "+url);
        break;
      case '/css/fancybox-x.png':
        response.writeHead(200, {
          'Content-Type': 'image/png',
        });
        response.end(fximg);
        console.log("200 OK: "+url);
        break;
      case '/css/fancybox-y.png':
        response.writeHead(200, {
          'Content-Type': 'image/png',
        });
        response.end(fyimg);
        console.log("200 OK: "+url);
        break;
      case '/css/blank.gif':
        response.writeHead(200, {
          'Content-Type': 'image/gif',
        });
        response.end(fbimg);
        console.log("200 OK: "+url);
        break;
      case '/js/jquery-1.4.3.min.js':
        response.writeHead(200, {
          'Content-Type': 'application/javascript',
        });
        response.end(jscript);
        console.log("200 OK: "+url);
        break;
      case '/js/jquery.easing-1.3.pack.js':
        response.writeHead(200, {
          'Content-Type': 'application/javascript',
        });
        response.end(escript);
        console.log("200 OK: "+url);
        break;
      case '/js/jquery.fancybox-1.3.4.js':
        response.writeHead(200, {
          'Content-Type': 'application/javascript',
        });
        response.end(fscript);
        console.log("200 OK: "+url);
        break;
      case '/js/jquery.fancybox-1.3.4.pack.js':
        response.writeHead(200, {
          'Content-Type': 'application/javascript',
        });
        response.end(fscriptp);
        console.log("200 OK: "+url);
        break;
      case '/js/jquery.mousewheel-3.0.4.pack.js':
        response.writeHead(200, {
          'Content-Type': 'application/javascript',
        });
        response.end(mscript);
        console.log("200 OK: "+url);
        break;
      case '/pics/Pictures.jpg':
        response.writeHead(200, {
          'Content-Type': 'image/jpg',
        });
        response.end(pimg);
        console.log("200 OK: "+url);
        break;
      case '/pics/Videos.jpg':
        response.writeHead(200, {
          'Content-Type': 'image/jpg',
        });
        response.end(vimg);
        console.log("200 OK: "+url);
        break;
      case '/pics/Blog.jpg':
        response.writeHead(200, {
          'Content-Type': 'image/jpg',
        });
        response.end(blimg);
        console.log("200 OK: "+url); 
        break;
      case '/pics/Books.jpg':
        response.writeHead(200, {
          'Content-Type': 'image/jpg',
        });
        response.end(boimg);
        console.log("200 OK: "+url);
        break
      case '/pics/Home.jpg': 
        response.writeHead(200, {
          'Content-Type': 'image/jpg',
        });
        response.end(himg);
        console.log("200 OK: "+url);
        break;
      case '/pics/The%20Pond.jpg': 
        response.writeHead(200, {
          'Content-Type': 'image/jpg',
        });
        response.end(poimg);
        console.log("200 OK: "+url);
        break;
      case '/pics/thumbnails/Pond.jpg': 
        response.writeHead(200, {
          'Content-Type': 'image/jpg',
        });
        response.end(poimgt);
        console.log("200 OK: "+url);
        break
      case '/pics/A%20Largemouth%20Bass.jpg': 
        response.writeHead(200, {
          'Content-Type': 'image/jpg',
        });
        response.end(limg);
        console.log("200 OK: "+url);
        break;
      case '/pics/thumbnails/Largemouth%20Bass.jpg': 
        response.writeHead(200, {
          'Content-Type': 'image/jpg',
        });
        response.end(limgt);
        console.log("200 OK: "+url);
        break;
      case '/pics/Peter%20with%20a%20fish.jpg': 
        response.writeHead(200, {
          'Content-Type': 'image/jpg',
        });
        response.end(peimg);
        console.log("200 OK: "+url);
        break;
      case '/pics/thumbnails/Peter%20with%20fish.jpg': 
        response.writeHead(200, {
          'Content-Type': 'image/jpg',
        });
        response.end(peimgt);
        console.log("200 OK: "+url);
        break;
      case '/pics/Snugs%201.jpg': 
        response.writeHead(200, {
          'Content-Type': 'image/jpg',
        });
        response.end(simg);
        console.log("200 OK: "+url);
        break;
      case '/pics/thumbnails/Snugs%201.jpg': 
        response.writeHead(200, {
          'Content-Type': 'image/jpg',
        });
        response.end(simgt);
        console.log("200 OK: "+url);
        break;
      case '/pics/Snugs%202.jpg': 
        response.writeHead(200, {
          'Content-Type': 'image/jpg',
        });
        response.end(s2img);
        console.log("200 OK: "+url);
        break;
      case '/pics/thumbnails/Snugs%202.jpg': 
        response.writeHead(200, {
          'Content-Type': 'image/jpg',
        });
        response.end(s2imgt);
        console.log("200 OK: "+url);
        break;
      case '/pics/Snugs%203.jpg': 
        response.writeHead(200, {
          'Content-Type': 'image/jpg',
        });
        response.end(s3img);
        console.log("200 OK: "+url);
        break;
      case '/pics/thumbnails/Snugs%203.jpg': 
        response.writeHead(200, {
          'Content-Type': 'image/jpg',
        });
        response.end(s3imgt);
        console.log("200 OK: "+url);
        break;
      case '/pics/thumbnails/Best%20pals.jpg': 
        response.writeHead(200, {
          'Content-Type': 'image/jpg',
        });
        response.end(bimgt);
        console.log("200 OK: "+url);
        break;
      case '/pics/Best%20pals.jpg': 
        response.writeHead(200, {
          'Content-Type': 'image/jpg',
        });
        response.end(bimg);
        console.log("200 OK: "+url);
        break;
      case '/pics/thumbnails/Dominoes.jpg': 
        response.writeHead(200, {
          'Content-Type': 'image/jpg',
        });
        response.end(dimgt);
        console.log("200 OK: "+url);
        break;
      case '/pics/Dominoes.jpg': 
        response.writeHead(200, {
          'Content-Type': 'image/jpg',
        });
        response.end(dimg);
        console.log("200 OK: "+url);
        break;
      case '/pics/thumbnails/Pitting%20Cherries.jpg': 
        response.writeHead(200, {
          'Content-Type': 'image/jpg',
        });
        response.end(cimgt);
        console.log("200 OK: "+url);
        break;
      case '/pics/Pitting%20Cherries.jpg': 
        response.writeHead(200, {
          'Content-Type': 'image/jpg',
        });
        response.end(cimg);
        console.log("200 OK: "+url);
        break;
      case '/pics/thumbnails/Pretzel.jpg': 
        response.writeHead(200, {
          'Content-Type': 'image/jpg',
        });
        response.end(primgt);
        console.log("200 OK: "+url);
        break;
      case '/pics/Pretzel.jpg': 
        response.writeHead(200, {
          'Content-Type': 'image/jpg',
        });
        response.end(primg);
        console.log("200 OK: "+url);
        break;
      case '/pics/thumbnails/A%20reach%20under%20cache.jpg': 
        response.writeHead(200, {
          'Content-Type': 'image/jpg',
        });
        response.end(rimgt);
        console.log("200 OK: "+url);
        break;
      case '/pics/A%20reach%20under%20cache.jpg': 
        response.writeHead(200, {
          'Content-Type': 'image/jpg',
        });
        response.end(rimg);
        console.log("200 OK: "+url);
        break;
      case '/pics/thumbnails/Whats%20under%20here.jpg': 
        response.writeHead(200, {
          'Content-Type': 'image/jpg',
        });
        response.end(wimgt);
        console.log("200 OK: "+url);
        break;
      case '/pics/Whats%20under%20here.jpg': 
        response.writeHead(200, {
          'Content-Type': 'image/jpg',
        });
        response.end(wimg);
        console.log("200 OK: "+url);
        break;
      case '/pics/thumbnails/Camo%20cache.jpg': 
        response.writeHead(200, {
          'Content-Type': 'image/jpg',
        });
        response.end(caimgt);
        console.log("200 OK: "+url);
        break;
      case '/pics/Camo%20cache.jpg': 
        response.writeHead(200, {
          'Content-Type': 'image/jpg',
        });
        response.end(caimg);
        console.log("200 OK: "+url);
        break;
      case '/pics/thumbnails/Found%20it.jpg': 
        response.writeHead(200, {
          'Content-Type': 'image/jpg',
        });
        response.end(foimgt);
        console.log("200 OK: "+url);
        break;
      case '/pics/Found%20it.jpg': 
        response.writeHead(200, {
          'Content-Type': 'image/jpg',
        });
        response.end(foimg);
        console.log("200 OK: "+url);
        break;
      case '/pics/thumbnails/Hidey%20hole.jpg': 
        response.writeHead(200, {
          'Content-Type': 'image/jpg',
        });
        response.end(hiimgt);
        console.log("200 OK: "+url);
        break;
      case '/pics/Hidey%20hole.jpg': 
        response.writeHead(200, {
          'Content-Type': 'image/jpg',
        });
        response.end(hiimg);
        console.log("200 OK: "+url);
        break;
      case '/pics/thumbnails/Our%20first%20nano.jpg': 
        response.writeHead(200, {
          'Content-Type': 'image/jpg',
        });
        response.end(nimgt);
        console.log("200 OK: "+url);
        break;
      case '/pics/Our%20first%20nano.jpg': 
        response.writeHead(200, {
          'Content-Type': 'image/jpg',
        });
        response.end(nimg);
        console.log("200 OK: "+url);
        break;
      case '/audio/they%20lied.mp3':
        svid(taud,request,response,url,true);
        break;
      case '/audio/dun%20dun%20dun1.mp3':
        svid(daud,request,response,url,true);
        break;
      case '/audio/smelly%20bathroom.mp3':
        svid(saud,request,response,url,true);
        break;
      case '/Videos/Intro.mp4':
        svid(ivid,request,response,url,false);
        break;
      case '/Videos/Intro.webm':
        svid(ividw,request,response,url,false);
        break;
      case '/Videos/Standing%20Dive.webm':
        svid(stvidw,request,response,url,false);
        break;
      case '/Videos/Standing%20Dive.mp4':
        svid(stvid,request,response,url,false);
        break;
      case '/Videos/10%20Feet!.webm':
        svid(fvidw,request,response,url,false);
        break;
      case '/Videos/10%20Feet!.mp4':
        svid(fvid,request,response,url,false);
        break;
      case '/Videos/Snugs%20Attacks.webm':
        svid(snvidw,request,response,url,false);
        break;
      case '/Videos/Snugs%20Attacks.mp4':
        svid(snvid,request,response,url,false);
        break;
      case '/Videos/Tire%20Swing.webm':
        svid(tvidw,request,response,url,false);
        break;
      case '/Videos/Tire%20Swing.mp4':
        svid(tvid,request,response,url,false);
        break;
      case '/Videos/Hair%20Trick.webm':
        svid(hvidw,request,response,url,false);
        break;
      case '/Videos/Hair%20Trick.mp4':
        svid(hvid,request,response,url,false);
        break;
      case '/Videos/Basic%20Computer%20Explanation.webm':
        svid(bvidw,request,response,url,false);
        break;
      case '/Videos/Basic%20Computer%20Explanation.mp4':
        svid(bvid,request,response,url,false);
        break;
      case '/Videos/ME%20Serial%20Explanation.webm':
        svid(mvidw,request,response,url,false);
        break;
      case '/Videos/ME%20Serial%20Explanation.mp4':
        svid(mvid,request,response,url,false);
        break;
      default:
       response.writeHead(404);
       response.end('<html><head><title>404</title></head><body><p><h1>404</h1><a href="/">Home</a></p></html>');
       console.log("404 File not found: "+url); 
    }
  }
}).listen(8080);