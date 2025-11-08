#!/bin/sh
# Send basic commands and tools to Guest app

scriptdir=$(dirname $(realpath "$0"))
tmsh="$scriptdir/tmsendelf.sh"

sh $tmsh lxterminal lxt
sh $tmsh bash
sh $tmsh micro
sh $tmsh gotty gt
sh $tmsh xclock xc
sh $tmsh node nd
