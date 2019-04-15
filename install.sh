#! /bin/sh

echo -e '\033[35m
    _   _      _            _    ___ __  __ ___
   /_\ | |_ __(_)_ _  ___  | |  | __|  \/  | _ \
  / _ \| | '_ \ | ' \/ -_) | |__| _|| |\/| |  _/
 /_/ \_\_| .__/_|_||_\___| |____|___|_|  |_|_|
         |_|
\033[0m'
echo -e "\033[35;1mThis script has been tested only on Alpine Linux \033[0m"

. bin/checkroot.sh

echo -n "Should we start? [Y|n] "
read yn
yn=${yn:-y}
if [ "$yn" != "y" ]; then
  echo -e "aborting script!"
  exit
fi

# get the current position
_cwd="$(pwd)"

. bin/upgrade
. bin/user.sh
. bin/misc.sh
. bin/ufw.sh
. bin/fail2ban.sh
. bin/knockd.sh


# . bin/lemp.sh
