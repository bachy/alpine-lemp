#!/bin/sh

echo -e '\033[35m
    __  ____
   /  |/  (_)_________
  / /|_/ / / ___/ ___/
 / /  / / (__  ) /__
/_/  /_/_/____/\___/

\033[0m'

. checkroot.sh

sleep 2

echo '@edge http://dl-cdn.alpinelinux.org/alpine/edge/main
@edgecommunity http://dl-cdn.alpinelinux.org/alpine/edge/community
@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories

apk add vim curl
# sed -i "s/^# en_GB.UTF-8/en_GB.UTF-8/g" /etc/locale.gen
# locale-gen
# apt-get --yes --force-yes install ntp
# dpkg-reconfigure tzdata
apk add tmux etckeeper htop lynx unzip # needrestart

echo -e "\033[92;1mMisc done \033[Om"
