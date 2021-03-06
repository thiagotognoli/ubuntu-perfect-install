# Ubuntu Perfect Install
Ubuntu After installation



## Automatic Script
```bash
bash -c "$(wget https://raw.githubusercontent.com/thiagotognoli/ubuntu-perfect-install/master/run-remote.sh -O -)"
```

TO-DO: virtual box

<!--

Depois de terminar a intalação antes de reiniciar:

Alt+F2 (abrir o terminal)

```bash

targetDir=/target # if rebooted $targetDir=/
rootDevice=$(mount | grep "$targetDir " | cut -d " " -f 1)
bootDevice=$(mount | grep "$targetDir/boot/efi" | cut -d " " -f 1)
rootDeviceUuid=$(cat "$targetDir/etc/fstab" | grep -E "^.* \/ btrfs" | cut -d " " -f 1)
bootDeviceUuid=$(cat "$targetDir/etc/fstab" | grep -E "^.* \/boot\/efi " | cut -d " " -f 1)

cd "$targetDir" \
 && btrfs subvolume snapshot . "$targetDir/@rootfs_tmp" \
 && btrfs subvolume create @ \
 && btrfs subvolume create @home \
 && rsync -vaHAXPxh --numeric-ids --exclude='@' --exclude='@home' --exclude='@rootfs_tmp' --exclude='home' --exclude='/dev' --exclude='/proc' --exclude='/sys' --exclude='/run' @rootfs_tmp  @ \
 && rsync -vaHAXPxh --numeric-ids @rootfs_tmp/home  @home \
 && btrfs subvolume delete "$targetDir/@rootfs_tmp" \
 && find * -maxdepth 0 -not \( -path @ -o -path @home -path run \) -exec rm -rf {} \; \
 && sed -E -i 's@^('$rootDeviceUuid')(.*)@#\1\2@' "$targetDir/etc/fstab" \
 && sed -E -i '\@^(#'$rootDeviceUuid')@a '"$rootDeviceUuid"' / btrfs compress=lzo,space_cache,discard 0 0\n'"$rootDeviceUuid"' /home btrfs compress=lzo,space_cache,discard,subvol=@home 0 0' "$targetDir/etc/fstab" \
 && rootBtrfsVolumeId=$(btrfs subvolume list "$targetDir" | grep -E " path @$" | cut -d " " -f 2) \
 && btrfs subvolume set-default $rootBtrfsVolumeId /
 


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


```


## Base Installation

```bash
sudo apt install ubuntu-restricted-extras aptitude synaptic flatpak gnome-software-plugin-flatpak
sudo apt install curl
sudo apt install nfs-common

#Alternatives Terminals
sudo apt install terminator
sudo snap install --edge --classic terminology
sudo snap install --classic cool-retro-term

```

## Gnome

```bash
sudo apt install gnome-tweaks chrome-gnome-shell
sudo apt install psensors
#sudo apt install gnome-shell-extensions
```

### Show Desktop Button

```bash
sudo apt-get install xdotool -y
echo -e '[Desktop Entry]\n Version=1.0\n Name=Show Desktop\n Exec=xdotool key --clearmodifiers Ctrl+Super+d\n Icon=desktop\n Type=Application\n Categories=Application' | tee ~/.local/share/applications/show-desktop.desktop
```

### Click App Icon to Minimize

#### Enable
```bash
gsettings set org.gnome.shell.extensions.dash-to-dock click-action minimize
```

#### Restore to Default
```bash
gsettings reset org.gnome.shell.extensions.dash-to-dock click-action
```

### Desktop Folder

```bash
sudo apt-get install desktopfolder -y
```

#### Gnome Extensions
##### Unite
Gnome Extensions:
https://extensions.gnome.org/extension/1287/unite/

Github:
https://github.com/hardpixel/unite-shell

##### Lock Keys
Gnome Extensions:
https://extensions.gnome.org/extension/36/lock-keys/

Github:
https://github.com/kazysmaster/gnome-shell-extension-lockkeys

