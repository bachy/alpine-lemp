#!/bin/sh

# TODO check if root

echo '\033[35m
   __  ______  __________  ___    ____  ______
  / / / / __ \/ ____/ __ \/   |  / __ \/ ____/
 / / / / /_/ / / __/ /_/ / /| | / / / / __/
/ /_/ / ____/ /_/ / _, _/ ___ |/ /_/ / /___
\____/_/    \____/_/ |_/_/  |_/_____/_____/
\033[0m'

. bin/checkroot.sh

apk update
apk upgrade
