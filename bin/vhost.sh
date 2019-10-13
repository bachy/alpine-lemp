#!/bin/bash

echo -e '
      _           _
 __ _| |_  ___ __| |_
 \ V / ` \/ _ (_-<  _|
  \_/|_||_\___/__/\__|
'
echo -e "Nginx VHOST install "

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

while [ "$_domain" = "" ]
do
  read -p "enter a domain name ? " _domain
  if [ "$_domain" != "" ]; then
    read -p "is domain $_domain correcte [y|n] " validated
    if [ "$validated" = "y" ]; then
      break
    else
      _domain=""
    fi
  fi
done

# ask for simple php conf or drupal conf
while [ "$_drupal" != "yes" ] && [ "$_drupal" != "no" ]
do
  echo -n "Is your site is a drupal one? [yes|no] "
  read _drupal
done

# ask for let's encrypt
while [ "$_letsencrypt" != "yes" ] && [ "$_letsencrypt" != "no" ]
do
  echo -e "Let's encrypt"
  echo -e "Let's encrypt needs a public registered domain name with proper DNS records ( A records or CNAME records for subdomains pointing to your server)."
  echo -n "Should we install let's encrypt certificate with $_domain? [yes|no] "
  read _letsencrypt
done

service nginx stop

# lets'encrypt
# https://certbot.eff.org/lets-encrypt/debianstretch-nginx
if [ "$_letsencrypt" = "yes" ]; then
  apk add certbot
  certbot certonly --standalone -d "$_domain" --cert-name "$_domain"
  # TODO stop the whole process if letsencrypt faile
  mkdir -p /etc/nginx/ssl/certs/"$_domain"
  openssl dhparam -out /etc/nginx/ssl/certs/"$_domain"/dhparam.pem 2048
  # renewing
  touch /var/spool/cron/crontabs/root
  crontab -l > mycron
  echo -e "0 3 * * * certbot renew --pre-hook 'service nginx stop' --post-hook 'service nginx start' --cert-name $_domain" >> mycron
  crontab mycron
  rm -f mycron
fi

if [ "$_drupal" = "yes" ]; then
  if [ "$_letsencrypt" = "yes" ]; then
    _conffile="drupal-ssl.nginxconf"
  else
    _conffile="drupal.nginxconf"
  fi
else
  if [ "$_letsencrypt" = "yes" ]; then
    _conffile="simple-phpfpm-ssl.nginxconf"
  else
    _conffile="simple-phpfpm.nginxconf"
  fi
fi

cp "$_assets/vhosts/$_conffile" /etc/nginx/conf.d/"$_domain".conf
sed -i -r "s/DOMAIN\.LTD/$_domain/g" /etc/nginx/conf.d/"$_domain".conf

mkdir -p /var/www/"$_domain"/app/web
mkdir /var/www/"$_domain"/log

cp "$_assets/vhosts/index.php" /var/www/"$_domain"/app/web/
sed -i -r "s/DOMAIN\.LTD/$_domain/g" /var/www/"$_domain"/app/web/index.php

#set proper right to user will handle the app
chown -R www:www  /var/www/"$_domain"/
# chmod -R g+w /var/www/"$_domain"/
# chmod -R g+r /var/www/"$_domain"/

# create a shortcut to the site
echo -n "Should we install a shortcut for a user? [Y|n] "
read yn
yn=${yn:-y}
if [ "$yn" = "Y" ] || [ "$yn" = "y" ]; then
  # if $user var does not exists (vhost.sh ran directly) ask for it
  if [ -z ${user+x} ]; then
    while [ "$user" = "" ]
    do
      read -p "enter an existing user name ? " user
      if [ "$user" != "" ]; then
        # check if user already exists
        if id "$user" >/dev/null 2>&1; then
          read -p "is user name $user correcte [y|n] " validated
          if [ "$validated" = "y" ]; then
            break
          else
            user=""
          fi
        else
          echo -e "user $user doesn't exists, you must provide an existing user"
          user=""
        fi
      fi
    done
  fi

  echo -e "installing shortcut for '$user'";

  mkdir /home/"$user"/www/
  chown "$user":"$user" /home/"$user"/www/
  ln -s /var/www/"$_domain" /home/"$user"/www/"$_domain"
  chown "$user":"$user" /home/"$user"/www/"$_domain"
  chown -R www:"$user" /home/"$user"/www/"$_domain"/app
  chmod -R g+rw /home/"$user"/www/"$_domain"/app

  . bin/gitdeploy.sh
else
  echo -e 'no shortcut installed'
fi
# activate the vhost
# ln -s /etc/nginx/sites-available/"$_domain".conf /etc/nginx/sites-enabled/"$_domain".conf

nginx -t

# restart nginx
service nginx start
echo -e "vhost $_domain configured"
