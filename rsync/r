#!/bin/sh

if [ -f ./getpkn.sh ] ; then 
  . ./getpkn.sh
elif [ -f ../getpkn.sh ] ; then
  . ../getpkn.sh
fi

export comesfromr=1

if ls /sdcard ; then
  exec sh /sdcard/Android/media/$package/gruntm.sh "$@"
elif [ -f /tmp/gruntm.sh ] ; then
  exec sh /tmp/gruntm.sh "$@"
elif [ -f /data/local/tmp/gruntm.sh ] ; then
  exec sh /data/local/tmp/gruntm.sh "$@"
elif [ -f ./gruntm.sh ] ; then
  exec sh ./gruntm.sh "$@"
else
  echo "gruntm.sh not found at $(realpath .) media_dir /tmp /data/local/tmp"
  echo "Make sure to have it at at least one location"
fi  
