#!/bin/sh
# Packs Termux elf binaries into a folder and a zip here

scriptdir=$(dirname $(realpath $0))

libtree -p $(which "$1") | grep -o -E '(/data.*?) '>"$scriptdir/dep.txt"

# alias name an
if [ -z "$2" ] ; then
  export an="$1"
else
  export an="$2"
fi

mkdir "$scriptdir/$an"

cp r w "$scriptdir/$an"

awk '{$1=$1} NF' "$scriptdir/dep.txt" | xargs -I{} cp "{}" "$an"

zip -r $(printf "%s.zip" "$an") "$an"

export elfn="$1"
