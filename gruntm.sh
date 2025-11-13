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

if [ -z "$PKG_PDIR" ] ; then
  export PKG_PDIR="/data/data/$package"
else
  export PKG_PDIR="$PKG_PDIR"
fi

if [ -z "$HOME" ] ; then
  export HOME="$PKG_PDIR/no_backup"
fi

if [ -z "$TMPDIR" ] ; then
  export TMPDIR="$PKG_PDIR/cache"
fi

export PKG_RDIR="$PKG_PDIR/no_backup"

export shr="$PKG_PDIR/no_backup/r"

if ! echo $HOME | grep no_backup ; then
  export OPENSSL_CONF=/dev/null
fi


mkdir $PKG_PDIR/no_backup 2>/dev/null

chmod 777 $PKG_PDIR/no_backup

cd $PKG_PDIR/no_backup


if ! [ -f "$HOME/.bashrc" ] ; then
  echo alias run="\"sh $PKG_PDIR/no_backup/r\"">"$HOME/.bashrc"
elif ! cat "$HOME/.bashrc" | grep 'alias run=' ; then
  echo "">>"$HOME/.bashrc"
  echo alias run="\"sh $PKG_PDIR/no_backup/r\"">>"$HOME/.bashrc"
fi

export ENV="$HOME/.bashrc"
export TERM=xterm-256color


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
  zp=$(printf "/sdcard/Android/media/$package/%s.zip" "$1")
  if [ -f "$zp" ] ; then
    unzip "$zp"
  elif [ -f "$1.zip" ] ; then
    unzip "$1.zip"
  elif [ -f /tmp/mdir.tar ] ; then
    sh /tmp/tarcp.sh /tmp/mdir.tar $(printf "%s.zip" "$1") .
  elif [ -f /data/local/tmp/d.tar ] ; then
    sh /data/local/tmp/tarcp.sh /data/local/tmp/mdir.tar $(printf "%s.zip" "$1") .  
  fi  
fi

cd -

if [ -z "$comesfromr" ] ; then
  cd "$PKG_PDIR/no_backup/$1"
fi

if [ -z "$DISPLAY" ] ; then
  export DISPLAY=127.0.0.1:0
fi

fdn="$1"

if [ -f $PKG_PDIR/no_backup/$fdn/$fdn ] ; then
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

runpath="$PKG_PDIR/no_backup/$fdn/$elfn"

if file -b "$runpath" | grep -q "script" ; then
  sh "$runpath" "$@"
else
  export LD_LIBRARY_PATH="$PKG_PDIR/no_backup/$fdn"
  /system/bin/linker64 "$runpath" "$@"
fi