##### KStatusNotifierItem/AppIndicator Support
Integrates Ubuntu AppIndicators and KStatusNotifierItems (KDE's blessed successor of the systray) into GNOME Shell.

Gnome Extensions:
https://extensions.gnome.org/extension/615/appindicator-support/

Github:
https://github.com/ubuntu/gnome-shell-extension-appindicator

##### Force Quit
Gnome Extensions:
https://extensions.gnome.org/extension/770/force-quit/

Github:
https://github.com/meghprkh/force-quit/

##### Sound Input & Output Device Chooser
Gnome Extensions:
https://extensions.gnome.org/extension/906/sound-output-device-chooser/

Github:
https://github.com/kgshank/gse-sound-output-device-chooser

##### OpenWeather
Gnome Extensions:
https://extensions.gnome.org/extension/750/openweather/

Git:
https://gitlab.com/jenslody/gnome-shell-extension-openweather

##### Suspend Button
Gnome Extensions:
https://extensions.gnome.org/extension/826/suspend-button/

##### User Themes 
Gnome Extensions:
https://extensions.gnome.org/extension/19/user-themes/

##### See
https://gitlab.gnome.org/GNOME/gnome-shell-extensions


### Crypto Folders

```bash
sudo apt install gocryptfs sirikali 
```

### KeepassXC - Password Manager

```bash
sudo snap install keepassxc
```

### Authenticator

```bash
flatpak install -y flathub com.github.bilelmoussaoui.Authenticator
```

### Graphics Tools

```bash
sudo snap install gimp inkscape
```

#### Photography

```bash
sudo snap install darktable
```


### Chromiun Browser

```bash
sudo snap install chromiun
```

### VLC Video Player

```bash
sudo snap install vlc
```

## Chat

```bash
snap install whatsdesk telegram-desktop
snap install --classic slack 
```

### Whatsapp Electron - Alternative Whatsapp Desktop

```bash
sudo apt install git
sudo snap install --edge node --classic
mkdir -p ~/tmp \
 && cd ~/tmp \
 && git clone https://github.com/thiagotognoli/whatsapp-electron.git \
 && cd whatsapp-electron \
 && npm install \
 && npm run build \
 && mkdir -p ~/AppImage \
 && mv dist/whatsapp-electron-*.AppImage ~/AppImage/whatsapp-electron.AppImage \
 && chmod +x ~/AppImage/whatsapp-electron.AppImage \
 && cd .. \
 && rm -rfd whatsapp-electron \
 && echo "[Desktop Entry]
Version=1.0
Type=Application
Exec=~/AppImage/whatsapp-electron.AppImage %f
Name=WhatsApp
Icon=WhatsApp
Terminal=false
Categories=Internet;" > ~/.local/share/applications/whatsapp.desktop
```

## Devel Tools

```bash
#MySql client
sudo apt install mysql-workbench 
#FTP client
sudo apt install filezilla
#netbeans
sudo snap install --classic netbeans 
#nodejs
sudo snap install --edge node --classic
#robo3t - mongodb gui
sudo snap install robo3t-snap
#Git Gui Client
sudo snap install gitkraken
#Insomnia Rest Client
sudo snap install insomnia
#GhostWriter - mkd editor
flatpak install flathub io.github.wereturtle.ghostwriter -y
```

GitAhead - Git Gui Client
https://gitahead.github.io/gitahead.com/

### Docker

#### Last Version (Recomended)

```bash
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update && sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose
```

#### Old Version

```bash
sudo apt install docker.io docker-compose -y
```

#### Snap (only work in $HOME)

```bash
sudo addgroup --system docker \
 && sudo adduser $USER docker \
 && newgrp docker \
 && sudo snap install docker \
 && docker run hello-world
```

### ZSH - Oh My ZSH

```bash
sudo apt-get install zsh fonts-powerline
chsh -s /bin/zsh root
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
rm -rf ~/.zshrc \
 && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc \
 && sed -ri 's/(ZSH_THEME=")([^"]*)(")/\1agnoster\3/g' ~/.zshrc \
 && sed -ri 's/(plugins=\()([^\)]*)(\))/\1git git-extras git-flow gitignore ubuntu cp extract sudo systemd last-working-dir docker docker-compose web-search vscode laravel laravel5 npm yarn\3/g' ~/.zshrc \
 && mkdir -p ~/tmp \
 && cd ~/tmp \
 && git clone https://github.com/abertsch/Menlo-for-Powerline.git \
 && sudo mv Menlo-for-Powerline/*.ttf /usr/share/fonts/.  \
 && rm -rf Menlo-for-Powerline \
 && sudo fc-cache -vf /usr/share/fonts
```

### Visual Studio Code

```bash
#vscode
sudo snap install --classic code
sudo bash -c "echo "\nfs.inotify.max_user_watches=524288" >> /etc/sysctl.conf" # configuração para repositórios grandes do vscode
```
#### https://marketplace.visualstudio.com/items?itemName=humao.rest-client


## Flameshot - Screenshot

```bash
sudo apt install flameshot && echo "[Desktop Entry]
Version=1.1
Type=Application
Name=Flameshot Screenshot
Comment=Uma pequena descrição desta aplicação.
Icon=flameshot
Exec=flameshot gui
Actions=
Categories=Graphics;
" > ~/.local/share/applications/flameshot-screenshot.desktop && chmod +x ~/.local/share/applications/flameshot-screenshot.desktop
```

## TeamViewer

```bash
mkdir -p ~/tmp
 && wget -O ~/tmp/teamviwer.deb https://dl.teamviewer.com/download/linux/version_15x/teamviewer_15.0.8397_amd64.deb
 && sudo dpkg -i ~/tmp/teamviwer.deb
 && rm ~/tmp/teamviwer.deb
```



## Restore from old Instllation (Todo)

```bash
sudo ln -s /media/$USER/857c75eb-7b30-4a28-95be-a0f65d919a01 /media/$USER/hd-old
rsync -avz /media/$USER/hd-old/data/projects /data/
rsync -avz /media/$USER/hd-old/home/$USER/.thunderbird ~/
rsync -avz /media/$USER/hd-old/home/$USER/.ssh ~/
rsync -avz /media/$USER/hd-old/home/$USER/.gnupg ~/
mv ~/.local/share/keyrings ~/.local/share/keyrings.old
cp -r /media/$USER/hd-old/home/$USER/.local/share/keyrings/{login.keyring,user.keystore} ~/.local/share/keyrings
rsync -avz /media/$USER/hd-old/home/$USER/.config/SiriKali ~/.config/
rsync -avz /media/$USER/hd-old/home/$USER/.SiriKali ~/
rsync -avz /media/$USER/hd-old/home/$USER/.wine ~/
rsync -avz /media/$USER/hd-old/home/$USER/Nextcloud* ~/
rsync -avz /media/$USER/hd-old/home/$USER/.config/Nextcloud ~/.config/

mv /home/thiago/snap/netbeans /home/thiago/snap/netbeans.old
rsync -avz /media/$USER/hd-old/home/$USER/snap/netbeans /home/$USER/snap/

rsync -avz /media/$USER/hd-old/home/$USER/.mysql* /home/$USER/
rsync -avz /media/$USER/hd-old/home/$USER/.config/filezilla /home/$USER/.config/

#restore gnome shel extensions with configs
rsync -avz /media/$USER/hd-old/home/$USER/.local/share/gnome-shell/extensions /home/$USER/.local/share/gnome-shell/
```


## Refs
* https://github.com/ohmyzsh/ohmyzsh/wiki/themes
* https://github.com/agnoster/agnoster-zsh-theme
* https://github.com/powerline/fonts
* https://github.com/abertsch/Menlo-for-Powerline

## Select audio in shell
pacmd list-cards
pacmd set-card-profile 1 output:analog-stereo+input:analog-stereo
https://github.com/giner/helplinux/tree/master/scripts/switch-sound
https://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/User/DefaultDevice/



## TkBash
sudo apt install tk && wget https://raw.githubusercontent.com/phil294/tkbash/master/tkbash && chmod +x tkbash
-->
