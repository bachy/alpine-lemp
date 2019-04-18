# Install web server and secure it on alpine linux 3.9

## Branches
each alpine linux stable release has it's branch (master is a clone of the last one)
- [3.8](https://figureslibres.io/gogs/bachir/alpine-web-werver/src/3.8)
- [3.9](https://figureslibres.io/gogs/bachir/alpine-web-werver/src/3.9) ([master](https://figureslibres.io/gogs/bachir/alpine-web-werver))

## Features

- [x] upgrade
- [x] bash
- [x] misc
- [x] dotfiles
- [x] user
- [x] secure openssh
- [x] Ufw (may be eventualy replaced by awall ?)
- [x] Fail2ban
- [x] Knockd
- [ ] Mariadb (bug https://bugs.alpinelinux.org/issues/9046)
- [x] php7-fpm (7.2)
- [x] Nginx
- [x] drush
- [x] composer
- [ ] letsencrypt
- [ ] vhosts
- [x] redis
- [x] zabbix-agent (4)
- [x] urbackup-client
- [ ] git barre repos
- [ ] Proftpd

## how to use it
on a fresh install
as root

1 install git
```
apk add git
```

2 clone the repo
```
git clone https://figureslibres.io/gogs/bachir/alpine-web-werver.git
```

3 you have to be root
```
su
```

4 install bash
```
cd alpine-web-server
. bin/bash
```

5 run the full install
```
. install.sh
```

all script in bin/ can be ran seperatly, but from the repos source exclusively
```
. bin/misc.sh
```

## ref
[Alpine Linux wiki](https://wiki.alpinelinux.org)
