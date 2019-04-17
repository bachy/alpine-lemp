#!/bin/sh

echo -e "checking root"

if [ "$EUID" = 0 ]; then
  echo -e "Please run as root"
  exit
else
  echo -e "root ok"
fi
