#!/bin/sh
# Copy $@ files + r gruntm.sh getpkn.sh pkg_name.txt to media_dir or /tmp /data/local/tmp

scriptdir=$(dirname $(realpath $0))

. $scriptdir/getpkn.sh


mkdir /sdcard/Android/media/$package

cp "$@" $scriptdir/r $scriptdir/gruntm.sh $scriptdir/getpkn.sh $scriptdir/pkg_name.txt /sdcard/Android/media/$package

#cp pkg_name.txt /tmp
#cp pkg_name.txt /data/local/tmp

# if [ -f /tmp/gruntm.sh ] ; then
  cp $scriptdir/gruntm.sh /tmp/gruntm.sh
# elif [ -f /data/local/tmp/gruntm.sh ] ; then
  cp $scriptdir/gruntm.sh /data/local/tmp/gruntm.sh
# fi
  cp $scriptdir/getpkn.sh /tmp/getpkn.sh
  cp $scriptdir/getpkn.sh /data/local/tmp/getpkn.sh

  cp $scriptdir/tarcp.sh /tmp/tarcp.sh
  cp $scriptdir/tarcp.sh /data/local/tmp/tarcp.sh
  


if [ -f /tmp/mdir.tar ] ; then
  sh $scriptdir/tarcp.sh "$@" r /tmp/mdir.tar
elif [ -f /data/local/tmp/mdir.tar ] ; then
  sh $scriptdir/tarcp.sh "$@" r /data/local/tmp/mdir.tar
fi


echo "Copied $@ to media folder /tmp/mdir.tar /data/local/tmp/mdir.tar"
echo "Copied gruntm.sh getpkn.sh to those folders"
echo "Coped r pkg_name.txt to media folder"


echo "Now copy one of the commands below to run on the target package's side"
echo ""
echo "    sh /sdcard/Android/media/$package/gruntm.sh $an $elfn"
echo ""
echo "    sh /tmp/gruntm.sh $an $elfn"
echo ""
echo "    sh /data/local/tmp/gruntm.sh $an $elfn"
echo ""
