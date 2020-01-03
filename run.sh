#!/bin/bash

# Absolute path to this script, e.g. /home/user/bin/foo.sh
argScript=$(readlink -f "$0")
# Absolute path this script project working is in, thus /home/user
#basePath=$(sed -e "s/\/[^\/]*$//" <<< ${argScript%/*})
basePath="${argScript%/*}"

pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY bash -c "$basePath/install.sh"