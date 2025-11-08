#!/bin/sh


# dash-safe 移除最後一個參數
for last; do :; done  # 先記住最後一個
# 重新組合其餘的參數
args=""
for a do
  [ "$a" = "$last" ] && break
  args="$args \"$a\""
done
eval "set -- $args"


echo Args: "$@" "$last"


# tar ls
if [ -z $1 ] ; then
  tar -tpvf "$last"
  exit
fi


# tar cp Copy files from tar
if echo "$1" | grep -E '\.tar$' ; then
  archive="$1"
  echo Extracting from $1
  shift
  tar -xpvf "$archive" -C "$last" "$@"
else
  echo Appending to $last
  touch "$last"
  tar -rpvf "$last" "$@"
fi

