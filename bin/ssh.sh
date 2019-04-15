#!/bin/sh

echo '\033[35m
   __________ __  __
  / ___/ ___// / / /
  \__ \\__ \/ /_/ /
 ___/ /__/ / __  /
/____/____/_/ /_/
\033[0m'

. bin/checkroot.sh

sed -i 's/#PermitRootLogin\ prohibit-password/PermitRootLogin no/g' /etc/ssh/sshd_config
sed -i 's/#PermitEmptyPasswords\ yes/PermitEmptyPasswords no/g' /etc/ssh/sshd_config

/etc/init.d/sshd restart
echo "\033[92;1mSSH secured\033[Om"
