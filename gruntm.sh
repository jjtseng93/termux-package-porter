#!/bin/sh
# Guest app Runs Termux binaries

# package="com.smartphoneremote.androidscriptfree"

if ! [ -z "$TMPK_QUIET" ] ; then
  exec > /dev/null 2>&1
fi

scriptdir=$(dirname $(realpath "$0"))
. $scriptdir/getpkn.sh 

export PKG_NAME="$package"
export PKG_MDIR="/sdcard/Android/media/$package"
export PKG_DDIR="/sdcard/Android/data/$package"
export PKG_PDIR="/data/data/$package"

if [ -z "$HOME" ] ; then
  export HOME="$PKG_PDIR/no_backup"
fi

if [ -z "$TMPDIR" ] ; then
  export TMPDIR="$PKG_PDIR/cache"
fi



echo "This package is $package"

mkdir /data/data/$package/no_backup 2>/dev/null

chmod 777 /data/data/$package/no_backup

cd /data/data/$package/no_backup

if ! [ -f r ] ; then
cp "/sdcard/Android/media/$package/r" . \
|| sh /tmp/tarcp.sh /tmp/mdir.tar r .  \
|| sh /data/local/tmp/tarcp.sh /data/local/tmp/mdir.tar r . 
fi

if ! [ -f getpkn.sh ] ; then
  cp "/sdcard/Android/media/$package/getpkn.sh" . \
  || cp "/tmp/getpkn.sh" . \
  || cp "/data/local/tmp/getpkn.sh"
fi

if ! [ -f pkg_name.txt ] ; then 
  cp "/sdcard/Android/media/$package/pkg_name.txt" .
fi

if ! [ -d "$1" ] ; then 
  if ls /sdcard ; then
    unzip $(printf "/sdcard/Android/media/$package/%s.zip" "$1")
  elif [ -f /tmp/mdir.tar ] ; then
    sh /tmp/tarcp.sh /tmp/mdir.tar $(printf "%s.zip" "$1") .
  elif [ -f /data/local/tmp/d.tar ] ; then
    sh /data/local/tmp/tarcp.sh /data/local/tmp/mdir.tar $(printf "%s.zip" "$1") .  
  fi  
fi

cd -

if [ -z "$comesfromr" ] ; then
  cd "/data/data/$package/no_backup/$1"
fi

if [ -z "$DISPLAY" ] ; then
  export DISPLAY=127.0.0.1:0
fi

fdn="$1"

if [ -f /data/data/$package/no_backup/$fdn/$fdn ] ; then
  elfn="$1"
else
  elfn="$2"
fi

if [ -z $2 ] || 
   [ $elfn != $2 ]; then
  elfn="$1"
  shift 1
else
  shift 2
fi

if ! [ -z "$TMPK_QUIET" ] ; then
  exec > /dev/tty 2>&1
fi

runpath="/data/data/$package/no_backup/$fdn/$elfn"

if file -b "$runpath" | grep -q "script" ; then
  sh "$runpath" "$@"
else
  export LD_LIBRARY_PATH="/data/data/$package/no_backup/$fdn"
  /system/bin/linker64 "$runpath" "$@"
fi
