# How to run proot-distro
- currently, I've only succeeded via shizuku run-as com.termux.x11
- after entering this folder, just go
  ```shell
  sh rpr.sh
  ```
- some patches might need to be applied and are listed in the patch folder
# extract proot-alpine.tar as a folder named pd
  ```shell
  tar -xpvf proot-alpine.tar
  ```
# extract alpine-minirootfs-3.22.2-aarch64.tar.gz
  ```shell
  mkdir alpine
  tar -xzpvf alpine-minirootfs-3.22.2-aarch64.tar.gz -C alpine
  ```
