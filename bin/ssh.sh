#!/bin/sh

echo '
        _
  _____| |_
 (_-<_-< . \
 /__/__/_||_|
'

. bin/checkroot.sh

sed -i 's/#PermitRootLogin\ prohibit-password/PermitRootLogin prohibit-password/g' /etc/ssh/sshd_config
sed -i 's/#PermitEmptyPasswords\ yes/PermitEmptyPasswords no/g' /etc/ssh/sshd_config

/etc/init.d/sshd restart
echo "SSH secured"
