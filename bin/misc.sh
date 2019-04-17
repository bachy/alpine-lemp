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

apk add procps vim curl tmux etckeeper htop lynx unzip # needrestart

# sed -i "s/^# en_GB.UTF-8/en_GB.UTF-8/g" /etc/locale.gen
# locale-gen

apk add tzdata
TIMEZONE="Europe/Paris"
cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
echo "${TIMEZONE}" > /etc/timezone

echo -e "\033[92;1mMisc done \033[Om"
