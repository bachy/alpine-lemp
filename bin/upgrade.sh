#!/bin/sh

# TODO check if root

echo -e '
  _   _                        _
 | | | |_ __  __ _ _ _ __ _ __| |___
 | |_| | ._ \/ _` | ._/ _. / _. / -_)
  \___/| .__/\__, |_| \__,_\__,_\___|
       |_|   |___/
'

. bin/checkroot.sh

apk update
apk upgrade
