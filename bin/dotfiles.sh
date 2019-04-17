#!/bin/sh

echo '
  ___      _   ___ _ _
 |   \ ___| |_| __(_) |___ ___
 | |) / _ \  _| _|| | / -_|_-<
 |___/\___/\__|_| |_|_\___/__/
'
#installing better prompt and some goodies
echo "Installing shell prompt for current user $USER "
sleep 2
#
# # get the current position
# _cwd="$(pwd)"
#
# # check for assets forlder
# _assets="$_cwd/assets"
# if [ ! -d "$_assets" ]; then
#   _assets="$_cwd/../assets"
#   if [ ! -d "$_assets" ]; then
#     echo "!! can't find assets directory !!"
#     exit
#   fi
# fi
#
# cp "$_assets"/dotfiles/.vimrc /home/"$USER"/
# cp -r "$_assets"/dotfiles/.vim /home/"$USER"/
#
# cp "$_assets"/dotfiles/.inputrc /home/"$USER"/


# get the current position
_cwd="$(pwd)"
# go to user home
cd
echo "cloning https://figureslibres.io/gogs/bachir/dotfiles-server.git"
git clone https://figureslibres.io/gogs/bachir/dotfiles-server.git ~/.dotfiles-server && cd ~/.dotfiles-server && ./install.sh && cd ~
source ~/.bashrc
# return to working directory
cd "$_cwd"

echo "Dot files installed for $USER"
