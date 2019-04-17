#!/bin/sh

echo -e '
  _             _
 | |__  __ _ __| |_
 | `_ \/ _` (_-< ` \
 |_.__/\__,_/__/_||_|
'

apk add bash bash-doc bash-completion

sed -i 's/root:\/bin\/ash/root:\/bin\/bash/g' /etc/passwd

exec bash && . install.sh
