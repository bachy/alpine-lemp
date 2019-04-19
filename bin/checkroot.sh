#!/bin/sh

echo -e "checking root"

if [ "$EUID" = 0 ]; then
  echo -e "root ok"
else
  echo -e "Please run as root"
  exit
fi
