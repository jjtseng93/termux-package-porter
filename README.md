# Termux-Package-Porter
- Ports termux packages to other Android shells by libtree and zip
# Update Note 
## 2025/11/16(latest)
- 'run' is now aliased to $PKG_PDIR/no_backup/r
- so one can run micro by: run micro filename
- In sh/bash I've set alias in ~/.bashrc
- In fish you'll have to run: sh $shr micro filename
- added llama-cli package
- shizuku can now be run by simply: run rish
## 2025/11/13
- I've made a new tmpk_firstrun.sh to fit all needs
- now just copy your tmpk.zip and tmpk_firstrun.sh to any same folder(/data/data/pkn /sdcard/Android/media/pkn Termux $HOME)
- sh /path/to/tmpk_firstrun.sh
- It will handle the initial setup process for you
- The folder structure of tmpk.zip also doesn't matter anymore; it can be pure root or within subfolders, I use gruntm.sh to locate how many layers of folders to extract
# Introduction
- This is a Termux binary packaging tool
- It ports Termux native binaries into the native Android shell
- It runs by using libtree command to list all the Termux exclusive libraries
- Then it copies the binary itself and all the needed libraries into a folder
- Compress the folder into a zip file, then copy it to media_dir /sdcard/Android/media/package_name
- In this case I'm dealing with DroidScript 
- com.smartphoneremote.androidscriptfree
- Then on the target package side, it runs command from media_dir/gruntm.sh
- It unzips the binary folder to private_dir /data/data/package_name/no_backup
- e.g. I named nodejs folder nd
- If you want to run graphical apps and haven't set DISPLAY, 
-   I set DISPLAY=127.0.0.1:0 for you
- Make sure to install termux-x11 app and run this in Termux first:
  ```shell
  termux-x11 :0 -listen tcp -ac
  ```
- You may also need to start a desktop environment in Termux to manage your Terminal window
  ```shell
  export DISPLAY=:0
  dbus-launch startxfce4
  ```
# Usage
- Get package_name by X-plore or simply sharing app by link in Play Store
- I'v made the assumption in the following script that you have this project's root folder named tmpk and zipped the folder as tmpk.zip
- It can be achieved manually or in Termux by either
   ```shell
   git clone https://github.com/jjtseng93/termux-package-porter.git
   mv termux-package-porter tmpk
   zip -r tmpk.zip tmpk
   ```
- or get the zip by Code->Download Zip and
  ```shell
  unzip /sdcard/Download/termux-package-porter-main.zip
  mv termux-package-porter-main tmpk
  zip -r tmpk.zip tmpk
  ``` 
- Then you can either 
1. unzip this whole folder to /data/data/package_name and then rename tmpk to no_backup
  (due to these folders being too large, if you want to use this method,
  unzip them manually: lxt  micro  nd  qarm  qemu-img sing-box)
- *** this method is currently unstable: it requires you to also unzip the files to media_dir ***
  ```shell
  cd /data/data/package_name
  unzip /sdcard/Android/media/package_name/tmpk.zip
  # if no_backup doesn't exist
  ls -ld no_backup || mv tmpk no_backup
  
  # if no_backup exists
  chmod 777 no_backup
  ls -ld no_backup && mv tmpk/* no_backup 

  cd no_backup
  
  # then edit the pkg_name.txt under no_backup to your desired package by
  echo com.termux.x11>pkg_name.txt
  ```
2. or unzip tmpk.zip in termux home folder ~/ and run from Termux. 
  ```shell
  cd
  /system/bin/unzip /sdcard/Download/tmpk.zip
  cd tmpk
  
  # First install dependencies by 
  sh tm_install_deps.sh

  # Then change pkg_name.txt to your desired package by something like:
  echo com.termux.x11>pkg_name.txt

  # Then you can choose to setup a basic environment by 
  # sh tm_send_basics.sh
  # or
  sh tmcopyfile.sh *.zip
  ```
- Then if you want to port other binaries you can run
  ```shell
  sh tmsendelf.sh <command_name> <short_name>
  ```
- or alternatively you can only specify command_name and let short_name be the same
- Copy the command from the output of the prev scripts
- Or copy the command here and run it on the target package
-   
- If you want to open lxterminal in termux-x11
- 
  - sh /sdcard/Android/media/com.smartphoneremote.androidscriptfree/gruntm.sh lxt lxterminal
- 
  - sh /sdcard/Android/media/com.termux.x11/gruntm.sh lxt lxterminal
- 
- If you want to open http://localhost:3333 as a terminal
- 
  - sh /sdcard/Android/media/com.smartphoneremote.androidscriptfree/gruntm.sh gt gotty -w -p 3333 sh r bash
-     
  - sh /sdcard/Android/media/com.termux.x11/gruntm.sh gt gotty -w -p 3333 sh r bash
-    
- after entering lxterminal or bash/fish you can use 
  - sh r <short_name> <command_name> [args]
  - or 
  - sh r <command/folder_name> [args]
- to run commands ported onto the target package or
  - sh w
- to start bash on http://localhost:7681 by gotty
# Special note for DroidScript
- Its native Terminal waits for command return
- So you can only get an interactive terminal 
- by running lxterminal alone or gotty by the following command:
- 
  ```shell  
  rt="/sdcard/Android/media/com.smartphoneremote.androidscriptfree/gruntm.sh"; sh $rt gt gotty -p 7681 -w sh $rt bash bash
  ```
-   
# Using rsync with ssh
- First in Termux run the script in rsync
  ```shell
  sh rsync/setup_ssh.sh
  ```
- Share id_rsa to the target app, by /tmp/f if you have shizuku, or by media_dir($PKG_MDIR=/sdcard/Android/media/package_name)
- you might need something like this, please revise it to fit your need
  ```shell
  export TMPK_QUIET=1
  sh r rsync -avcn --delete -e 'sh r ssh -p 8022 -i id_rsa -o UserKnownHostsFile=ukh -o StrictHostKeyChecking=no' u0_a512@127.0.0.1:~/tmpk/fish.zip .
  ```
