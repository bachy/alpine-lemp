#!/bin/sh

apk add bash bash-doc bash-completion

sed -i 's/root:\/bin\/ash/root:\/bin\/bash/g' /etc/passwd
