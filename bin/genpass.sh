#!/bin/sh

_pass="$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c16)"
echo "$_pass"
