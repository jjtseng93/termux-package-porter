#!/bin/sh

rootfs="alpine"
if ! [ -z $1 ] ; then
  rootfs="$1"
fi
guestlang="zh_TW.UTF-8"
guestlanguage="zh_TW:zh:en_US:en"
defaultshell="/bin/sh"

export PROOT_TMP_DIR=$rootfs/tmp
export LD_PRELOAD="" 
export LD_LIBRARY_PATH=.

./ld-linux-aarch64.so.1 ./proot -l --bind=/linkerconfig/com.android.art/ld.config.txt --bind=/linkerconfig/ld.config.txt --bind=/vendor --bind=/system_ext --bind=/system --bind=/product --bind=/odm --bind=/apex --bind=/storage/self/primary:/storage/self/primary --bind=/storage/self/primary:/storage/emulated/0 --bind=/storage/self/primary:/sdcard --bind=/data/misc/apexdata/com.android.art/dalvik-cache --bind=/data/dalvik-cache --bind=/data/app --bind=$rootfs/tmp:/dev/shm --bind=/proc --bind=/proc/self/fd/2:/dev/stderr --bind=/proc/self/fd/1:/dev/stdout --bind=/proc/self/fd/0:/dev/stdin --bind=/sys --bind=/proc/self/fd:/dev/fd --bind=/dev/urandom:/dev/random --bind=/dev --kernel-release=5.4.0-PRoot --kill-on-exit --cwd=/root --change-id=0:0 --rootfs="$rootfs" /usr/bin/env -i DISPLAY=:0 PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/games:/usr/games ANDROID_ART_ROOT=/apex/com.android.art ANDROID_DATA=/data ANDROID_I18N_ROOT=/apex/com.android.i18n ANDROID_ROOT=/system ANDROID_TZDATA_ROOT=/apex/com.android.tzdata EXTERNAL_STORAGE=/sdcard SHELL="$defaultshell" LANG="$guestlang" LANGUAGE="$guestlanguage" LC_ALL="guestlang" MOZ_FAKE_NO_SANDBOX=1 PULSE_SERVER=127.0.0.1 TERM=xterm-256color TMPDIR=/tmp COLORTERM=truecolor HOME=/root USER=root "$defaultshell" -l
