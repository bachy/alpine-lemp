#! /bin/sh

echo -e '
    _   _      _            _    ___ __  __ ___
   /_\ | |_ __(_)_ _  ___  | |  | __|  \/  | _ \
  / _ \| | ._ \ | . \/ -_) | |__| _|| |\/| |  _/
 /_/ \_\_| .__/_|_||_\___| |____|___|_|  |_|_|
         |_|
'
echo -e "\033[35;1mThis script has been tested only on Alpine Linux \033[0m"

. bin/checkroot.sh

echo -n "Should we start? [y|n] "
read yn
yn=${yn:-y}
if [ "$yn" != "y" ] && [ "$yn" != "Y" ]; then
  echo -e "aborting script!"
  exit
fi

# get the current position
_cwd="$(pwd)"

. bin/upgrade.sh
# . bin/bash.sh
. bin/misc.sh
. bin/dotfiles.sh
. bin/user.sh
. bin/ssh.sh
. bin/ufw.sh
. bin/fail2ban.sh
. bin/knockd.sh
# . bin/email.sh
. bin/lemp.sh
. bin/mysqlbackup.sh
# . bin/vhost.sh
. bin/zabbix.sh
. bin/urbackup.sh
