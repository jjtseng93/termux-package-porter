#!/usr/bin/env node
const http = require("http");
const { spawn } = require("child_process");

const ff = spawn("ffmpeg", [
  "-f", "pulse", "-i", "proot_audio.monitor",
  "-c:a", "libmp3lame", "-b:a", "128k",
  "-f", "mp3", "-"
]);

http.createServer((req, res) => {
  res.writeHead(200, { 
     "Content-Type": "audio/mpeg" ,
     "Cache-Control": "no-cache" ,
     "Connection": "keep-alive"    
  });

  const onData = chunk => res.write(chunk);
  ff.stdout.on("data", onData);

  req.on("close", () => {
    ff.stdout.removeListener("data", onData);
  });
}).listen(8080);

console.log("pulseaudio:proot_audio.monitor -> ffmpeg(audio/mpeg) server started on 8080")
