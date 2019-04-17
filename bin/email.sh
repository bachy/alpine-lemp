#!/bin/sh

echo '
  __  __      _ _
 |  \/  |__ _(_) |
 | |\/| / _` | | |
 |_|  |_\__,_|_|_|
'
echo "Enable mail sending for php"

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

# http://www.sycha.com/lamp-setup-debian-linux-apache-mysql-php#anchor13
sleep 2

apk add mailx postfix

mkdir /var/mail
postmap /etc/postfix/aliases

rc-update add postfix
/etc/init.d/postfix start




# dkim spf
# echo "\033[35;1mConfiguring DKIM \033[0m"
# while [ "$installdkim" != "y" ] && [ "$installdkim" != "n" ]
# do
#   echo -n "Should we install dkim for exim4 ? [y|n] "
#   read installdkim
# done
# if [ "$installdkim" = "y" ]; then
#   echo -n "Choose a domain for dkim (same domain as you chose before for exim4): "
#   read domain
#   selector=$(date +%Y%m%d)
#
#   mkdir /etc/exim4/dkim
#   openssl genrsa -out /etc/exim4/dkim/"$domain"-private.pem 1024 -outform PEM
#   openssl rsa -in /etc/exim4/dkim/"$domain"-private.pem -out /etc/exim4/dkim/"$domain".pem -pubout -outform PEM
#   chown root:Debian-exim /etc/exim4/dkim/"$domain"-private.pem
#   chmod 440 /etc/exim4/dkim/"$domain"-private.pem
#
#   cp "$_assets"/exim4_dkim.conf /etc/exim4/conf.d/main/00_local_macros
#   sed -i -r "s/DOMAIN_TO_CHANGE/$domain/g" /etc/exim4/conf.d/main/00_local_macros
#   sed -i -r "s/DATE_TO_CHANGE/$selector/g" /etc/exim4/conf.d/main/00_local_macros
#
#   update-exim4.conf
#   systemctl restart exim4
#   echo "please create a TXT entry in your dns zone : $selector._domainkey.$domain \n"
#   echo "your public key is : \n"
#   cat /etc/exim4/dkim/"$domain".pem
#   echo "press any key to continue."
#   read continu
# else
#   echo 'dkim not installed'
# fi
