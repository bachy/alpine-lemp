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

# https://bugs.alpinelinux.org/issues/9046
echo -n "are Maridb databases strored in a zfs file system? [y|n] "
read yn
if [ "$yn" = "Y" ] || [ "$yn" = "y" ]; then
  echo -e "Stick with mariadb 10.1.x due to incompatibility of newer version with zfs"
  echo -e "Please see this bug https://bugs.alpinelinux.org/issues/9046"
  echo "http://dl-5.alpinelinux.org/alpine/v3.7/main" >> /etc/apk/repositories
  echo -e "mariadb<10.1.99\nmariadb-client<10.1.99\nmariadb-common<10.1.99" >> /etc/apk/world
  apk update
fi

apk add mariadb mariadb-client

mysql_install_db --user=mysql --datadir=/var/lib/mysql

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
apk add php7 php7-fpm php7-pdo_mysql php7-opcache php7-curl php7-mbstring php7-zip php7-xml php7-gd php7-mcrypt php7-imagick php7-phar php7-json

echo -e "Configuring PHP"

sed -i "s/memory_limit\ =\ 128M/memory_limit = 512M/g" /etc/php7/php.ini

TIMEZONE="Europe/Helsinki"
sed -i "s|;*date.timezone =.*|date.timezone = ${TIMEZONE}|i" /etc/php7/php.ini

rc-update add php-fpm7
service php-fpm7 start



echo -e "php installed"

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

mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.ori
cp "$_assets"/lemp/default.nginxconf /etc/nginx/conf.d/default.conf
cp "$_assets"/lemp/index.php /var/www/html/

rc-update add nginx
service nginx start
echo -e "Nginx installed"

# echo -e '
#        _         __  __        _      _       _
#   _ __| |_  _ __|  \/  |_  _  /_\  __| |_ __ (_)_ _
#  | `_ \ ` \| `_ \ |\/| | || |/ _ \/ _` | `  \| | ` \
#  | .__/_||_| .__/_|  |_|\_, /_/ \_\__,_|_|_|_|_|_||_|
#  |_|       |_|          |__/
# '
# echo -e "Installing phpMyAdmin"
# apk add phpmyadmin
# ln -s /usr/share/phpmyadmin /var/www/html/
# cp "$_assets"/nginx-phpmyadmin.conf > /etc/nginx/sites-available/phpmyadmin.conf
# ln -s /etc/nginx/sites-available/phpmyadmin.conf /etc/nginx/sites-enabled/phpmyadmin.conf
#
# # echo -e "securing phpMyAdmin"
# # sed -i "s/DirectoryIndex index.php/DirectoryIndex index.php\nAllowOverride all/"
# # cp "$_assets"/phpmyadmin_htaccess > /usr/share/phpmyadmin/.htaccess
# # echo -n "define a user name for phpmyadmin : "
# # read un
# # htpasswd -c /etc/phpmyadmin/.htpasswd $un
# # service apache2 restart
# echo -e "phpMyAdmin installed"
# echo -e "You can access it at yourip/phpmyadmin"

echo -e '
             _ _
  _ _ ___ __| (_)___
 | `_/ -_) _` | (_-<
 |_| \___\__,_|_/__/
'
echo -e "Installing Redis"
sleep 3
apk add redis php7-pecl-redis@edgecommunity

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
curl https://github.com/drush-ops/drush-launcher/releases/download/0.6.0/drush.phar -L -o /usr/local/bin/drush
chmod +x /usr/local/bin/drush
echo -e "Drush and DrupalConsoleinstalled"
