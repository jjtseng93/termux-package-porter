#!/bin/sh

sd=$(dirname $(realpath "$0"))
sb=$(basename $(realpath "$0"))

cd "$sd"


# Detect which zip file to use
zp="tmpk.zip"

if [ -f "$zp" ] ; then
  echo "Zip file: $zp"
else
  zp=$(ls tmpk*.zip | head -n 1)

  if ! [ -z "$zp" ] ; then
    echo "Zip file: $zp"
  else
    echo "Error: Zip file not found!"

    cd -
    exit 1
  fi
fi


# Detect whether running in Termux
if echo $PREFIX | grep termux ; then
  echo Running in Termux

  pknp=$(/system/bin/unzip -l "$zp" | grep pkg_name | awk '{print $4}')

  if [ -z "$pknp" ] ; then
    echo "Error: pkg_name.txt not found!"

    cd -
    exit 1
  fi

  /system/bin/unzip -j "$zp" "$pknp"

  pkg=$(cat pkg_name.txt)

  if [ -z "$pkg" ] ; then
    echo "Error: package name not specified!"

    cd -
    exit 1
  fi

  echo "Package name: $pkg"

  mdir="/sdcard/Android/media/$pkg"

  cp "$sb" "$zp" "$mdir"

  echo "Copyied $sb and $zp to media dir:"
  echo "  $mdir"
  echo "Proceed with running at guest App's shell"
  echo ""
  echo "    sh $mdir/$sb"
  echo ""

  cd -
  exit
fi


# Detect whether running in guest app media dir
if pwd | grep 'Android/media' ; then
  pkg=$(pwd | grep -o -E 'Android/media/[^/]+' | grep -o -E '[^/]+' | sed -n '3p')

  echo "Package name: $pkg"

  grp=$(/system/bin/unzip -l "$zp" | grep gruntm | awk '{print $4}')

  grd=$(dirname "$grp")


: <<'EOF'

  if [ -f "gruntm.sh" ] ; then
    echo -n "gruntm.sh already exist, overwrite with the whole zip?(y,N)"
    read ans
    if ! echo $ans | grep -i y ; then
      echo "Aborting!"

      cd -
      exit
    fi
  fi

EOF


  /system/bin/unzip -o "$zp"


  zlist=$(/system/bin/unzip -l "$zp" | awk '{print $4}' | tail -n +4 | tac | tail -n +3 | tac)


  if ! [ "$grd" = "." ] ; then
  
    zlist=$(cat <<EOF | grep -E "^$grd/[^/]+/?$"
$zlist
EOF
)
    # printf "$zlist"
  fi

  
while IFS= read -r f; do
if ! [ "$grd" = "." ] ; then
  newpath=$(echo "$f" | sed "s|^$grd/|./|")
  echo "mv: $f $newpath"
  mv "$f" "$newpath"
fi
done <<EOF
$zlist
EOF



  echo "$pkg">pkg_name.txt

  echo "*** If you see the Gotty help msg below then the installation is complete ***"

  sh gruntm.sh gt gotty

  echo "*** If you see the Gotty help msg above then the installation is complete ***"

  echo "You can now run bash:"
  echo ""
  echo "sh /data/data/$pkg/no_backup/r bash"
  echo ""
  
  exit
fi

if pwd | grep -E '^/data/' ; then
  if pwd | grep -E '^/data/data/' ; then
    pdir=$(pwd | grep -o -E '^/data/data/[^/]+')
  elif pwd | grep -E '^/data/user/' ; then
    pdir=$(pwd | grep -o -E '^/data/user/[^/]+/[^/]+')
  else
    echo "Error: unable to locate app private dir under $(pwd)"
    
    cd -
    exit
  fi

  mkdir "$pdir/no_backup"
  chmod 777 "$pdir/no_backup"
  mv "$sb" "$zp" "$pdir/no_backup"

  cd -
  cd "$pdir/no_backup"

  grp=$(/system/bin/unzip -l "$zp" | grep gruntm | awk '{print$4}')
  
  grd=$(dirname "$grp")

  /system/bin/unzip -o "$zp"


  zlist=$(/system/bin/unzip -l "$zp" | awk '{print $4}' | tail -n +4 | tac | tail -n +3 | tac)


  if ! [ "$grd" = "." ] ; then

    zlist=$(cat <<EOF | grep -E "^$grd/[^/]+/?$"
$zlist
EOF
)
    # printf "$zlist"
  fi


while IFS= read -r f; do
if ! [ "$grd" = "." ] ; then
  newpath=$(echo "$f" | sed "s|^$grd/|./|")
  echo "mv: $f $newpath"
  mv "$f" "$newpath"
fi
done <<EOF
$zlist
EOF



  cd -
  cd "$pdir"
  

  if pwd | grep -E '^/data/data/' ; then
    pkg=$(pwd | grep -o -E 'data/data/[^/]+' | grep -o -E '[^/]+' | sed -n '3p')
  elif pwd | grep -E '^/data/user/' ; then
    pkg=$(pwd | grep -o -E 'data/user/[^/]+/[^/]+' | grep -o -E '[^/]+' | sed -n '4p')
  fi

  echo "$pkg">no_backup/pkg_name.txt

  echo "Package name: $pkg"

  echo "*** If you see the Gotty help msg below then the installation is complete ***"

  sh no_backup/r gt gotty

  echo "*** If you see the Gotty help msg above then the installation is complete ***"

  echo "You can now run bash:"
  echo ""
  echo "sh $pdir/no_backup/r bash"
  echo ""

  exit
fi

echo "Error: Execution failure!"
echo "I'm not in Termux, not in media_dir and not in /data/data"

cd -

exit 1

