#!/bin/sh

echo -e '\033[35m
    ______      _ _____   __
   / ____/___ _(_) /__ \ / /_  ____ _____
  / /_  / __ `/ / /__/ // __ \/ __ `/ __ \
 / __/ / /_/ / / // __// /_/ / /_/ / / / /
/_/    \__,_/_/_//____/_.___/\__,_/_/ /_/
\033[0m'
echo -e "\033[35;1mInstalling fall2ban \033[0m"

. bin/checkroot.sh

sleep 2

apk add fail2ban
# cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
# ToDo ask for email and configure jail.local with it
rc-update add fail2ban
# rc-update start fail2ban
# service fail2ban start
/etc/init.d/fail2ban start

echo -e "\033[92;1mfail2ban installed and configured\033[Om"
