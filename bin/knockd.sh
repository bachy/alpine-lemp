#!/bin/sh

# TODO check if root

echo -e '\033[35m
    __                    __       __
   / /______  ____  _____/ /______/ /
  / //_/ __ \/ __ \/ ___/ //_/ __  /
 / ,< / / / / /_/ / /__/ ,< / /_/ /
/_/|_/_/ /_/\____/\___/_/|_|\__,_/
\033[0m'
echo -e "\033[35;1mInstalling knockd to control ssh port opening\033[0m"

. bin/checkroot.sh

# get the current position
_cwd="$(pwd)"

# check for assets forlder
_assets="$_cwd/assets"
if [ ! -d "$_assets" ]; then
  _assets="$_cwd/../assets"
  if [ ! -d "$_assets" ]; then
    echo "!! can't find assets directory !!"
    exit
  fi
fi

sleep 2
apk add knock


echo -n "checking if ufw is installed"
ufw_installed=$(apk list -I | grep "ufw")
if ! $ufw_installed; then
  echo -n "ufw installed"
else
  . bin/ufw.sh
fi

mv /etc/knockd.conf /etc/knockd.conf.ori
cp "$_assets"/knockd.conf /etc/knockd.conf
echo -n "define a sequence number for opening ssh (as 7000,8000,9000) : "
read sq
sed -i "s/7000,8000,9000/$sq/g" /etc/knockd.conf

rc-update add knockd
/etc/init.d/knockd start

ufw delete allow ssh

echo -e "\033[92;1mknockd installed and configured\033[Om"
echo -e "\033[92;1mplease note this sequence for future ssh knocking\033[Om"
echo "$sq"
sleep 3
