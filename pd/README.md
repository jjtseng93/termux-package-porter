# How to run proot-distro
- currently, I've only succeeded via shizuku run-as com.termux.x11
- after entering this folder, just go
  ```shell
  sh rpr.sh
  ```
- some patches might need to be applied and are listed in the patch folder
# How to extract proot-alpine.tar 
- as a folder named pd
  ```shell
  tar -xpvf proot-alpine.tar
  ```
# How to extract alpine-minirootfs-3.22.2-aarch64.tar.gz only
  ```shell
  mkdir alpine
  tar -xzpvf alpine-minirootfs-3.22.2-aarch64.tar.gz -C alpine
  ```
# How to run vnc server in proot alpine
  ```shell
  echo "yourpassword" | vncpasswd -f > ~/.vnc/passwd

  # let it fail to generate .Xauthority
  vncserver :1

  # run the real functional vnc server
  Xvnc :1 -auth /root/.Xauthority -desktop localhost:1_alpine_root -fp /usr/share/fonts/100dpi -geometry 1280x720 -rfbauth /root/.vnc/passwd -rfbport 5901 -nolock
  ```
