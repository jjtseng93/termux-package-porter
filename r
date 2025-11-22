#!/bin/sh

sd=$(dirname $(realpath "$0"))
sb=$(basename $(realpath "$0"))

if [ -f "$sd/getpkn.sh" ] ; then 
  . $sd/getpkn.sh
elif [ -f "$sd/../getpkn.sh" ] ; then
  . $sd/../getpkn.sh
fi

if [ "$1" = "-p" ] ; then
  export TMPK_PRELOAD_EXECVE=1
  shift
fi

export comesfromr=1

if [ -f $sd/gruntm.sh ] ; then

  if [ -d /sdcard/Android/media ] ; then
    mkdir /sdcard/Android/media/$package 2>/dev/null
    cp $sd/gruntm.sh $sd/getpkn.sh $sd/pkg_name.txt "/sdcard/Android/media/$package" 2>/dev/null
  fi
  
  exec sh $sd/gruntm.sh "$@"
  
elif [ -f "/sdcard/Android/media/$package/gruntm.sh" ] ; then
  exec sh /sdcard/Android/media/$package/gruntm.sh "$@"
elif [ -f /tmp/gruntm.sh ] ; then
  exec sh /tmp/gruntm.sh "$@"
elif [ -f /data/local/tmp/gruntm.sh ] ; then
  exec sh /data/local/tmp/gruntm.sh "$@"
else
  echo "gruntm.sh not found at $sd media_dir /tmp /data/local/tmp"
  echo "Make sure to have it at at least one location"
fi  
