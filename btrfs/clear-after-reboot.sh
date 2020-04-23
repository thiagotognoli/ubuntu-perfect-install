#!/bin/bash


function checkRoot() {
    if [ "$EUID" -ne 0 ]
        then echo "Please run as root"
        exit
    fi
}

checkRoot


ssd=false
ssdOptionsMount=ssd,discard
optionsMount="compress=lzo,space_cache,noatime,nodiratime"
if [[ "$ssd" = "true" ]]; then  optionsMount="$optionsMount,$ssdOptionsMount"; fi;
#discard => para ssd
#degraded - para raid
#noatime,nodirtime => em tudo ou somente ssd, mas a náo ser que seja necessário
mntDirRootfs="/tmp/rootfs"

targetDir="/" # if not rebooted targetDir="/target"
targetDirSeparator="" # if not rebooted targetDir="/target"
rootDevice=$(mount | grep "$targetDir " | cut -d " " -f 1)
bootDevice=$(mount | grep "$targetDir/boot/efi" | cut -d " " -f 1)
rootDeviceUuid=$(cat "$targetDir/etc/fstab" | grep -E "^.* \/ btrfs" | cut -d " " -f 1)
bootDeviceUuid=$(cat "$targetDir/etc/fstab" | grep -E "^.* \/boot\/efi " | cut -d " " -f 1)
currentBtrfsSubvolumeId=$(btrfs subvolume get-default / | cut -d " " -f 2)


mkdir -p "$mntDirRootfs" \
    && rootBtrfsVolumeId=$(btrfs subvolume list / | grep -E " path @$" | cut -d " " -f 7) \
    && mount -o "$optionsMount,subvolid=$rootBtrfsVolumeId" "$rootDeviceUuid" "$mntDirRootfs" \
    && cd "$mntDirRootfs" \
    && find * -maxdepth 0 -not \( -path "@*" -o -path "boot" \) -exec rm -rf {} \; \ 
    && echo "Arquivos excluídos" \
    && sync \
    && cd / \
    && umount "$mntDirRootfs" \
    && echo "Finalizando"
exit   
