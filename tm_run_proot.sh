#!/bin/sh
# Runs proot in Termux without the command proot-distro(pd), for testing only, not very stable


rootfs="debian"
if ! [ -z $1 ] ; then
  rootfs="$1"
fi
rootfs="$PREFIX/var/lib/proot-distro/installed-rootfs/$rootfs"

guestlang="zh_TW.UTF-8"
guestlanguage="zh_TW:zh:en_US:en"
defaultshell="/bin/sh"


export LD_PRELOAD="" 
export PROOT_TMP_DIR=$rootfs/tmp

/system/bin/linker64 $PREFIX/bin/proot --bind=/linkerconfig/com.android.art/ld.config.txt --bind=/linkerconfig/ld.config.txt --bind=/vendor --bind=/system_ext --bind=/system --bind=/product --bind=/odm --bind=/apex --bind=/storage/self/primary:/storage/self/primary --bind=/storage/self/primary:/storage/emulated/0 --bind=/storage/self/primary:/sdcard --bind=/data/misc/apexdata/com.android.art/dalvik-cache --bind=/data/dalvik-cache --bind=/data/app --bind=$rootfs/tmp:/dev/shm --bind=/proc/self/fd/2:/dev/stderr --bind=/proc/self/fd/1:/dev/stdout --bind=/proc/self/fd/0:/dev/stdin --bind=/sys --bind=/proc/self/fd:/dev/fd --bind=/proc --bind=/dev/urandom:/dev/random --bind=/dev -L --kernel-release=6.2.1-PRoot-Distro --sysvipc --link2symlink --kill-on-exit --cwd=/root --change-id=0:0 --rootfs="$rootfs" /usr/bin/env -i PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/games:/usr/games:/system/bin:/system/xbin ANDROID_ART_ROOT=/apex/com.android.art ANDROID_DATA=/data ANDROID_I18N_ROOT=/apex/com.android.i18n ANDROID_ROOT=/system ANDROID_TZDATA_ROOT=/apex/com.android.tzdata EXTERNAL_STORAGE=/sdcard SHELL="$defaultshell" LANG="$guestlang" LANGUAGE="$guestlanguage" LC_ALL="$guestlang" MOZ_FAKE_NO_SANDBOX=1 PULSE_SERVER=127.0.0.1 TERM=xterm-256color TMPDIR=/tmp COLORTERM=truecolor HOME=/root USER=root "$defaultshell" -l
