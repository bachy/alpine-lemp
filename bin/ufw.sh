#!/bin/sh

echo -e '\033[35m
    ______________  _______       _____    __    __
   / ____/  _/ __ \/ ____/ |     / /   |  / /   / /
  / /_   / // /_/ / __/  | | /| / / /| | / /   / /
 / __/ _/ // _, _/ /___  | |/ |/ / ___ |/ /___/ /___
/_/   /___/_/ |_/_____/  |__/|__/_/  |_/_____/_____/
\033[0m'
echo -e "\033[35;1mInstalling ufw and setup firewall (allowing only ssh and http) \033[0m"

. bin/checkroot.sh
sleep 2

# TODO use awall instead of ufw ?

# ufw
apk add ufw
ufw allow ssh # knockd will open the ssh port
ufw allow http
ufw allow https
# TODO ask for allowing ssh for some ip

ufw enable
ufw status verbose
echo -e "\033[92;1mufw installed and firwall configured\033[Om"
