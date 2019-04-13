# Install web server and secure it on alpine linux

[ ] Fail2ban
[ ] Ufw
[ ] Proftpd
[ ] Knockd
[ ] Nginx
[ ] Mariadb
[ ] php7.0-fpm
[ ] redis
[ ] vhosts
[ ] git barre repos
[ ] zabbix-agent
[ ] dotfiles and more

## how to use it
on a fresh install
as root

1 install git
```
apk add git
```

2 clone the repo
```
git clone https://figureslibres.io/gogs/bachir/alpine-web-server.git
```

3 run the script as root
```
su
cd alpine-web-server
chmod a+x install.sh
./install.sh

```

## ref
