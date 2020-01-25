#!/bin/bash

#todo snap, com e sem maquina antiga

#backup e restore e com hd antigo, backup home toda ?, criptografar ? comprimir ?
#perguntar o que restaurar , e do home tbm
#grive, sshuttle and sshoot(snap), notepad++ (snap), geany, slimbookbattery, nextcloud, mackup , anbox, gitahead
#? tmux, fetch bash 
# https://github.com/ohmybash/oh-my-bash
# https://github.com/powerline/powerline
#todo GitAhead - Git Gui Client https://gitahead.github.io/gitahead.com/
#todo clip grab
#https://clipgrab.org/
#apt install ffmpeg
##Installing Unite Gnome Shell Extension
##[1287] Obtaining extension info
##ERROR: Use your package manager to update this extension

# snap install sqlitebrowser-casept


#configs .bashrc, .profile, .gitconfig git global user.name, user.email

function checkRoot() {
    if [ "$EUID" -ne 0 ]
        then echo "Please run as root"
        exit
    fi
}

checkRoot

currentUser=`logname`
currentGroup=`id -gn $currentUser`

currentHomeDir="$(sudo -u $currentUser bash -c "echo ~")"

ubuntuRelease=`lsb_release -cs`

currentDate=$(date +%Y-%m-%d_%H-%M-%S.%N)

