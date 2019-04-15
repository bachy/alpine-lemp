#!/bin/sh

if [ "$EUID" -ne 0 ]; then
  echo -e "Please run as root"
  exit
fi
