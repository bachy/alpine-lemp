#!/bin/sh

echo -e '
  _   _ _____      __
 | | | | __\ \    / /
 | |_| | _| \ \/\/ /
  \___/|_|   \_/\_/
'
echo -e "Installing ufw and setup firewall (allowing only ssh and http)"

. bin/checkroot.sh
sleep 2

# TODO use awall instead of ufw ?

# BUG
# ufw
# Traceback (most recent call last):
#   File "/usr/sbin/ufw", line 25, in <module>
#     import ufw.frontend
# ModuleNotFoundError: No module named 'ufw'


# ufw
apk add ufw@edgecommunity
ufw allow ssh # knockd will open the ssh port
ufw allow http
ufw allow https
# TODO ask for allowing ssh for some ip

ufw enable
ufw status verbose
echo -e "ufw installed and firwall configured"
