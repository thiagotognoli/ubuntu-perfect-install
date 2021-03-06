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
 && mount -o "$optionsMount" "$rootDeviceUuid" "$mntDirRootfs"
 && cd "$mntDirRootfs" \
 && btrfs subvolume create @ \
 && btrfs subvolume create @home \
 && echo "Volumes Criados" \
 && find * -maxdepth 0 -not \( -path "@*" -o -path "home" \) -exec cp --reflink -a {} @/. \; \
 && echo "Root Copiado" \
 && cd home \
 && find * -maxdepth 0 -exec cp --reflink -a {} ../@home/. \; \ 
 && echo "Home Copiado" \
 && cd .. \
 && sed -E -i 's@^('"$rootDeviceUuid"')(.*)@#\1\2@' "@/etc/fstab" \
 && sed -E -i '\@^(#'"$rootDeviceUuid"')@a '"$rootDeviceUuid"' / btrfs '"$optionsMount"' 0 0\n'"$rootDeviceUuid"' /home btrfs '"$optionsMount"',subvol=@home 0 0' "@/etc/fstab" \
 && echo "/etc/fstab editado" \ 
 && rootBtrfsVolumeId=$(btrfs subvolume list / | grep -E " path @$" | cut -d " " -f 2) \
 && btrfs subvolume set-default "$rootBtrfsVolumeId" / \
 && echo "Subvolume root setado para ID: $rootBtrfsVolumeId" \ 
 && sync \
 && echo "Finalizando"
 
exit

 







 && mount -t proc /proc @/proc/ \
 && mount --rbind /sys @/sys/ \
 && mount --rbind /dev @/dev/ \
 && mount --rbind /run @/run/ \
 && chroot "$mntDirRootfs"/@ \
 && mkdir -p "$mntDirRootfs"
 && mount -o "$optionsMount" "$rootDeviceUuid" "$mntDirRootfs"
 && cd "$mntDirRootfs" \


cd "$targetDir" \
 && btrfs subvolume snapshot . "$targetDir$targetDirSeparator"@rootfs_tmp \
 && btrfs subvolume create @ \
 && btrfs subvolume create @home \
 && echo "Volumes Criados" \
 && cd "$targetDir$targetDirSeparator@rootfs_tmp" \
 && rsync -vaHAXPxh --numeric-ids --exclude={"@","@home","boot/*","dev/*","proc/*","sys/*","tmp/*","run/*","mnt/*","media/*","lost+found"} -- *  "$targetDir$targetDirSeparator"@/ \
 && echo "Volume root duplicado" \
 && cd "$targetDir$targetDirSeparator@rootfs_tmp/home" \
 && rsync -vaHAXPxh --numeric-ids -- *  "$targetDir$targetDirSeparator"@home/ \
 && echo "Volume home duplicado" \
 && sed -E -i 's@^('"$rootDeviceUuid"')(.*)@#\1\2@' "$targetDir$targetDirSeparator@/etc/fstab" \
 && sed -E -i '\@^(#'"$rootDeviceUuid"')@a '"$rootDeviceUuid"' / btrfs compress=lzo,space_cache,discard 0 0\n'"$rootDeviceUuid"' /home btrfs compress=lzo,space_cache,discard,subvol=@home 0 0' "$targetDir$targetDirSeparator@/etc/fstab" \
 && echo "/etc/fstab editado" \
 && rootBtrfsVolumeId=$(btrfs subvolume list "$targetDir" | grep -E " path @$" | cut -d " " -f 2) \
 && btrfs subvolume set-default "$rootBtrfsVolumeId" / \
 && echo "Subvolume root setado para ID: $rootBtrfsVolumeId" \
 && cd "$targetDir$targetDirSeparator" \
 && find * -maxdepth 0 -not \( -path "@" -o -path "@rootfs_tmp" -o -path "@home" -o -path "run"  -o -path "boot" -o -path "cdrom" \) \
 && exit \
 && btrfs subvolume delete "$targetDir$targetDirSeparator"@rootfs_tmp \
 && find * -maxdepth 0 -not \( -path "@" -o -path "@rootfs_tmp" -o -path "@home" -o -path "run"  -o -path "boot" -o -path "cdrom" \) -exec rm -rf {} \;

 
exit;

 && mkdir -p "$targetDir/snapshots" \
 
sed -E -i 's@^('$rootDeviceUuid')(.*)@#\1\2@' $targetDir/etc/fstab
sed -E -i '\@^(#'$rootDeviceUuid')@a '"$rootDeviceUuid"' / btrfs compress=lzo,space_cache,discard,subvol=@ 0 0\n'"$rootDeviceUuid"' /home btrfs compress=lzo,space_cache,discard,subvol=@home 0 0' $targetDir/etc/fstab


#mkdir /snapshots

mount -o subvol=@ /dev/sdXX /media/temporary

chroot "$targetDir"
update-initramfs -u -k all  
grub-install --recheck /dev/sda
update-grub



#UUID=xxxxx /mnt/btrfs_ssd  btrfs compress=lzo,degraded,noatime,nodiratime,space_cache,ssd,discard     0 0
#sed -E -i '\@^(#'$rootDeviceUuid')@a '"$rootDeviceUuid"' / btrfs compress=lzo,noatime,nodiratime,space_cache,ssd,discard,subvol=@ 0 0\n'"$rootDeviceUuid"' /home btrfs compress=lzo,noatime,nodiratime,space_cache,ssd,discard,subvol=@home 0 0' $targetDir/etc/fstab




#btrfs subvolume create @
#btrfs subvolume create @home

# cd /target && chroot .
btrfs subvolume snapshot /target /target/@
mkdir /target/snapshots
nano /etc/fstab 
zlo -> ZSTD 



umount /target/boot/efi

rsync -vaHAXPxh --numeric-ids --exclude='@' --exclude='@home' .  @ && find * -maxdepth 0 -not \( -path @ -o -path @home \) -exec rm -rf {} \;
umount /target
mount -o compress=lzo,ssd,noatime,nodiratime,space_cache,discard,subvol=@ $rootDevice /target
mount -o compress=lzo,ssd,noatime,nodiratime,space_cache,discard,subvol=@home $rootDevice /target/home
mount $bootDevice /target/boot/efi
mount --bind /proc /target/proc
mount --bind /dev /target/dev
mount --bind /sys /target/sys


# -v = increase verbosity
# -a = archive mode; equals -rlptgoD (no -H,-A,-X)
# -H = preserve hard links
# -A = preserve ACLs (implies -p)
# -X =  preserve extended attributes
# -P = The -P option is equivalent to --partial --progress. Its purpose is to make it much easier to specify these two options for a long transfer that may be interrupted.
# -x, --one-file-system = don't cross filesystem boundaries
# -h = output numbers in a human-readable format
# --numeric-ids = don't map uid/gid values by user/group name
# --exclude='/dev' --exclude='/proc' --exclude='/sys'
# -z compress file data during the transfer - use if backup remote
# backup: rsync -vaHAXPxhz 

#mv -t @ b* d* e* h* i* l* m* o* p* r* s* t* u* v*
#rsync -axvP --remove-source-files sourcedirectory/ targetdirectory
#rsync -zahP /mnt/ /mnt2/
#rsync -avP --numeric-ids --exclude='/dev' --exclude='/proc' --exclude='/sys' root@failedharddrivehost:/ /path/to/destination/

