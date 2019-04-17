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
apk add mariadb mariadb-client

# https://bugs.alpinelinux.org/issues/9046

DB_DATA_PATH="/var/lib/mysql"
DB_ROOT_PASS="mariadb_root_password"
DB_USER="mariadb_user"
DB_PASS="mariadb_user_password"
MAX_ALLOWED_PACKET="200M"

mysql_install_db --user=mysql --datadir=${DB_DATA_PATH}

rc-update add mariadb
service mariadb start
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
apk add php7 php7-fpm php7-pdo_mysql php7-opcache php7-curl php7-mbstring php7-zip php7-xml php7-gd php7-mcrypt php7-imagick

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
cp "$_assets"/default.nginxconf /etc/nginx/conf.d/default.conf
cp "$_assets"/index.php /var/www/html/

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
    ____           ___
   / __ \___  ____/ (_)____
  / /_/ / _ \/ __  / / ___/
 / _, _/  __/ /_/ / (__  )
/_/ |_|\___/\__,_/_/____/
'
echo -e "Installing Redis"
sleep 3
apk add redis-server php-redis

# TODO set maxmemory=2gb
# TODO set maxmemory-policy=volatile-lru
# TODO comment all save line


systemctl enable redis-server
systemctl restart redis-server
systemctl restart php7.0-fpm
echo -e "Redis installed"

echo -e '
   ______
  / ____/___  ____ ___  ____  ____  ________  _____
 / /   / __ \/ __ `__ \/ __ \/ __ \/ ___/ _ \/ ___/
/ /___/ /_/ / / / / / / /_/ / /_/ (__  )  __/ /
\____/\____/_/ /_/ /_/ .___/\____/____/\___/_/
                    /_/
'
echo -e "Installing Composer"
sleep 3
export COMPOSER_HOME=/usr/local/composer
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

echo -e "Composer installed"


echo -e '
    ____                  __
   / __ \_______  _______/ /_
  / / / / ___/ / / / ___/ __ \
 / /_/ / /  / /_/ (__  ) / / /
/_____/_/   \__,_/____/_/ /_/
'
echo -e "Installing Drush and DrupalConsole"
sleep 3
curl https://drupalconsole.com/installer -L -o /usr/local/bin/drupal
chmod +x /usr/local/bin/drupal
curl https://github.com/drush-ops/drush-launcher/releases/download/0.6.0/drush.phar -L -o /usr/local/bin/drush
chmod +x /usr/local/bin/drush
echo -e "Drush and DrupalConsoleinstalled"



# TODO supervising
# echo -e '
#    __  ___          _ __      __  __  ___          _
#   /  |/  /__  ___  (_) /_   _/_/ /  |/  /_ _____  (_)__
#  / /|_/ / _ \/ _ \/ / __/ _/_/  / /|_/ / // / _ \/ / _ \
# /_/  /_/\___/_//_/_/\__/ /_/   /_/  /_/\_,_/_//_/_/_//_/
#'
# echo -e "Installing Munin"
# sleep 3
# # https://www.howtoforge.com/tutorial/server-monitoring-with-munin-and-monit-on-debian/
# apt-get --yes --force-yes install munin munin-node munin-plugins-extra
# # Configure Munin
# # enable plugins
# ln -s /usr/share/munin/plugins/mysql_ /etc/munin/plugins/mysql_
# ln -s /usr/share/munin/plugins/mysql_bytes /etc/munin/plugins/mysql_bytes
# ln -s /usr/share/munin/plugins/mysql_innodb /etc/munin/plugins/mysql_innodb
# ln -s /usr/share/munin/plugins/mysql_isam_space_ /etc/munin/plugins/mysql_isam_space_
# ln -s /usr/share/munin/plugins/mysql_queries /etc/munin/plugins/mysql_queries
# ln -s /usr/share/munin/plugins/mysql_slowqueries /etc/munin/plugins/mysql_slowqueries
# ln -s /usr/share/munin/plugins/mysql_threads /etc/munin/plugins/mysql_threads
#
# ln -s /usr/share/munin/plugins/apache_accesses /etc/munin/plugins/
# ln -s /usr/share/munin/plugins/apache_processes /etc/munin/plugins/
# ln -s /usr/share/munin/plugins/apache_volume /etc/munin/plugins/
#
# # ln -s /usr/share/munin/plugins/fail2ban /etc/munin/plugins/
#
# # dbdir, htmldir, logdir, rundir, and tmpldir
# sed -i 's/^#dbdir/dbdir/' /etc/munin/munin.conf
# sed -i 's/^#htmldir/htmldir/' /etc/munin/munin.conf
# sed -i 's/^#logdir/logdir/' /etc/munin/munin.conf
# sed -i 's/^#rundir/rundir/' /etc/munin/munin.conf
# sed -i 's/^#tmpldir/tmpldir/' /etc/munin/munin.conf
#
# sed -i "s/^\[localhost.localdomain\]/[${HOSTNAME}]/" /etc/munin/munin.conf
#
# # ln -s /etc/munin/apache24.conf /etc/apache2/conf-enabled/munin.conf
# sed -i 's/Require local/Require all granted\nOptions FollowSymLinks SymLinksIfOwnerMatch/g' /etc/munin/apache24.conf
# htpasswd -c /etc/munin/munin-htpasswd admin
# sed -i 's/Require all granted/AuthUserFile \/etc\/munin\/munin-htpasswd\nAuthName "Munin"\nAuthType Basic\nRequire valid-user/g' /etc/munin/apache24.conf
#
#
# service apache2 restart
# service munin-node restart
# echo -e "Munin installed"
#
# echo -e "Installing Monit"
# sleep 3
# # https://www.howtoforge.com/tutorial/server-monitoring-with-munin-and-monit-on-debian/2/
# apt-get --yes --force-yes install monit
# # TODO setup monit rc
# cat "$_assets"/monitrc > /etc/monit/monitrc
#
# # TODO setup webaccess
# passok=0
# while [ "$passok" = "0" ]
# do
#   echo -n "Write web access password to monit"
#   read passwda
#   echo -n "ReWrite web access password to monit"
#   read passwdb
#   if [ "$passwda" = "$passwdb" ]; then
#     sed -i 's/PASSWD_TO_REPLACE/$passwda/g' /etc/monit/monitrc
#     passok=1
#   else
#     echo -e "pass words don't match, please try again"
#   fi
# done
#
# # TODO setup mail settings
# sed -i "s/server1\.example\.com/$HOSTNAME/g" /etc/monit/monitrc
#
# mkdir /var/www/html/monit
# echo -e "hello" > /var/www/html/monit/token
#
# service monit start
#
# echo -e "Monit installed"


# echo -e '
#     ___                __        __
#    /   |_      _______/ /_____ _/ /_
#   / /| | | /| / / ___/ __/ __ `/ __/
#  / ___ | |/ |/ (__  ) /_/ /_/ / /_
# /_/  |_|__/|__/____/\__/\__,_/\__/
#'
# echo -e "Installing Awstat"
# sleep 3
# apt-get --yes --force-yes install awstats
# # Configure AWStats
# temp=`grep -i sitedomain /etc/awstats/awstats.conf.local | wc -l`
# if [ $temp -lt 1 ]; then
#     echo SiteDomain="$_domain" >> /etc/awstats/awstats.conf.local
# fi
# # Disable Awstats from executing every 10 minutes. Put a hash in front of any line.
# sed -i 's/^[^#]/#&/' /etc/cron.d/awstats
# echo -e "Awstat installed"
