# Ubuntu Perfect Install
Ubuntu After installation


## Base Installation

```bash
sudo apt install ubuntu-restricted-extras aptitude synaptic flatpak gnome-software-plugin-flatpak
sudo apt install curl
sudo apt install nfs-common

#Alternatives Terminals
sudo apt install terminator
sudo snap install --edge --classic terminology
sudo snap install --classic cool-retro-term

sudo apt install psensors
```

### Gnome

```bash
sudo apt install gnome-tweaks chrome-gnome-shell
#sudo apt install gnome-shell-extensions
```
## install unite 
https://github.com/hardpixel/unite-shell



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
sudo apt install mysql-workbench filezilla
#vscode
sudo snap install --classic code
sudo bash -c "echo "\nfs.inotify.max_user_watches=524288" >> /etc/sysctl.conf" # configuração para repositórios grandes do vscode
#netbeans
sudo snap install --classic netbeans 
#nodejs
sudo snap install --edge node --classic
#robo3t - mongodb gui
sudo snap install robo3t-snap
```

Insomnia REST Client

## Docker - Snap (docker-compose bug)

```bash
sudo apt install docker.io docker-compose -y
```

## Docker - Snap (docker-compose bug)

```bash
sudo addgroup --system docker \
 && sudo adduser $USER docker \
 && newgrp docker \
 && sudo snap install docker \
 && docker run hello-world
```

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
" > ~/.local/share/applications/flameshot-screenshot.desktop
```

## ZSH - Oh My ZSH

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
```


## Refs
* https://github.com/ohmyzsh/ohmyzsh/wiki/themes
* https://github.com/agnoster/agnoster-zsh-theme
* https://github.com/powerline/fonts
* https://github.com/abertsch/Menlo-for-Powerline


https://hyper.is/
