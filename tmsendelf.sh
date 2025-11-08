#!/bin/sh
# Packs elf and copy elf to media_dir and /tmp /data/local/tmp
# Also copies gruntm.sh getpkn.sh pkg_name.txt tarcp.sh

scriptdir=$(dirname $(realpath $0))

# Set package variable
. $scriptdir/getpkn.sh

# Pack elf into zip + folder
. $scriptdir/tmpackelf.sh "$@"

aliaszippath=$(printf "%s/%s.zip" "$scriptdir" "$an")


exec sh $scriptdir/tmcopyfile.sh "$aliaszippath"
