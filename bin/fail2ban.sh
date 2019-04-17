#!/bin/sh

echo -e '
  ___     _ _ ___ _
 | __|_ _(_) |_  ) |__  __ _ _ _
 | _/ _` | | |/ /| ._ \/ _` | . \ 
 |_|\__,_|_|_/___|_.__/\__,_|_||_|
'
echo -e "Installing fall2ban"

. bin/checkroot.sh

sleep 2

apk add fail2ban
# cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
# ToDo ask for email and configure jail.local with it
rc-update add fail2ban
# rc-update start fail2ban
# service fail2ban start
/etc/init.d/fail2ban start

echo -e "fail2ban installed"
