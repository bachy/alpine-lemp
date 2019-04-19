#!/bin/sh


echo -e '
          _    _    _
  _____ _| |__| |__(_)__
 |_ / _` | `_ \ `_ \ / _|
 /__\__,_|_.__/_.__/_\__|
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

echo -n "do you want to limit zabbix-agent to 3.4? [y|n] "
read yn
if [ "$yn" = "Y" ] || [ "$yn" = "y" ]; then
  echo -e "Stick with zabbix-agent 3.4"
  echo "http://dl-cdn.alpinelinux.org/alpine/v3.8/main" >> /etc/apk/repositories
  echo "http://dl-cdn.alpinelinux.org/alpine/v3.8/community" >> /etc/apk/repositories
  # echo -e "zabbix-agent<3.4.99" >> /etc/apk/world
  apk update
  # apk upgrade
  apk add 'zabbix-agent=~3.4'
else
  apk add zabbix-agent
fi


# configure
# echo -n "Please provide the current server's public ip : "
# read _cur_ip
# https://www.cyberciti.biz/faq/how-to-find-out-the-ip-address-assigned-to-eth0-and-display-ip-only/
_cur_ip=$(ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
# echo -n "Please provide the hostname of this agent : "
# read _host_name
_host_name=$HOSTNAME
echo -n "Please provide the zabbix-server's ip : "
read _ip
echo -n "Please provide the mysql root password : "
read _root_mysql_passwd


# configure zabbix agent
sed -i "s#Server=127.0.0.1#Server=$_ip#g" /etc/zabbix/zabbix_agentd.conf
sed -i "s#ServerActive=127.0.0.1#ServerActive=$_ip#g" /etc/zabbix/zabbix_agentd.conf
sed -i "s#Hostname=Zabbix server#Hostname=$_host_name#g" /etc/zabbix/zabbix_agentd.conf

_agent_conf_d="/etc/zabbix/zabbix_agentd.d"
mkdir $_agent_conf_d
sed -i "s|#\ Include=$|Include= $_agent_conf_d|g" /etc/zabbix/zabbix_agentd.conf

# apk
# check for alpine security updates

# MYSQL
# https://serverfault.com/questions/737018/zabbix-user-parameter-mysql-status-setting-home
# create zabbix user home
mkdir /var/lib/zabbix
# generate random password for zabbix mysql user
_passwd="$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c16)"
# add mysql credentials to zabbix home
printf "[client]\n
user=zabbix\n
password=$_passwd" > /var/lib/zabbix/.my.cnf
# create zabbix mysql user
mysql -uroot -p"$_root_mysql_passwd" -e "CREATE USER 'zabbix' IDENTIFIED BY '$_passwd';"
mysql -uroot -p"$_root_mysql_passwd" -e "GRANT USAGE ON *.* TO 'zabbix'@'localhost' IDENTIFIED BY '$_passwd';"
# add zabbix-agent parameter
cp "$_assets"/zabbix/userparameter_mysql.conf "$_agent_conf_d"/

# NGINX
# https://github.com/sfuerte/zbx-nginx
# nginxconf already included in default.nginxconf asset
sed -i "s/# allow CURRENT-SERVER-IP/allow $_cur_ip/g" /etc/nginx/conf.d/default.conf
cp "$_assets"/zabbix/userparameter_nginx.conf "$_agent_conf_d"/
mkdir /etc/zabbix/zabbix_agentd.scripts
cp "$_assets"/zabbix/scripts/nginx-stat.py /etc/zabbix/zabbix_agentd.scripts/
chmod +x /etc/zabbix/zabbix_agentd.scripts/nginx-stat.py

echo -n "This is box is a proxmox CT? [Y|n] "
read yn
yn=${yn:-y}
if [ "$yn" = "Y" ] || [ "$yn" = "y" ]; then
  cp "$_assets"/zabbix/proxmox-ct.conf "$_agent_conf_d"/
fi

# allow comm. port with zabbix-server
ufw allow from "$_ip" to any port 22
ufw allow from "$_ip" to any port 10050
# ufw allow from "$_ip" to any port 10051

rc-update add zabbix-agentd
service zabbix-agentd restart

echo -e "Zabbix-agent installed and configured, please add the host $_host_name in your zabbix-server"
echo -e "And import requested templates in assets/zabbix/templates/"
# echo -e "zabbix user mysql password is $_passwd"
