#!/bin/bash

source "$(sourcePath=`readlink -f "$0"` && cd "${sourcePath%/*}" && pwd)/lib/functions.sh"

checkRoot
setEnvs

source "$basePath/lib/install-commons.sh"

addPreCommand "install_base"

source $basePath/menu_apps.sh
source $basePath/menu_develtools.sh
source $basePath/menu_chats.sh
source $basePath/menu_terminals.sh
source $basePath/menu_gnomeshellextensions_group.sh

menuApps

installAllAfterSelections

createTemplates

source $basePath/backup.sh

restore_home_old
restore_system_old
#restoreSnaps

<</*
#projeto para montar luks antigo
luksPartitions=`lsblk --fs`

while read linePartition
do
    partition=$(echo "$linePartition" | awk "{print \$1}" | tr -d "└─" | tr -d "├─")
    partition_type=$(echo "$linePartition" | awk "{print \$2}")
    partition_uuid=$(echo "$linePartition" | awk "{print \$3}")
#    test -b /dev/disk/by-uuid/$device_uuid && echo "$partition|$partition_type|$partition_uuid is opened" || echo "$partition|$partition_type|$partition_uuid is closed"
done <<< $( \
echo "$luksPartitions" | grep crypto_LUKS; \
echo "$luksPartitions" | grep ext4; \
echo "$luksPartitions" | grep zfs; \
echo "$luksPartitions" | grep xfs; \
echo "$luksPartitions" | grep btrfs; \
echo "$luksPartitions" | grep ntfs; \
echo "$luksPartitions" | grep vfat; \
echo "$luksPartitions" | grep exfat; \
)
/*
