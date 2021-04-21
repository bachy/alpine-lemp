#!/bin/sh
# bachir soussi chiadmi

# get the current position
_cwd="$(pwd)"

echo -e '
       _ _
  __ _(_) |_
 / _` | |  _|
 \__, |_|\__|
 |___/
'
echo -e "Create new git barre repos and deploy script"
echo "Git barre repo will be installed in chosen user home directory"
echo "git prod repos will be installed in app directory of provided domain, the domain have to exists as shortcut in chosen /home/user/www before running this script. Please run first bin/vhost.sh script and say yes to the question create a shortcut !"

. bin/checkroot.sh

while [ "$yn" != "yes" ] && [ "$yn" != "no" ]
do
  echo -n "Should we installl git deployement? [yes|no] "
  read yn
  # yn=${yn:-y}
done
if [ "$yn" = "yes" ]; then

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

  # if $user var does not exists (gitdeploy.sh ran directly) ask for it
  if [ -z ${user+x} ]; then
    while [ "$user" = "" ]
    do
      read -p "enter an existing user name ? " user
      if [ "$user" != "" ]; then
        # check if user already exists
        if id "$user" >/dev/null 2>&1; then
          read -p "is user name $user correcte [y|n] " validated
          if [ "$validated" = "y" ]; then
            break
          else
            user=""
          fi
        else
          echo -e "user $user doesn't exists, you must provide an existing user"
          user=""
        fi
      fi
    done
  fi

  # if $_domain var does not exists (gitdeploy.sh ran directly) ask for it
  if [ -z ${_domain+x} ]; then
    while [ "$_domain" = "" ]
    do
      read -p "enter a domain name ? " _domain
      if [ "$_domain" != "" ]; then
        if [ ! -d /home/"$user"/www/"$_domain" ]; then
          echo "/home/$user/www/$_domain does not exists !"
          # exit
          _domain=""
        else
          read -p "is domain $_domain correcte [y|n] " validated
          if [ "$validated" = "y" ]; then
            break
          else
            _domain=""
          fi
        fi
      fi
    done
  fi

  # ask for simple php conf or drupal conf
  while [ "$_drupal" != "yes" ] && [ "$_drupal" != "no" ]
  do
    echo -n "Is your site is a drupal 8 instance? [yes|no] "
    read _drupal
  done

  echo "seting up bare repositorie to push to"
  mkdir /home/"$user"/git-repos
  mkdir /home/"$user"/git-repos/"$_domain".git
  cd /home/"$user"/git-repos/"$_domain".git
  git init --bare

  echo "creating hooks that will update the site repo"
  cp "$_assets"/gitdeploy/git-post-receive /home/"$user"/git-repos/"$_domain".git/hooks/post-receive
  sed -i -r "s#PRODDIR=\"www\"#PRODDIR=\"/home/$user/www/$_domain\"#g" /home/"$user"/git-repos/"$_domain".git/hooks/post-receive
  chown -R "$user":"$user" /home/"$user"/git-repos
  chmod +x /home/"$user"/git-repos/"$_domain".git/hooks/post-receive

  echo "seting up git repo on site folder"
  rm -rf /home/"$user"/www/"$_domain"/app/*
  cd /home/"$user"/www/"$_domain"/app
  git init
  # link to the bare repo
  git remote add origin /home/"$user"/git-repos/"$_domain".git
  chown -R www:"$user" /home/"$user"/www/"$_domain"/app
  chmod -R g+rw /home/"$user"/www/"$_domain"/app
  git remote -v
  git status

  echo "adding deploy script"
  if [ "$_drupal" = "yes" ]; then
    cp "$_assets"/gitdeploy/deploy-drupal.sh /home/"$user"/www/"$_domain"/deploy.sh
  else
    cp "$_assets"/gitdeploy/deploy-simple.sh /home/"$user"/www/"$_domain"/deploy.sh
  fi
  chown "$user":"$user" /home/"$user"/www/"$_domain"/deploy.sh
  chmod +x /home/"$user"/www/"$_domain"/deploy.sh

  # done
  _cur_ip=$(ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
  echo "git repos for $_domain install succeed"
  echo "your site stay now to /home/$user/www/$_domain/app"
  echo "you can push updates on prod branch through $user@$_cur_ip:git-repos/$_domain.git"
  cd "$_cwd"
else
  echo "Git barre repo creation aborted"
fi