# Absolute path to this script, e.g. /home/user/bin/foo.sh
argScript=$(readlink -f "$0")
# Absolute path this script project working is in, thus /home/user
#basePath=$(sed -e "s/\/[^\/]*$//" <<< ${argScript%/*})
basePath=${argScript%/*}

binDir="${basePath}/bin"


set -a # export all variables created next
source $basePath/conf.conf
set +a # stop exporting


function installApps() {


    options_id=(\
        install_alternativeterminals \
        install_ohmyzsh \
        config_gnomeshell \
        install_gnomeshellextensions \
        install_googlechrome \
        install_chromiumbrowser \
        install_flameshotscreenshot \
        install_cryptofolders_gocryptfs \
        install_keppasxc \
        install_authenticator \
        install_designtools \
        install_photographytools \
        install_vlcvideoplayer \
        install_chats \
        install_whatsappelectron \
        install_develtools \
        install_docker \
        install_teamviewer)

    options_title=(\
        "Alternative Terminals (terminator, terminology, cool-retro-term)"
        "ZSH & Oh My ZSH" \
        "Config Gnome Shell" \
        "Gnome Shell Extensions" \
        "Google Chrome" \
        "Chromium Browser" \
        "Flameshot Screen Shot" \
        "Crypto Folders (gocryptfs, SiriKali)" \
        "KeePassXC" \
        "Authenticator (2FA)" \
        "Design Tools (Inkscape, GIMP)" \
        "Photography Tools (DarkTable)" \
        "VLC Video Player" \
        "Chats (WhatsDesk, Telegram Desktop, Slack)" \
        "Whatsapp Electron" \
        "Devel Tools" \
        "Docker" \
        "Team Viewer")

    options_selected=(\
        TRUE \
        TRUE \
        TRUE \
        TRUE \
        TRUE \
        TRUE \
        TRUE \
        TRUE \
        TRUE \
        TRUE \
        TRUE \
        TRUE \
        TRUE \
        TRUE \
        FALSE \
        TRUE \
        TRUE \
        TRUE)


    optionsLength=${#options_id[@]}
    optionsToShow=();
    for (( i=0; i<${optionsLength}; i++ ));
    do
        optionsToShow+=(${options_selected[$i]} "${options_title[$i]}")
    done

    appsSelected=$(zenity  --list  --width=800 --height=640 --text "Selecione os APPs para instalar" \
        --checklist \
        --column "Marcar" \
        --column "App" \
        "${optionsToShow[@]}")

    callAppsFunctions "$appsSelected"
}

function callAppsFunctions() {
    local IFS="|"
    for app in $1;
    do
        for (( i=0; i<${optionsLength}; i++ ));
        do
            [[ "${options_title[$i]}" == "$app" ]] && eval "${options_id[$i]}"
        done
    done
}

function install_base() {
    sudo apt update
    sudo apt install -y ubuntu-restricted-extras
    sudo apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
    sudo apt install -y aptitude synaptic
    sudo apt install -y flatpak gnome-software-plugin-flatpak \
        && flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    sudo apt install -y wget curl rsync git bash dbus perl less mawk sed
    sudo apt install -y nfs-common

}

function install_alternativeterminals() {
    sudo apt install terminator -y
    sudo snap install --edge --classic terminology
    sudo snap install --classic cool-retro-term
}

function install_ohmyzsh() {
    #zenity --question --width=600 --height=400 --text "Instalar ZSH e OhMyZSH?" || return 0
    #&& sudo chsh -s /bin/zsh root \
    sudo apt install zsh fonts-powerline -y \
        && sudo -u $currentUser sh -c "RUNZSH='no' $(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)" \
        && sudo -u $currentUser rm -rf "$currentHomeDir/.zshrc" \
        && sudo -u $currentUser cp "$currentHomeDir/.oh-my-zsh/templates/zshrc.zsh-template" "$currentHomeDir/.zshrc" \
        && sudo -u $currentUser sed -ri 's/(ZSH_THEME=")([^"]*)(")/\1agnoster\3/g' "$currentHomeDir/.zshrc" \
        && sudo -u $currentUser sed -ri 's/(plugins=\()([^\)]*)(\))/\1git git-extras git-flow gitignore ubuntu cp extract sudo systemd last-working-dir docker docker-compose web-search vscode laravel laravel5 npm yarn\3/g' "$currentHomeDir/.zshrc" \
        && mkdir -p "$currentHomeDir/tmp" \
        && cd "$currentHomeDir/tmp" \
        && git clone https://github.com/abertsch/Menlo-for-Powerline.git \
        && sudo mv Menlo-for-Powerline/*.ttf /usr/share/fonts/.  \
        && rm -rf Menlo-for-Powerline \
        && sudo fc-cache -vf /usr/share/fonts
        ##sudo -u $currentUser chsh -s /bin/zsh root \
        
        #https://github.com/romkatv/powerlevel10k
        sudo -u $currentUser git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k \
        && sudo -u $currentUser sed -ri 's/(ZSH_THEME=")([^"]*)(")/\1powerlevel10k\/powerlevel10k\3/g' "$currentHomeDir/.zshrc"
        sudo wget wget -P /usr/share/fonts/. \
            https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Regular.ttf \
            https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Bold.ttf \
            https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Italic.ttf \
            https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Bold%20Italic.ttf
        sudo fc-cache -vf /usr/share/fonts
}

function config_gnomeshell() {
    #zenity --question --width=600 --height=400 --text "Configurar Gnome Shell?" || return 0

    # Install Gnome Tweaks e Chrome Gnome Shell
    sudo apt install gnome-tweaks chrome-gnome-shell -y
    #sudo apt install gnome-shell-extensions

    # Create Show Desktop Button
    sudo apt install xdotool -y \
    && sudo -u $currentUser bash -c "echo -e '[Desktop Entry]\n Version=1.0\n Name=Show Desktop\n Exec=xdotool key --clearmodifiers Ctrl+Super+d\n Icon=desktop\n Type=Application\n Categories=Application' | tee '$currentHomeDir/.local/share/applications/show-desktop.desktop'" \
    && sudo -u $currentUser chmod +x "$currentHomeDir/.local/share/applications/show-desktop.desktop"

    # Config Click App Icon to Minimize
    sudo -u $currentUser gsettings set org.gnome.shell.extensions.dash-to-dock click-action minimize
    ## Restore to default action
    #sudo -u $currentUser gsettings reset org.gnome.shell.extensions.dash-to-dock click-action

    # Install Desktop Folder https://github.com/spheras/desktopfolder
    sudo apt install desktopfolder -y

    # Install psensor https://wpitchoune.net/psensor/
    sudo apt install psensor -y
}

function install_gnomeshellextensions() {
    #zenity --question --width=600 --height=400 --text "Instalar Gnome Shell Extensions?" || return 0

    sudo apt install wget bash curl dbus perl git less -y \
    && sudo -u $currentUser mkdir -p $binDir \
    && sudo -u $currentUser rm -rf $binDir/gnome-shell-extension-installer \
    && sudo -u $currentUser wget https://raw.githubusercontent.com/brunelli/gnome-shell-extension-installer/master/gnome-shell-extension-installer -O $binDir/gnome-shell-extension-installer \
    && sudo -u $currentUser chmod +x $binDir/gnome-shell-extension-installer

    if [ $? -eq 0 ]; then
        echo "Installing Extensions"

        # get length of an array
        gnomeExtensionslength=${#gnomeExtensions_Id[@]}
        # use for loop to read all values and indexes
        for (( i=0; i<${gnomeExtensionslength}; i++ ));
        do
            echo "Installing ${gnomeExtensions_Name[$i]} Gnome Shell Extension"
            sudo -u $currentUser $binDir/gnome-shell-extension-installer ${gnomeExtensions_Id[$i]}
        done
        #gnome-shell --replace -d $DISPLAY ##restart gnome-shell and close all programs confirm
        ##DISPLAY=$(w| grep "$USER"| awk "{print \$3}"|grep ":"|head -1)
    else
        echo "Fail to install pre-requisites to Gnome Extensions"
    fi
}

function install_cryptofolders_gocryptfs() {
    #zenity --question --width=600 --height=400 --text "Instalar Crypto Folders (gocryptfs, SiriKali)?" || return 0
    sudo apt install gocryptfs sirikali -y
}

function install_keppasxc() {
    #zenity --question --width=600 --height=400 --text "Instalar KeepasXC?" || return 0
    sudo snap install keepassxc
}

function install_authenticator() {
    #zenity --question --width=600 --height=400 --text "Instalar App Authenticator (2FA)?" || return 0
    sudo -u $currentUser flatpak install -y flathub com.github.bilelmoussaoui.Authenticator
}

function install_designtools() {
    #zenity --question --width=600 --height=400 --text "Instalar Design Tools (Inkscape, GIMP)?" || return 0
    sudo snap install gimp inkscape
}

function install_photographytools() {
    #zenity --question --width=600 --height=400 --text "Instalar Photograpy Tools (DarkTable)?" || return 0
    sudo snap install darktable
}

function install_chromiumbrowser() {
    #zenity --question --width=600 --height=400 --text "Instalar Chromium (Browser)?" || return 0
    sudo snap install chromium
}

function install_vlcvideoplayer() {
    #zenity --question --width=600 --height=400 --text "Instalar VLC (Video Player)?" || return 0
    sudo snap install vlc
}

function install_chats() {
    #zenity --question --width=600 --height=400 --text "Instalar Chats Tools?" || return 0
    sudo snap install whatsdesk telegram-desktop
    sudo snap install --classic slack
}

function install_whatsappelectron() {
    #zenity --question --width=600 --height=400 --text "Instalar WhatsApp Electron?" || return 0
    sudo apt install git -y \
    && sudo snap install --edge node --classic \
    && sudo -u $currentUser mkdir -p "$currentHomeDir/tmp" \
    && sudo -u $currentUser cd "$currentHomeDir/tmp" \
    && sudo -u $currentUser git clone https://github.com/thiagotognoli/whatsapp-electron.git \
    && sudo -u $currentUser cd whatsapp-electron \
    && sudo -u $currentUser npm install \
    && sudo -u $currentUser npm run build \
    && sudo -u $currentUser mkdir -p "$currentHomeDir/AppImage" \
    && sudo -u $currentUser mv dist/whatsapp-electron-*.AppImage "$currentHomeDir/AppImage/whatsapp-electron.AppImage" \
    && sudo -u $currentUser chmod +x "$currentHomeDir/AppImage/whatsapp-electron.AppImage" \
    && sudo -u $currentUser cd .. \
    && sudo -u $currentUser rm -rfd whatsapp-electron \
    && sudo -u $currentUser -bash -c "echo -e '[Desktop Entry]\n Version=1.0\n Type=Application\n Exec=~/AppImage/whatsapp-electron.AppImage %f\n Name=WhatsApp\n Icon=WhatsApp\n Terminal=false\n Categories=Internet;' | tee '$currentHomeDir/.local/share/applications/whatsapp.desktop'" \
    && sudo -u $currentUser chmod +x "$currentHomeDir/.local/share/applications/whatsapp.desktop"
}

function install_develtools() {
    #zenity --question --width=600 --height=400 --text "Instalar Devel Tools?" || return 0

    #MySql client
    zenity --question --width=600 --height=400 --text "Instalar MySQL Workbench (Mysql GUI Client)?" && sudo apt install -y mysql-workbench
    #FTP client
    zenity --question --width=600 --height=400 --text "Instalar Filezilla (FTP GUI Client)?" && sudo apt install -y filezilla
    #netbeans
    zenity --question --width=600 --height=400 --text "Instalar IDE Netbeans?" && sudo snap install --classic netbeans 
    #nodejs
    zenity --question --width=600 --height=400 --text "Instalar NodeJs (snap)?" && sudo snap install --edge node --classic
    #robo3t - mongodb gui
    zenity --question --width=600 --height=400 --text "Instalar Robo3T (MongoDB Gui Client)?" && sudo snap install robo3t-snap
    #Git Gui Client
    zenity --question --width=600 --height=400 --text "Instalar Git Kraken (Git Gui Client)?" && sudo snap install gitkraken
    #Insomnia Rest Client
    zenity --question --width=600 --height=400 --text "Instalar Insomnia (HTTP Rest Client)?" && sudo snap install insomnia
    #GhostWriter - mkd editor
    zenity --question --width=600 --height=400 --text "Instalar GhostWriter (MKD Editor)?" && sudo -u $currentUser flatpak install -y flathub io.github.wereturtle.ghostwriter
    
    zenity --question --width=600 --height=400 --text "Instalar Visual Studio Code?" && install_vscode
}

function install_vscode() {
    #see native instalation some resources not working zsh ??
    #zenity --question --width=600 --height=400 --text "Instalar Visual Studio Code?" || return 0
    #vscode
    sudo snap install --classic code
    sudo bash -c "echo "\nfs.inotify.max_user_watches=524288" >> /etc/sysctl.conf" # configuração para repositórios grandes do vscode
    #https://marketplace.visualstudio.com/items?itemName=humao.rest-client # todo backup etensions from old
}

function install_flameshotscreenshot() {
    #zenity --question --width=600 --height=400 --text "Instalar Flameshot Screen Shot?" || return 0
    sudo apt install -y flameshot \
    && sudo -u $currentUser bash -c "echo -e '[Desktop Entry]\n Version=1.1\n Type=Application\n Name=Flameshot Screenshot\n Comment=Uma pequena descrição desta aplicação.\n Icon=flameshot\n Exec=flameshot gui\n Actions=\n Categories=Graphics;' | tee '$currentHomeDir/.local/share/applications/flameshot-screenshot.desktop'" \
    && sudo -u $currentUser chmod +x "$currentHomeDir/.local/share/applications/flameshot-screenshot.desktop"
}

function install_teamviewer() {
    #zenity --question --width=600 --height=400 --text "Instalar TeamViewer?" || return 0
    mkdir -p /tmp/teamviewerdwl \
        && wget -O /tmp/teamviewerdwl/teamviwer.deb $teamViewerDownloadLastUrl \
        && sudo dpkg -i /tmp/teamviewerdwl/teamviwer.deb
        sudo apt install -f
        rm -rf /tmp/teamviewerdwl
}


function install_docker() {
    #zenity --question --width=600 --height=400 --text "Instalar Docker?" || return 0
    localUbuntuRelease="$ubuntuRelease"
    if [ "$localUbuntuRelease" = "eoan" ]; then
        localUbuntuRelease="disco"
    fi
    sudo apt remove -y docker docker-engine docker.io containerd runc
    sudo apt update && sudo apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - \
    && sudo bash -c "echo -e 'deb [arch=amd64] https://download.docker.com/linux/ubuntu $localUbuntuRelease stable\n# deb-src [arch=amd64] https://download.docker.com/linux/ubuntu $localUbuntuRelease stable' >> /etc/apt/sources.list.d/docker.list" \
    && sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io \
    && sudo adduser $currentUser docker \
    && sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose 

#    && sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $localUbuntuRelease stable" \

    ##Old Version
    #sudo apt install -y docker.io docker-compose 

    ##Snap (only work in $HOME)
    #sudo addgroup --system docker \
    # && sudo adduser $USER docker \
    # && newgrp docker \
    # && sudo snap install docker \
    # && docker run hello-world
}

function install_googlechrome() {
    #zenity --question --width=600 --height=400 --text "Instalar Google Chrome?" || return 0
    mkdir -p /tmp/googlechrome \
        && wget -O /tmp/googlechrome/googlechrome.deb $googleChromeDownloadLastUrl \
        && sudo dpkg -i /tmp/googlechrome/googlechrome.deb
        sudo apt install -f
        rm -rf /tmp/googlechrome

}

function restore_from_old_install() {
    zenity --question --width=600 --height=400 --text "Restaurar de uma instalação antiga?" || return 0
    #sudo apt install -y yad

    homeDir="$currentHomeDir"
    #sudo -u $currentUser mkdir -p "$homeDir"


    #zenity --file-selection --title="Select a Old Home Folder" --directory
    #oldRoot="$(sudo -u $currentUser bash -c 'cd ~ && zenity --file-selection --title="Select a Old Root Directory" --directory')"
    #sudo -u $currentUser rsync -az "$oldRoot/data" "/data"
    oldHome="$(cd "$currentHomeDir" && zenity --file-selection --title="Select a Old Root Directory" --directory)"

    echo "----->ZSH config"
    sudo -u $currentUser rsync -az "$oldHome/.zshrc" "$homeDir/"
    echo "----->Powerline 10K"
    sudo -u $currentUser rsync -az "$oldHome/.p10k.zsh" "$homeDir/"

    echo "----->SSH config"
    sudo -u $currentUser rsync -az "$oldHome/.ssh" "$homeDir/"
    echo "----->GNU PG"
    sudo -u $currentUser rsync -az "$oldHome/.gnupg" "$homeDir/"
    echo "----->Thunderbir config"
    sudo -u $currentUser rsync -az "$oldHome/.thunderbird" "$homeDir/"
    echo "----->Gnome Keyrings"
    sudo -u $currentUser mv "$homeDir/.local/share/keyrings" "$homeDir/.local/share/keyrings.old"
    sudo -u $currentUser mkdir -p "$homeDir/.local/share/keyrings"
    sudo -u $currentUser cp -r "$oldHome/.local/share/keyrings/"{login.keyring,user.keystore} "$homeDir/.local/share/keyrings"
    echo "----->SiriKali config and Repo structure"
    sudo -u $currentUser rsync -az "$oldHome/.config/SiriKali" "$homeDir/.config/"
    sudo -u $currentUser bash -c  'rsync -vazhP "'$oldHome'/.SiriKali/" "'$homeDir'/.SiriKali/" --exclude "*/*" --include "*"'

    echo "----->Wine"
    sudo -u $currentUser rsync -az "$oldHome/.wine" "$homeDir/"

    if zenity --question --width=600 --height=400 --text "Recuperar Repositório NextCloud (caso recuse ele será sincronizado com o servidor, o processo será mais lento mas será feito)?"
    then
        echo "----->NextCloud Repositories"
        sudo -u $currentUser rsync -az "$oldHome/Nextcloud"* "$homeDir/"
    fi

    echo "----->NextCloud config"
    sudo -u $currentUser rsync -az "$oldHome/.config/Nextcloud" "$homeDir/.config/"

    echo "----->Netbeans Snap config"
    sudo -u $currentUser mv "$homeDir/snap/netbeans" "$homeDir/snap/netbeans.old"
    sudo -u $currentUser rsync -az "$oldHome/snap/netbeans" "$homeDir/snap/"

    echo "----->MySQL Client config"
    sudo -u $currentUser rsync -az "$oldHome/.mysql"* "$homeDir/"
    echo "----->Filezzila config"
    sudo -u $currentUser rsync -az "$oldHome/.config/filezilla" "$homeDir/.config/"

    #restore gnome shel extensions with configs
    echo "----->Gnome Shell Extensions"
    sudo -u $currentUser mkdir -p "$homeDir/.local/share/gnome-shell/"
    sudo -u $currentUser rsync -az "$oldHome/.local/share/gnome-shell/extensions" "$homeDir/.local/share/gnome-shell/"

    #backup chrome
    echo "----->Google Chrome config"
    sudo -u $currentUser rsync -az "$oldHome/.config/google-chrome" "$homeDir/.config/"
    #backup chromium
    #backup firfox
    echo "----->Mozilla Firefox config"
    sudo -u $currentUser rsync -az "$oldHome/.mozilla" "$homeDir/"

    echo "----->Transmission config"
    sudo -u $currentUser rsync -az "$oldHome/.config/transmission" "$homeDir/.config/"
    echo "----->Team Viewer config"
    sudo -u $currentUser rsync -az "$oldHome/.config/teamviewer" "$homeDir/.config/"

    #sudo -u $currentUser rsync -az "$oldHome/.config/slimbookbattery" "$homeDir/.config/"
    echo "----->Libre Office config"
    sudo -u $currentUser rsync -az "$oldHome/.config/libreoffice" "$homeDir/.config/"

    #sudo -u $currentUser rsync -az "$oldHome/.config/autostart" "$homeDir/.config/"

    echo "----->PSensor config"
    sudo -u $currentUser rsync -az "$oldHome/.psensor" "$homeDir/"


    echo "----->Fonts (User)"
    sudo -u $currentUser rsync -az "$oldHome/.fonts" "$homeDir/"

    #flat packages
    echo "----->All Flat Packages with configs"
    sudo -u $currentUser rsync -az "$oldHome/.var" "$homeDir/"
    #snap packages
    echo "----->All Snap Packages configs"
    sudo -u $currentUser rsync -az "$oldHome/snap" "$homeDir/"

    if zenity --question --width=600 --height=400 --text "Recuperar Arquivos da Home Antiga?"
    then
        # get length of an array
        homeFilesDirectoriesVariableslength=${#homeFilesDirectoriesVariables[@]}
        oldDirectoyPathVars="$(cat "$oldHome/.config/user-dirs.dirs")"
        currentDirectoyPathVars="$(cat "$homeDir/.config/user-dirs.dirs")"
        # use for loop to read all values and indexes
        for (( i=0; i<${homeFilesDirectoriesVariableslength}; i++ ));
        do
            oldDirectoyPathVar=$(echo "$oldDirectoyPathVars" | grep "${homeFilesDirectoriesVariables[$i]}")
            currentDirectoyPathVar=$(echo "$currentDirectoyPathVars" | grep "${homeFilesDirectoriesVariables[$i]}")
            oldDirectoyPath=$(echo ${oldDirectoyPathVar/${homeFilesDirectoriesVariables[$i]}=/""} | tr -d '"')
            oldDirectoyPath="$(echo "${oldDirectoyPath/\$HOME/$oldHome}")"
            currentDirectoyPath=$(echo ${currentDirectoyPathVar/${homeFilesDirectoriesVariables[$i]}=/""} | tr -d '"')
            currentDirectoyPath="$(echo "${currentDirectoyPath/\$HOME/$homeDir}")"

            if zenity --question --width=600 --height=400 --text "Copiar dados da Pasta \"$oldDirectoyPath\" (Home Antiga) para a pasta \"$currentDirectoyPath\" (Home Atual)?"
            then
                echo "----->Copying of \"$oldDirectoyPath\" to  \"$currentDirectoyPath\"."
                sudo -u $currentUser rsync -az "$oldDirectoyPath/"* "$currentDirectoyPath/"
            fi
        done
    fi
}


function restoreSnaps() {
    #https://forum.snapcraft.io/t/install-snaps-backup-or-export-and-relocation-to-new-pc/11777
    #https://github.com/nextcloud/nextcloud-snap/issues/489
    #https://forums.rocket.chat/t/migrate-snap-to-snap-installations/467
    #https://bugs.launchpad.net/ubuntu/+source/snapd/+bug/1575053
    #https://forum.snapcraft.io/t/how-do-i-move-a-snap-to-a-new-server/3981
    #https://forum.snapcraft.io/t/where-is-a-snap-stored-and-how-can-i-change-that/3194/4
    #https://forum.snapcraft.io/t/where-is-a-snap-stored-and-how-can-i-change-that/3194/3
<</*
    #install options to fill
       --unaliased
              Install the given snap without enabling its automatic aliases

       --name Install the snap file under the given instance name

       --cohort
              Install the snap in the given cohort
/*

    snapList=snapList=$(snap list | tail -n +2 | egrep -v '^core |^core18' | grep -v ' stable/… ')# |^gtk-common-themes |^gtk2-common-themes |^snapcraft ')
    echo "$snapList" \
    | while read -r name version revision channel publisher options ; do

        optionsStr="$(
            for option in ${options//,/ }; do
                if echo "$option" | grep -E -q "classic|jailmode|devmode|dangerous"
                then
                    echo "--$option "
                fi
            done
        )" 
        echo "sudo snap install --$channel $optionsStr --revision $revision $name"
        if echo "$options" | grep -q "disabled"
        then
            echo "sudo snap disable $name"
        fi
    done
    #copy /var/lib/snapd and ~/snap resolve ?
    #montar jaula snap com base na instalaçao antiga
    # /var/lib/snapd/snaps | $HOME/snap
    #listar os snaps
    #listar as info das snaps, pegando o chanell --classic e etc
    #instalar os snaps no novo sistema - desabilitar os desabilitados
    #copiar o diretorio snap antigo ou fazer snapshot
    #pegar os snaps de /var e /home
}

install_base

installApps

restore_from_old_install

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



guiName="gui11"
function tkbash() {
    /bin/bash $binDir/tkbash "$@"
}

function testeGui() {
    sudo apt install bash tk wget -y \
        && mkdir -p $binDir \
        && rm -rf $binDir/tkbash \
        && wget https://raw.githubusercontent.com/phil294/tkbash/master/tkbash -O $binDir/tkbash \
        && chmod +x $binDir/tkbash
            
    tkbash $guiName --theme clam --title "Ubuntu Perfect Install" --icon icon.png --resizable 0 -w 640 -h 480
    tkbash $guiName --tkcommand "wm iconname .w TT"
    tkbash $guiName --tkcommand "wm attributes .w -type normal"
    tkbash $guiName --hotkey Escape --command 'tkbash gui1 --close'
    # elements
    tkbash $guiName label  label1  -x 5   -y 5   -w 130 -h 30  --text "I like bananas."
    tkbash $guiName select select1 -x 5   -y 40  -w 130 -h 30  --text "Me too|I prefer cookies||Apples|???"
    tkbash $guiName button button1 -x 140 -y 5   -w 130 -h 30  --text "Say hello" --command "notify-send hi"
    tkbash $guiName edit   edit1   -x 140 -y 40  -w 115 -h 94  --text "Yorem Lipsum yolo git amet" \
        --scrollbar 1 --background "grey" --foreground "yellow" --style "font:verdana 12"
    #tkbash gui image  image1  -x 275 -y 5   -w 125 -h 127 --image "kitten.png"
    tkbash $guiName radio  radio1  -x 5   -y 140 -w 130 -h 30  --text "Option 0" --group group1
    tkbash $guiName radio  radio2  -x 5   -y 175 -w 130 -h 30  --text "Option 1" --group group1 --selected
    tkbash $guiName radio  radio3  -x 5   -y 210 -w 130 -h 30  --text "Option 2" --group group1 \
        --command 'tkbash gui1 label2 --text "You selected option $(tkbash gui1 get radio1)."'
    tkbash $guiName label  label2  -x 140 -y 175 -w 395 -h 30 --text "?" --fg '#ff5555'
}
/*
