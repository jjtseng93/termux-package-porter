#!/bin/sh

chmod 777 /tmp
touch /tmp/f
chmod 777 /tmp/f

if ls /tmp ; then
  touch /tmp/gruntm.sh
  touch /tmp/getpkn.sh
  touch /tmp/tarcp.sh
  touch /tmp/mdir.tar
  chmod 777 /tmp/*.sh
  chmod 777 /tmp/mdir.tar
elif ls /data/local/tmp ; then
  touch /data/local/tmp/gruntm.sh
  touch /data/local/tmp/getpkn.sh
  touch /data/local/tmp/tarcp.sh
  touch /data/local/tmp/mdir.tar
  chmod 777 /data/local/tmp/*.sh
  chmod 777 /data/local/tmp/mdir.tar
fi
