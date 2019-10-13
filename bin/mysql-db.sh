#!/bin/sh

echo -e '
     _ _      _   _
  __| | |__  | | | |___ ___ _ _
 / _` |  _ \ | |_| (_-</ -_)  _|
 \__,_|_.__/  \___//__/\___|_|
'

echo -e "Create new mysql db and user (you will be asked a db name and a password)"

. bin/checkroot.sh

sleep 3

# configure
echo -n "Please provide the mysql root passwd : "
read _root_mysql_passwd

mysql -u root -p $_root_mysql_passwd -e "show databases;"

echo -n "Enter db name: "
read db
while [ "$db" = "" ]
do
  read -p "enter a db name ? " db
  if [ "$db" != "" ]; then
    # TODO check if db already exists
    # if id "$db" >/dev/null 2>&1; then
    #   echo "user $db alreday exists, you must provide a non existing user name."
    #   db=""
    # else
      read -p "is db name $db correcte [y|n] " validated
      if [ "$validated" = "y" ]; then
        break
      else
        db=""
      fi
    # fi
  fi
done

# mysql -u root -p $_root_mysql_passwd
