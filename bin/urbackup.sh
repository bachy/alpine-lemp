#!/bin/sh


echo -e '
  _   _     _             _                ___ _    _         _
 | | | |_ _| |__  __ _ __| |___  _ _ __   / __| |  (_)___ _ _| |_
 | |_| |  _|  _ \/ _` / _| / / || |  _ \ | (__| |__| / -_)   \  _|
  \___/|_| |_.__/\__,_\__|_\_\\_,_| .__/  \___|____|_\___|_||_\__|
                                  |_|
'

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

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

# install urbackup client
# https://www.urbackup.org/client_debian_ubuntu_install.html
# https://blog.stephane-huc.net/systeme/debian/urbackup_client_gui
# https://urbackup.atlassian.net/wiki/spaces/US/pages/9142274/Headless+Linux+client+setup

# Install the dependencies UrBackup needs
# apt install build-essential "g++" "libcrypto++-dev" libz-dev -y
apk add linux-headers "g++" zlib zlib-dev "crypto++@testing" "crypto++-dev@testing" make

ln -s /usr/lib/libcryptopp.so /usr/lib/libcryptopp.so.5.6

# Download the UrBackup client source files and extract them
wget -P /tmp/ https://hndl.urbackup.org/Client/latest/urbackup-client-2.3.4.0.tar.gz
cd /tmp
tar xzf /tmp/urbackup-client-2.3.4.0.tar.gz

# Build the UrBackup client and install it
cd /tmp/urbackup-client-2.3.4.0
./configure --enable-headless
make -j4
make install

# Make sure that the UrBackup client backend runs correctly
# urbackupclientbackend -v info

# configure
echo -n "Please provide the urbackup-server's ip : "
read _ip
echo -n "Please provide the internet_authkey of server : "
read _authkey
echo -n "Please provide the computer name of this client : "
read _computername

echo "internet_server=$_ip
internet_server_port=55415
internet_authkey=$_authkey
internet_mode_enabled=true
internet_image_backups_def=false
default_dirs_def=/etc;var/www;/var/backups/mysql
startup_backup_delay_def=3
computername=$_computername" > /usr/local/var/urbackup/data/settings.cfg

# firewall
ufw allow from "$_ip" to any port 35621
ufw allow from "$_ip" to any port 35622
ufw allow from "$_ip" to any port 35623

# install and enable openrc service
cp "$_assets"/urbackup.service /etc/init.d/urbackup
chmod a+x /etc/init.d/urbackup

rc-update add urbackup
service urbackup start

cd "$_cwd"
