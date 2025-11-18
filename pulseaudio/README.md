# Playing audio from proot to Android native Chrome
- requires 3 steps: pulse server, ffmpeg porting, Android Chrome
## Pulseaudio server
- first start pulseaudio server at the guest app running bash
- the $shr refers to /data/data/package_name/no_backup/r
- assuming you have already ran tmpk_firstrun.sh in advance and started bash
  ```shell
  sh $shr pulseaudio --start --exit-idle-time=-1 --daemonize --load="module-native-protocol-tcp auth-anonymous=1" --load="module-null-sink sink_name=proot_audio"
  # or if using bash or sh I've set alias 'run' to replace sh $shr 
  ```
## ffmpeg porting
- then in the proot alpine install nodejs-current ffmpeg
- and copy the streamto_browser folder to your desired place and switch into it
- you can use shizuku to create a /tmp/f or /data/local/tmp/f for transfering every file you need
- to use tar for packing and unpacking:
- tar -cvf name.tar folder
- tar -xvf name.tar
  ```shell
  export PULSE_SERVER=127.0.0.1
  sh start_pulseaudio_streaming.sh
  ```
- by default, I start python3 as webpage server at port 8000
- nodejs as ffmpeg launcher listening at port 8080
- ffmpeg grabs audio from proot_audio.monitor, which is a null sink
## Open Android native Chrome
- default at http://localhost:8000 
