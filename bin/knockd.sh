#!/bin/sh

# TODO check if root

echo -e '
  _  __             _
 | |/ /_ _  ___  __| |__
 | . <| . \/ _ \/ _| / /
 |_|\_\_||_\___/\__|_\_\
'
echo -e "Installing knockd to control ssh port opening"

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

echo -e "knockd installed and configured"
echo -e "please note this sequence for future ssh knocking"
echo "$sq"
sleep 3
