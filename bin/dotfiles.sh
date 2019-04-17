#!/bin/sh

echo '
  ___      _   ___ _ _
 |   \ ___| |_| __(_) |___ ___
 | |) / _ \  _| _|| | / -_|_-<
 |___/\___/\__|_| |_|_\___/__/
'
#installing better prompt and some goodies
echo "Installing dot files for current user"
sleep 2

# get the current position
_cwd="$(pwd)"
# go to user home
cd
echo "cloning https://figureslibres.io/gogs/bachir/dotfiles-server.git"
git clone https://figureslibres.io/gogs/bachir/dotfiles-server.git ~/.dotfiles-server && cd ~/.dotfiles-server && ./install.sh && cd ~
source ~/.bashrc
# return to working directory
cd "$_cwd"

echo "Dot files installed"
