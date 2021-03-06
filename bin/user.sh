#!/bin/sh

echo -e '
  _   _
 | | | |___ ___ _ _
 | |_| (_-</ -_) ._|
  \___//__/\___|_|
'
echo -e "Create new user (you will be asked a user name and a password)"

. bin/checkroot.sh

sleep 3

echo -n "Enter user name: "
read user
while [ "$user" = "" ]
do
  read -p "enter a user name ? " user
  if [ "$user" != "" ]; then
    # check if user already exists
    if id "$user" >/dev/null 2>&1; then
      echo "user $user alreday exists, you must provide a non existing user name."
      user=""
    else
      read -p "is user name $user correcte [y|n] " validated
      if [ "$validated" = "y" ]; then
        break
      else
        user=""
      fi
    fi
  fi
done


# read -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
adduser "$user"

sed -i "s/$user:\/bin\/ash/$user:\/bin\/bash/g" /etc/passwd

# TODO limiting su to the admin group
# echo "adding $user to admin group and limiting su to the admin group"
# groupadd admin
# usermod -a -G admin "$user"
# allow admin group to su
# dpkg-statoverride --update --add root admin 4750 /bin/su

echo -e "user $user configured"
