#!/bin/sh

echo -e '
  __  __               _   ___          _
 |  \/  |_  _ ___ __ _| | | _ ) __ _ __| |___  _ _ __ ___
 | |\/| | || (_-</ _  | | | _ \/ _  / _| / / || |  _ (_-<
 |_|  |_|\_, /__/\__, |_| |___/\__,_\__|_\_\\_,_| .__/__/
         |__/       |_|                         |_|
'

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

# adding the script
cp "$_assets"/mysqlbackup.sh /usr/local/bin/
chmod +x /usr/local/bin/mysqlbackup.sh

# configure
echo -n "Please provide the mysql root passwd : "
read _root_mysql_passwd
sed -i "s/ROOTPASSWD/$_root_mysql_passwd/g" /usr/local/bin/mysqlbackup.sh

# creating crontab
touch /var/spool/cron/crontabs/root
crontab -l > /tmp/mycron
echo "30 2 */2 * * /usr/local/bin/mysqlbackup.sh" >> /tmp/mycron
crontab /tmp/mycron
rm /tmp/mycron

echo -e "mysql backup script installed"
