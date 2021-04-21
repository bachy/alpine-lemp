#!/bin/sh

echo -e '
  __  __ _
 |  \/  (_)___ __
 | |\/| | (_-</ _|
 |_|  |_|_/__/\__|
'

. bin/checkroot.sh

sleep 2

echo '@edge http://dl-cdn.alpinelinux.org/alpine/edge/main
@edgecommunity http://dl-cdn.alpinelinux.org/alpine/edge/community
@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories

apk update

apk add procps vim curl tmux etckeeper htop lynx unzip grep shadow coreutils certbot pwgen rsync patch #ntp # needrestart

# sed -i "s/^# en_GB.UTF-8/en_GB.UTF-8/g" /etc/locale.gen
# locale-gen

apk add tzdata
TIMEZONE="Europe/Paris"
cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
echo "${TIMEZONE}" > /etc/timezone

rc-service crond start && rc-update add crond

git config --global core.safecrlf false

echo "limiting su to the admin group"
groupadd admin
echo -e "auth       required   pam_wheel.so    group=admin" >> /etc/pam.d/su

echo -e "Misc done"
