#!/bin/sh
# Get the Package Name of the Guest app running Termux elf binaries

if ! [ -z "$TMPK_QUIET" ] ; then
  exec > /dev/null 2>&1
fi

scriptdir=$(dirname $(realpath "$0"))
# These 2 for both Termux and Guest app
if ! [ -z $PKG_NAME ] ; then
  package="$PKG_NAME"

elif [ -z "$PREFIX" ] ; then
  if echo $scriptdir | grep 'Android/media' ; then
    package=$(echo $scriptdir | grep -o -E 'Android/media/[^/]+' | grep -o -E '[^/]+' | sed -n '3p')

  elif echo $scriptdir | grep -E '^/data/data/' ; then
    package=$(echo $scriptdir | grep -o -E 'data/data/[^/]+' | grep -o -E '[^/]+' | sed -n '3p')

    PKG_PDIR=$(echo $scriptdir | grep -o -E '^/data/data/[^/]+')
  
  elif echo $scriptdir | grep -E '^/data/user/' ; then
    package=$(echo $scriptdir | grep -o -E 'data/user/[^/]+/[^/]+' | grep -o -E '[^/]+' | sed -n '4p')

    PKG_PDIR=$(echo $scriptdir | grep -o -E '^/data/user/[^/]+/[^/]+')

  fi

elif [ -f $scriptdir/pkg_name.txt  ] ; then
  package=$(cat $scriptdir/pkg_name.txt)
# These for the Guest app 
elif [ -f $scriptdir/../pkg_name.txt ] ; then
  package=$(cat $scriptdir/../pkg_name.txt)
elif echo "$HOME" | grep -E '^/data/user/' ; then
  package=$(basename "$HOME")
# Better not use this method. May fail due to permissions
else  
  package=$(/system/bin/pm list packages -U | grep $(id | grep -o -E '[0-9]*' | head -n 1) | head -n 1 | grep -o -E ':.* ' | grep -o -E '[0-9a-zA-z\.]*')
fi

#else
#  package="com.smartphoneremote.androidscriptfree"
#fi
if ! [ -z $1 ] ; then
  echo "Package name: $package"
fi
