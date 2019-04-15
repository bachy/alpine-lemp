# Install web server and secure it on alpine linux

- [x] upgrade
- [x] adduser
- [x] misc
- [x] Ufw (to be replaced by awall)
- [x] Fail2ban
- [ ] Proftpd
- [ ] Knockd
- [ ] Mariadb
- [ ] php7-fpm
- [ ] Nginx
- [ ] letsencrypt
- [ ] vhosts
- [ ] redis
- [ ] git barre repos
- [ ] zabbix-agent
- [ ] urbackup-client
- [ ] dotfiles and more

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
. install.sh

```
4 all script in bin/ can be ran seperatly, but from the repos source exclusively
```
. bin/misc.sh
```

## ref
