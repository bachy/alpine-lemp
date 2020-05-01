#!/bin/sh

echo -e '
  _
 | |___ _ __  _ __
 | / -_) '  \| '_ \
 |_\___|_|_|_| .__/
             |_|
'
echo -e "LEMP server (Nginx Mysql Php-fpm)"

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

echo -e '
                     _
  _ __ _  _ ___ __ _| |
 | .  \ || (_-</ _` | |
 |_|_|_\_, /__/\__, |_|
       |__/       |_|
'
echo -e "installing Mysql"
sleep 3

apk add mariadb mariadb-client mariadb-common

# https://bugs.alpinelinux.org/issues/9046
echo -n "are Maridb databases strored in a zfs file system (eg. through proxmox container)? [y|n] "
read yn
if [ "$yn" = "Y" ] || [ "$yn" = "y" ]; then
  echo -e "Stick with mariadb 10.1.x due to incompatibility of newer version with zfs"
  echo -e "Please see this bug https://bugs.alpinelinux.org/issues/9046"
  echo "http://dl-cdn.alpinelinux.org/alpine/v3.7/main" >> /etc/apk/repositories
  # echo -e "mariadb<10.1.99\nmariadb-client<10.1.99\nmariadb-common<10.1.99" >> /etc/apk/world
  sed -i "s|^mariadb$|mariadb<10.1.99|g" /etc/apk/world
  sed -i "s|^mariadb-client$|mariadb-client<10.1.99|g" /etc/apk/world
  sed -i "s|^mariadb-common$|mariadb-common<10.1.99|g" /etc/apk/world
  apk update && apk upgrade
fi

mysql_install_db --user=mysql --datadir="/var/lib/mysql"

rc-update add mariadb
service mariadb start

mysql_secure_installation

sed -i "s|max_allowed_packet\s*=\s*1M|max_allowed_packet = 200M|g" /etc/mysql/my.cnf
sed -i "s|max_allowed_packet\s*=\s*16M|max_allowed_packet = 200M|g" /etc/mysql/my.cnf

service mariadb restart

echo -e "mysql installed"

echo -e '
       _
  _ __| |_  _ __
 | `_ \ ` \| `_ \
 | .__/_||_| .__/
 |_|       |_|
'
echo -e "Installing PHP 7.0"
sleep 3
apk add php7 php7-fpm php7-pdo_mysql php7-opcache php7-curl php7-mbstring php7-zip php7-xml php7-gd php7-mcrypt php7-imagick php7-phar php7-json php7-dom php7-tokenizer php7-iconv php7-xmlwriter

# to make php5 availabe
# echo "http://dl-cdn.alpinelinux.org/alpine/v3.7/main" >> /etc/apk/repositories
# apk add php5-fpm php5-pdo_mysql php5-opcache php5-curl php5-zip php5-xml php5-gd php5-mcrypt php5-phar php5-json php5-dom php5-iconv

echo -e "Configuring PHP"

sed -i "s/memory_limit\ =\ 128M/memory_limit = 512M/g" /etc/php7/php.ini

TIMEZONE="Europe/Paris"
sed -i "s|;*date.timezone =.*|date.timezone = ${TIMEZONE}|i" /etc/php7/php.ini

sed -i "s|user = nobody|user = www|i" /etc/php7/php-fpm.d/www.conf
sed -i "s|group = nobody|group = www|i" /etc/php7/php-fpm.d/www.conf

rc-update add php-fpm7
service php-fpm7 start



echo -e "php installed"

echo -e '
       _         __  __        _      _       _
  _ __| |_  _ __|  \/  |_  _  /_\  __| |_ __ (_)_ _
 | `_ \ ` \| `_ \ |\/| | || |/ _ \/ _` | `  \| | ` \
 | .__/_||_| .__/_|  |_|\_, /_/ \_\__,_|_|_|_|_|_||_|
 |_|       |_|          |__/
'
echo -e "Installing phpMyAdmin"
apk add phpmyadmin php7-mysqli
service php-fpm7 restart

chmod +r /etc/phpmyadmin/config.inc.php

# /**
#  * This is needed for cookie based authentication to encrypt password in
#  * cookie. Needs to be 32 chars long.
#  */
_blowfish="$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c32)"
sed -i "s|$cfg['blowfish_secret'] = ''|$cfg['blowfish_secret'] = '${_blowfish}'|i" /etc/phpmyadmin/config.inc.php

mkdir /usr/share/webapps/phpmyadmin/tmp
chmod 777 /usr/share/webapps/phpmyadmin/tmp

echo -e "securing phpMyAdmin"
_pass="$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c8)"
_encrypted=$(openssl passwd -apr1 $_pass)
echo -e "pma:$_encrypted" > /etc/nginx/passwds
# service apache2 restart
echo -e "phpMyAdmin installed"
echo -e "You can access it at yourip/phpmyadmin"
echo -e "please note the credentials user: pma passwd:$_pass"

echo -e '
             _ _
  _ _ ___ __| (_)___
 | `_/ -_) _` | (_-<
 |_| \___\__,_|_/__/
'
echo -e "Installing Redis"
sleep 3
apk add redis php7-pecl-redis

# TODO set maxmemory=2gb
# TODO set maxmemory-policy=volatile-lru
# TODO comment all save line


rc-update add redis
service redis start
service php-fpm7 restart
echo -e "Redis installed"

echo -e '
  __ ___ _ __  _ __  ___ ___ ___ _ _
 / _/ _ \ `  \| `_ \/ _ (_-</ -_) `_|
 \__\___/_|_|_| .__/\___/__/\___|_|
              |_|
'
echo -e "Installing Composer"
sleep 3
export COMPOSER_HOME=/usr/local/composer
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
composer about
echo -e "Composer installed"


echo -e '
     _             _
  __| |_ _ _  _ __| |_
 / _` | `_| || (_-< ` \
 \__,_|_|  \_,_/__/_||_|
'
echo -e "Installing Drush and DrupalConsole"
sleep 3
curl https://drupalconsole.com/installer -L -o /usr/local/bin/drupal
chmod +x /usr/local/bin/drupal
drupal about
curl https://github.com/drush-ops/drush-launcher/releases/download/0.6.0/drush.phar -L -o /usr/local/bin/drush
chmod +x /usr/local/bin/drush

echo -e "Drush and DrupalConsoleinstalled"


echo -e '
            _
  _ _  __ _(_)_ _ __ __
 | ` \/ _` | | ` \\ \ /
 |_||_\__, |_|_||_/_\_\
      |___/
'
echo -e "Installing Nginx"
sleep 3
apk add nginx

adduser -D -g 'www' www
mkdir -p /var/www/html
chown -R www:www /var/lib/nginx
chown -R www:www /var/www/html
chown -R www:www /var/tmp/nginx

mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.ori
cp "$_assets"/lemp/default.nginxconf /etc/nginx/conf.d/default.conf
cp "$_assets"/lemp/index.php /var/www/html/

rc-update add nginx
service nginx start
echo -e "Nginx installed"
