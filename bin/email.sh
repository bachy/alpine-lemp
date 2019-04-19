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

sleep 2

apk add postfix mailx

mkdir /var/mail
postmap /etc/postfix/aliases

rc-update add postfix
/etc/init.d/postfix start

# https://www.cyberciti.biz/faq/how-to-find-out-the-ip-address-assigned-to-eth0-and-display-ip-only/
_IP=$(ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
_MASK=$(ifconfig eth0 | grep 'inet addr:' | cut -d: -f4)

# echo -n "Please provide a bounce email address: "
# read _bounce_email

# DMARC

# reverse dns

# dkim
echo "Configuring DKIM"

apk add opendkim opendkim-utils

mkdir /etc/opendkim/keys
opendkim-genkey -b 2048 -d "$HOSTNAME" -s "$HOSTNAME".dkim --directory=/etc/opendkim/keys/

chown opendkim:opendkim /etc/opendkim/keys/*

mv /etc/opendkim/opendkim.conf /etc/opendkim/opendkim.conf.back
cp "$_assets"/opendkim/opendkim.conf /etc/opendkim.conf

echo "*@$HOSTNAME $HOSTNAME" > /etc/opendkim/signtable
echo "$HOSTNAME $HOSTNAME:mail:/etc/opendkim/keys/$HOSTNAME.dkim.private" > /etc/opendkim/keytable
echo -e "localhost\n127.0.0.1\n$HOSTNAME\n$_IP/$_MASK" > /etc/internalhosts
echo -e "smtpd_milters = unix:/run/opendkim/opendkim.sock\nnon_smtpd_milters = unix:/run/opendkim/opendkim.sock" >> /etc/postfix/main.cf

rc-update add opendkim
service opendkim start
service postfix restart
echo "please create a DKIM entry in your dns zone : mail._domainkey.$HOSTNAME \n"
echo "your public key is : \n"
cat /etc/opendkim/keys/"$HOSTNAME".dkim.txt

echo -e "SPF"
echo -e "you should edit an spf entry for $HOSTNAME in your dns zone :"
echo -e "v=spf1 a mx ip4:$_IP"

echo -e "MX"
echo -e "If it does not exists, you should create an mx zone record for $HOSTNAME"

echo "press any key to continue."
read continu
