#!/bin/sh

echo -e "checking root"

if [ "$EUID" -ne 0 ]; then
  echo -e "Please run as root"
  exit
fi
