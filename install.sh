#!/bin/bash

#https://askubuntu.com/questions/16225/how-can-i-accept-the-microsoft-eula-agreement-for-ttf-mscorefonts-installer
#sending incremental file list
#created directory /home/thiago/.SiriKali
#./
#kpc/
#
#sent 92 bytes  received 68 bytes  320.00 bytes/sec
#total size is 0  speedup is 0.00
#mv: não foi possível obter estado de '/home/thiago/snap/netbeans': Arquivo ou diretório inexistente
#rsync: link_stat "/media/thiago/c339c156-38f0-4710-83b6-f02e83243f69/home/thiago/.config/filezilla" failed: No such file or directory (2)
#rsync error: some files/attrs were not transferred (see previous errors) (code 23) at main.c(1207) [sender=3.1.3]
#rsync: link_stat "/media/thiago/c339c156-38f0-4710-83b6-f02e83243f69/home/thiago/Público/*" failed: No such file or directory (2)
#rsync error: some files/attrs were not transferred (see previous errors) (code 23) at main.c(1207) [sender=3.1.3]
#rsync: opendir "/media/thiago/c339c156-38f0-4710-83b6-f02e83243f69/home/thiago/Documentos/antigo/.aptitude" failed: Permission denied (13)
#rsync: opendir "/media/thiago/c339c156-38f0-4710-83b6-f02e83243f69/home/thiago/Documentos/antigo/.cache/dconf" failed: Permission denied (13)
#rsync: opendir "/media/thiago/c339c156-38f0-4710-83b6-f02e83243f69/home/thiago/Documentos/antigo/.cache/doc" failed: Permission denied (13)
#rsync: opendir "/media/thiago/c339c156-38f0-4710-83b6-f02e83243f69/home/thiago/Documentos/antigo/.dbus" failed: Permission denied (13)
#rsync: opendir "/media/thiago/c339c156-38f0-4710-83b6-f02e83243f69/home/thiago/Documentos/antigo/.gvfs" failed: Permission denied (13)
#rsync error: some files/attrs were not transferred (see previous errors) (code 23) at main.c(1207) [sender=3.1.3]
#rsync: link_stat "/media/thiago/c339c156-38f0-4710-83b6-f02e83243f69/home/thiago/Música/*" failed: No such file or directory (2)
#rsync error: some files/attrs were not transferred (see previous errors) (code 23) at main.c(1207) [sender=3.1.3]

#TODO: fontes hackeadas corretamente
#TODO: automatizar tt mscorefonts
#TODO: extensoes shell perguntar de uma vez somente e add as novas indicadas aqui
#TODO: erros de nao existe, do rsync, ver se diretorio origem esta va\io, se tiver nao fazer
#TODO: java - jre - jdk
#TODO: https://github.com/tliron/em-dash e dash to dock
#TODO: adicionar parametros no rsync, igual do script btrfs, ver o user do rsync, esta dando erro em alguns arquivos
#TODO: quebrando instalação de programas, provavelmente pelo fato das novas subjanelas usarem as mesmas variaveis
#TODO: dashtodocker gnomeshellextension
#TODO: snap, com e sem maquina antiga
#TODO: virtualbox
#TODO: criar snapshot zfs, opcional
#TODO: separa aplgumas aplicações, com outra tela perguntando, por exemplo gráfico perguntar gimp e inkscape
#TODO: melhorar e colocar whatsapp
#TODO: fazer app de backup
#TODO: fazer seleção de base o q instar, loja loja com snap loja com flatpack por exemplo
#TODO: validar se home antiga realmente eh home, validar se home antiga tem o arquivo pra restaurar, por exemplo se nao tiver team viewer nao mostrar opcao

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
        install_alternative_terminals \
        install_monitor_tools \
        install_ohmyzsh \
        install_lsd \
        install_mackup \
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
        install_develtools \
        install_docker \
        install_teamviewer \
    )

    options_title=(\
        "Alternative Terminals (terminator, terminology, cool-retro-term)"\
        "Monitor Tools (htop, iotop)"\
        "ZSH & Oh My ZSH"\
        "LSD"\
        "Mackup"\
        "Config Gnome Shell"\
        "Gnome Shell Extensions"\
        "Google Chrome"\
        "Chromium Browser"\
        "Flameshot Screen Shot"\
        "Crypto Folders (gocryptfs, SiriKali)"\
        "KeePassXC"\
        "Authenticator (2FA)"\
        "Design Tools (Inkscape, GIMP)"\
        "Photography Tools (DarkTable)"\
        "VLC Video Player"\
        "Chats (Skype, Teams, WhatsDesk, Telegram Desktop, Slack, Whatsapp Electron, Discord)"\
        "Devel Tools"\
        "Docker"\
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
        TRUE \
        TRUE \
        TRUE \
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
	local _optionsTitles=("${options_title[@]}")
	local _optionsCommands=("${options_id[@]}")
	local _optionsLength=("${optionsLength[@]}")
	
    local IFS="|"
    for app in $1;
    do
        for (( i=0; i<${_optionsLength}; i++ ));
        do
            [[ "${_optionsTitles[$i]}" == "$app" ]] && eval "${_optionsCommands[$i]}"
        done
    done
}

function install_base() {
    sudo apt update

    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
    sudo apt install -y ubuntu-restricted-extras

    sudo apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
    sudo apt install -y aptitude synaptic gnome-software gnome-software-plugin-snap
    sudo apt install -y flatpak gnome-software-plugin-flatpak \
        && flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    sudo apt install -y wget curl rsync git bash dbus perl less mawk sed
    sudo apt install -y nfs-common
}

function install_alternative_terminals_terminator() {
	sudo apt install terminator -y
}
function install_alternative_terminals_terminology() {
	sudo snap install --edge --classic terminology
}
function install_alternative_terminals_coolretroterm() {
	sudo snap install --classic cool-retro-term
}

function install_alternative_terminals() {
    	
   options_id=(\
        install_alternative_terminals_terminator \
        install_alternative_terminals_terminology \
        install_alternative_terminals_coolretroterm \
    )

    options_title=(\
        "Terminator"\
        "Terminology"\
        "Cool Retro Term")

    options_selected=(\
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

function install_monitor_tools() {
    sudo apt install htop iotop -y
}

function install_ohmyzsh() {
    #zenity --question --width=600 --height=400 --text "Instalar ZSH e OhMyZSH?" || return 0
    #&& sudo chsh -s /bin/zsh root \
    sudo apt install zsh fonts-powerline -y \
    	&& sudo -u $currentUser mkdir -p "$currentHomeDir/tmp/zsh" \
	&& cd "$currentHomeDir/tmp/zsh" \
        && sudo -u $currentUser wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O "$currentHomeDir/tmp/zsh/install.sh" \
	&& sudo -u $currentUser sh -c "RUNZSH='no'; sh '$currentHomeDir/tmp/zsh/install.sh' --unattended" \
        && sudo -u $currentUser rm -rf "$currentHomeDir/.zshrc" \
        && sudo -u $currentUser cp "$currentHomeDir/.oh-my-zsh/templates/zshrc.zsh-template" "$currentHomeDir/.zshrc" \
        && sudo -u $currentUser sed -ri 's/(ZSH_THEME=")([^"]*)(")/\1agnoster\3/g' "$currentHomeDir/.zshrc" \
        && sudo -u $currentUser sed -ri 's/(plugins=\()([^\)]*)(\))/\1git git-extras git-flow gitignore ubuntu cp extract sudo systemd last-working-dir docker docker-compose web-search vscode laravel laravel5 npm yarn\3/g' "$currentHomeDir/.zshrc" \
        && git clone https://github.com/abertsch/Menlo-for-Powerline.git \
        && sudo mv Menlo-for-Powerline/*.ttf /usr/share/fonts/.  \
        && rm -rf Menlo-for-Powerline \
	&& sudo rm -rf "$currentHomeDir/tmp"
        && sudo fc-cache -vf /usr/share/fonts
        ##sudo -u $currentUser chsh -s /bin/zsh root \
        
        #https://github.com/romkatv/powerlevel10k
        sudo -u $currentUser git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k \
        	&& sudo -u $currentUser sed -ri 's/(ZSH_THEME=")([^"]*)(")/\1powerlevel10k\/powerlevel10k\3/g' "$currentHomeDir/.zshrc"
        sudo wget -P /usr/share/fonts/. \
            https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Regular.ttf \
            https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Bold.ttf \
            https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Italic.ttf \
            https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Bold%20Italic.ttf
        sudo fc-cache -vf /usr/share/fonts
}

function install_mackup() {
    sudo snap install mackup --classic
}


function install_lsd() {
    sudo -u $currentUser mkdir -p "$currentHomeDir/tmp" \
    && sudo -u $currentUser wget https://github.com/Peltoche/lsd/releases/download/0.16.0/lsd_0.16.0_amd64.deb -O "$currentHomeDir/tmp/lsd.deb" \
    && sudo dpkg -i "$currentHomeDir/tmp/lsd.deb" \
    && sudo -u $currentUser rm -rf "$currentHomeDir/tmp"
    #sudo snap install lsd
}

function config_gnomeshell() {
    #zenity --question --width=600 --height=400 --text "Configurar Gnome Shell?" || return 0

    # Install Gnome Tweaks e Chrome Gnome Shell
    sudo apt install gnome-tweaks chrome-gnome-shell -y
    #sudo apt install gnome-shell-extensions
    sudo apt install font-manager -y

    # Create Show Desktop Button
    sudo apt install xdotool -y \
    && sudo -u $currentUser bash -c "echo -e '[Desktop Entry]\nVersion=1.0\nName=Show Desktop\nExec=xdotool key --clearmodifiers Ctrl+Super+d\nIcon=desktop\nType=Application\nCategories=Application' | tee '$currentHomeDir/.local/share/applications/show-desktop.desktop'" \
    && sudo -u $currentUser chmod +x "$currentHomeDir/.local/share/applications/show-desktop.desktop"

    # Config Click App Icon to Minimize
    sudo -u $currentUser gsettings set org.gnome.shell.extensions.dash-to-dock click-action minimize
    ## Restore to default action
    #sudo -u $currentUser gsettings reset org.gnome.shell.extensions.dash-to-dock click-action
}

function install_gnomeshellextensions() {
    #zenity --question --width=600 --height=400 --text "Instalar Gnome Shell Extensions?" || return 0

    # Install Desktop Folder https://github.com/spheras/desktopfolder
    zenity --question --width=600 --height=400 --text "Instalar Gnome Shell Extensions - Desktop Folder ?" && sudo apt install desktopfolder -y

    # Install psensor https://wpitchoune.net/psensor/
    zenity --question --width=600 --height=400 --text "Instalar Gnome Shell Extensions - PSensor ?" && sudo apt install psensor -y

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
            zenity --question --width=600 --height=400 --text "Instalar Gnome Shell Extensions - ${gnomeExtensions_Name[$i]} ?" && sudo -u $currentUser $binDir/gnome-shell-extension-installer ${gnomeExtensions_Id[$i]}
        done
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
    #sudo snap install keepassxc
    sudo -u $currentUser flatpak install -y flathub org.keepassxc.KeePassXC
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
   options_id=(\
        install_chats_whatsdesk \
        install_chats_telegramdesktop \
        install_chats_skype \
        install_chats_slack \
        install_chats_teams \
        install_chats_whatsappelectron \
        "sudo -u $currentUser flatpak install -y flathub com.discordapp.Discord"\
    )

    options_title=(\
        "WhatsDesk"\
        "Telegram desktop"\
        "Skype"\
        "Slack"\
        "Teams Microsoft"\
        "WhatsApp Electrom"\
        "Discord")

    options_selected=(\
        FALSE \
        TRUE \
        TRUE \
        TRUE \
        TRUE \
        FALSE \
        FALSE)


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

function install_chats_whatsdesk() {
    sudo snap install whatsdesk
}

function install_chats_telegramdesktop() {
    sudo snap install telegram-desktop
}

function install_chats_skype() {
    sudo snap install --classic skype
}

function install_chats_slack() {
    sudo snap install --classic slack
}

function install_chats_teams() {
    teamsDebBaseURL="https://packages.microsoft.com/repos/ms-teams/pool/main/t/teams/";
    teamsLastData=0;
    teamsLastURL="";
    while read line; do
		data=$(sed -r 's/(.*)(<\/a>)(\s*)([^ ]*)(.*)/\4/' <<<  "$line" ); data=$(date -d"$data" +%Y%m%d);
		if (( data > teamsLastData )); then 
			teamsLastURL=$(sed -r 's/(.*)(href\=\")([^\"]*)(.*)/\3/' <<<  "$line" );
			teamsLastData="$data";
		fi;
	done <<< $(wget -qO- "$teamsDebBaseURL" | grep -E '<a href="teams');
    mkdir -p /tmp/teamsmicrosoftinstall \
        && wget -O /tmp/teamsmicrosoftinstall/teams.deb "$teamsDebBaseURL$teamsLastURL" \
        && sudo dpkg -i /tmp/teamsmicrosoftinstall/teams.deb
    sudo apt install -f
    rm -rf /tmp/teamsmicrosoftinstall
}


function install_chats_whatsappelectron() {
    #zenity --question --width=600 --height=400 --text "Instalar WhatsApp Electron?" || return 0
    sudo apt install git -y \
    && sudo snap install --edge node --classic \
    && sudo -u $currentUser mkdir -p "$currentHomeDir/tmp" \
    && cd "$currentHomeDir/tmp" \
    && sudo -u $currentUser bash -c "[ -e '$currentHomeDir/tmp/whatsapp-electron' ] && rm -rf '$currentHomeDir/tmp/whatsapp-electron' || true" \
    && sudo -u $currentUser git clone https://github.com/thiagotognoli/whatsapp-electron.git \
    && cd whatsapp-electron \
    && sudo -u $currentUser npm install \
    && sudo -u $currentUser npm run build \
    && sudo mkdir -p "/opt/AppImage" \
    && sudo mv dist/whatsapp-electron-*.AppImage "/opt/AppImage/whatsapp-electron.AppImage" \
    && sudo chmod a+x "/opt/AppImage/whatsapp-electron.AppImage" \
    && cd .. \
    && sudo -u $currentUser rm -rf "$currentHomeDir/tmp/whatsapp-electron" \
    && sudo mkdir -p /opt/AppImage/icons \
    && sudo wget -O "/opt/AppImage/icons/whatsapp.svg" https://upload.wikimedia.org/wikipedia/commons/6/6b/WhatsApp.svg \
    && sudo wget -O "/opt/AppImage/icons/whatsapp.png" https://github.com/thiagotognoli/whatsapp-electron/blob/master/assets/512x512.png \
    && sudo chmod a+r "/opt/AppImage/icons/whatsapp.svg" \
    && sudo chmod a+r "/opt/AppImage/icons/whatsapp.png" \
    && sudo bash -c "echo -e '[Desktop Entry]\nName=Whatsapp Electron\nExec=/opt/AppImage/whatsapp-electron.AppImage\nTerminal=false\nType=Application\nIcon=/opt/AppImage/icons/whatsapp.png\nStartupWMClass=whatsapp-electron\nX-AppImage-Version=1.1.0\nComment=Unofficial desktop client for WhatsApp Web\nCategories=Network;\n\nTryExec=/opt/AppImage/whatsapp-electron.AppImage\nActions=' | tee '/usr/share/applications/whatsapp.desktop'"
#    && sudo bash -c "echo -e '[Desktop Entry]\nVersion=1.1\nType=Application\nName=WhatsApp\nComment=WhatsApp Web.\nIcon=/opt/AppImage/icons/whatsapp.svg\nExec=/opt/AppImage/whatsapp-electron.AppImage\nActions=\nTerminal=false\nCategories=Network;' | tee '/usr/share/applications/whatsapp.desktop'"
#    && sudo -u $currentUser chmod +x "$currentHomeDir/.local/share/applications/whatsapp.desktop"

}

function install_develtools() {
   options_id=(\
		"install_vscode" \
        "sudo apt install -y mysql-workbench" \
        "sudo apt install -y filezilla" \
        "sudo snap install --classic netbeans" \
        "sudo snap install --edge node --classic" \
        "install_golang" \
        "sudo snap install robo3t-snap" \
        "sudo snap install gitkraken" \
        "sudo snap install insomnia"\
        "sudo -u $currentUser flatpak install -y flathub io.github.wereturtle.ghostwriter"\
    )

    
    options_title=(\
		"Visual Studio Code [snap]"\
        "MySQL Workbench (Mysql GUI Client) [apt]"\
        "Filezilla (FTP GUI Client) [apt]"\
        "Netbeans [snap]"\
        "NodeJS [snap]"\
        "Go Lang [snap]"\
        "Robot3t (MongoDB Gui Client) [snap]"\
        "Git Kraken (Git Gui Client) [snap]"\
        "Insomnia (HTTP Rest Client) [snap]"\
        "GhostWriter (MKD Editor) [flat]"\
    )

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
    )


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

function install_golang() {
	sudo snap install --classic go
    if ! sudo -u $currentUser bash -c "grep -q \"\$HOME/go\" $currentHomeDir/.profile"; then
        sudo -u $currentUser bash -c "echo -e '\n#set GOPATH and GO_BIN\nif [ -d \"\$HOME/go\" ] ; then\n  export GO_PATH=\"\$HOME/go\"\n   # set PATH so it includes user'\''s go bin if it exists\n  if [ -d \"\$GO_PATH/bin\" ] ; then\n     PATH=\"\$GO_PATH/bin:$PATH\"\n   fi\nfi' >> $currentHomeDir/.profile"
    fi
    go get -u github.com/containous/yaegi/cmd/yaegi
}

function install_vscode() {
    #zenity --question --width=600 --height=400 --text "Instalar Visual Studio Code?" || return 0
    #vscode
    sudo snap install --classic code
    sudo bash -c "echo "\nfs.inotify.max_user_watches=524288" >> /etc/sysctl.conf" # configuração para repositórios grandes do vscode
}

function install_flameshotscreenshot() {
    sudo apt install -y flameshot \
    && sudo -u $currentUser bash -c "echo -e '[Desktop Entry]\nVersion=1.1\nType=Application\nName=Flameshot Screenshot\nComment=Screenshot.\nIcon=flameshot\nExec=flameshot gui\nActions=\nCategories=Graphics;' | tee '$currentHomeDir/.local/share/applications/flameshot-screenshot.desktop'" \
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
    oldHome="$(cd "$currentHomeDir" && zenity --file-selection --title="Select a Old Home Directory" --directory)"
    
    

	#TODO:
    ##flat packages
    #echo "----->All Flat Packages with configs"
    #sudo -u $currentUser rsync -az "$oldHome/.var" "$homeDir/"
    ##snap packages
    #echo "----->All Snap Packages configs"
    #sudo -u $currentUser rsync -az "$oldHome/snap" "$homeDir/"

   rsyncCommand="rsync -aHAXPxh --numeric-ids"
   #se for remoto
   #rsync_command="sudo rsync -aHAXPxhz --numeric-ids"

    options_title=();
    options_id=();
    options_selected=();

    if [[ -e  "$oldHome/.bashrc" ]]; then
        options_title+=("Bash config")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.bashrc' '$homeDir/'")
    fi

    if [[ -e  "$oldHome/.profile" ]]; then
        options_title+=("Profile Config")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.profile' '$homeDir/'")
    fi

    if [[ -e  "$oldHome/.zshrc" ]]; then
        options_title+=("Zsh Config")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.zshrc' '$homeDir/'")
    fi

    if [[ -e  "$oldHome/.p10k.zsh" ]]; then
        options_title+=("Power Level 10K Zsh Config")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.p10k.zsh' '$homeDir/'")
    fi

    if [[ -e  "$oldHome/.ssh" ]]; then
        options_title+=("Ssh Config")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.ssh' '$homeDir/'")
    fi

    if [[ -e  "$oldHome/.gitconfig" ]]; then
        options_title+=("Git Config")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.gitconfig' '$homeDir/'")
    fi

    if [[ -e  "$oldHome/.gnupg" ]]; then
        options_title+=("GnuPG")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.gnupg' '$homeDir/'")
    fi

    if [[ -e  "$oldHome/.local/share/keyrings" ]]; then
        options_title+=("Gnome Keyrings")
        options_selected+=(TRUE)
        options_id+=("sudo -u $currentUser mv '$homeDir/.local/share/keyrings' '$homeDir/.local/share/keyrings.old' && sudo -u $currentUser mkdir -p '$homeDir/.local/share/keyrings' && sudo -u $currentUser cp -r '$oldHome/.local/share/keyrings/'{login.keyring,user.keystore} '$homeDir/.local/share/keyrings'")
    fi
    
    if [[ -e  "$oldHome/.mackup.cfg" ]]; then
        options_title+=("Mackup Config")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.mackup.cfg' '$homeDir/'")
    fi

    if [[ -e  "$oldHome/.thunderbird" ]]; then
        options_title+=("Thunderbird Config e E-mails")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.thunderbird' '$homeDir/'")
    fi

    if [[ -e  "$oldHome/.config/SiriKali" ]]; then
        options_title+=("SiriKali Config")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.config/SiriKali' '$homeDir/.config/';")
    fi

    if [[ -e  "$oldHome/.SiriKali" ]]; then
        options_title+=("SiriKali Diretórios")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.SiriKali/' '$homeDir/.SiriKali/' --exclude '*/*' --include '*'")
    fi

    if [[ -e  "$oldHome/.wine" ]]; then
        options_title+=("Wine")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.wine' '$homeDir/'")
    fi

    if [[ -e  "$oldHome/Nextcloud" ]]; then
        options_title+=("Nextcloud Repositórios")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/Nextcloud'* '$homeDir/'")
    fi

    if [[ -e  "$oldHome/.config/Nextcloud" ]]; then
        options_title+=("Nextcloud Config")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.config/Nextcloud' '$homeDir/.config/'")
    fi

    if [[ -e  "$oldHome/.snap/netbeans" ]]; then
        options_title+=("Netbeans Snap Config")
        options_selected+=(TRUE)
        options_id+=("sudo -u $currentUser mv '$homeDir/snap/netbeans' '$homeDir/snap/netbeans.old'; sudo $rsyncCommand '$oldHome/snap/netbeans' '$homeDir/snap/'")
    fi

    if [[ -e  "$oldHome/.mysql" ]]; then
        options_title+=("MySQL Client Config")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.mysql'* '$homeDir/'")
    fi

    if [[ -e  "$oldHome/.config/filezilla" ]]; then
        options_title+=("Filezzila Config")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.config/filezilla' '$homeDir/.config/'")
    fi

    if [[ -e  "$oldHome/.local/share/gnome-shell" ]]; then
        options_title+=("Gnome Shell Extensions e Configs")
        options_selected+=(TRUE)
        options_id+=("sudo -u $currentUser mkdir -p '$homeDir/.local/share/gnome-shell/'; sudo $rsyncCommand '$oldHome/.local/share/gnome-shell/extensions' '$homeDir/.local/share/gnome-shell/'")
    fi

    if [[ -e  "$oldHome/.config/google-chrome" ]]; then
        options_title+=("Google Chrome Dados e Config")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.config/google-chrome' '$homeDir/.config/'")
    fi

    if [[ -e  "$oldHome/.mozilla" ]]; then
        options_title+=("Mozilla Firefox Dados e Config")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.mozilla' '$homeDir/'")
    fi

    if [[ -e  "$oldHome/.config/transmission" ]]; then
        options_title+=("Transmission config")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.config/transmission' '$homeDir/.config/'")
    fi

    if [[ -e  "$oldHome/.config/teamviewer" ]]; then
        options_title+=("Team Viewer config")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.config/teamviewer' '$homeDir/.config/'")
    fi

    if [[ -e  "$oldHome/.config/libreoffice" ]]; then
        options_title+=("Libre Office config")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.config/libreoffice' '$homeDir/.config/'")
    fi

    if [[ -e  "$oldHome/.psensor" ]]; then
        options_title+=("PSensor config")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.psensor' '$homeDir/'")
    fi

    if [[ -e  "$oldHome/.fonts" ]]; then
        options_title+=("Fonts (User)")    
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.fonts' '$homeDir/'")
    fi

    optionsLength=${#options_id[@]}
    optionsToShow=();
    for (( i=0; i<${optionsLength}; i++ ));
    do
        optionsToShow+=(${options_selected[$i]} "${options_title[$i]}")
    done
    appsSelected=$(zenity  --list  --width=800 --height=640 --text "Selecione Configs/Dados para Recuperar" \
        --checklist \
        --column "Marcar" \
        --column "App" \
        "${optionsToShow[@]}")

    callAppsFunctions "$appsSelected"

    #if zenity --question --width=600 --height=400 --text "Recuperar Arquivos da Home Antiga?"
    #then
    
		optionsHomeToShow=();
		optionsHomeTitles=();
		optionsHomeId=();
		
        oldDirectoyPathVars=$(sed -r "s/(#.*)//" "$oldHome/.config/user-dirs.dirs" | sed '/^[[:space:]]*$/d')
        currentDirectoyPathVars=$(sed -r "s/(#.*)//" "$homeDir/.config/user-dirs.dirs" | sed '/^[[:space:]]*$/d')
		SAVEIFS=$IFS   # Save current IFS
		IFS=$'\n'      # Change IFS to new line
		#oldDirectoyPathVars=($oldDirectoyPathVars) # split to array $names
		#currentDirectoyPathVars=($currentDirectoyPathVars) # split to array $names
		currentDirectoyPathVarsArray=($currentDirectoyPathVars) # split to array $names
		IFS=$SAVEIFS   # Restore IFS
        # get length of an array
        currentDirectoyPathVarsLength=${#currentDirectoyPathVarsArray[@]}
        # use for loop to read all values and indexes
        for (( i=0; i<${currentDirectoyPathVarsLength}; i++ ));
        do
			currentVar="$(echo "${currentDirectoyPathVarsArray[$i]}" | sed -r "s/^([^\=]*)(.*)/\1/")"
			
			currentDirectoryPath="$(echo "${currentDirectoyPathVarsArray[$i]}" | sed -r 's/^([^\=]*)(\=)(")([^"]*)(")/\4/')"
			currentDirectoryPath="$(echo "${currentDirectoryPath/\$HOME/$homeDir}")"
			
            oldDirectoyPath="$(echo "$oldDirectoyPathVars" | grep -E "^"$currentVar"\=" | sed -r 's/^([^\=]*)(\=)(")([^"]*)(")/\4/')"
            oldDirectoyPath="$(echo "${oldDirectoyPath/\$HOME/$oldHome}")"
        
			title="Copiar $oldDirectoyPath => $currentDirectoryPath"
			optionsHomeTitles+=("$title")
			optionsHomeToShow+=(TRUE "$title")
			optionsHomeCommand+=("sudo -u $currentUser rsync -az '$oldDirectoyPath/'* '$currentDirectoryPath/'")
        done
		optionsSelected=$(zenity  --list  --width=800 --height=640 --text "Selecione Pastas da Home Antiga para Recuperar" \
			--checklist \
			--column "Marcar" \
			--column "App" \
			"${optionsHomeToShow[@]}")
		optionsHomeLength=${#optionsHomeTitles[@]}
		local IFS="|"
		for commandId in $optionsSelected;
		do
			for (( i=0; i<${optionsHomeLength}; i++ ));
			do
				[[ "${optionsHomeTitles[$i]}" == "$commandId" ]] && eval "${optionsHomeCommand[$i]}"
			done
		done
    #fi
}

function createTemplates() {
    if zenity --question --width=600 --height=400 --text "Criar Templates?"
    then
        currentDirectoyPathVars="$(sed -r "s/(#.*)//" "$currentHomeDir/.config/user-dirs.dirs" | sed '/^[[:space:]]*$/d')"
        currentDirectoryPath="$(echo "$currentDirectoyPathVars" | grep -E "^XDG_TEMPLATES_DIR\=" | sed -r 's/^([^\=]*)(\=)(")([^"]*)(")/\4/')"
        currentDirectoryPath="$(echo "${currentDirectoryPath/\$HOME/$currentHomeDir}")"
        sudo -u $currentUser touch "$currentDirectoryPath/Novo.txt"
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

    snapList=snapList=$(snap list | tail -n +2 | egrep -v '^core |^core18' | grep -v ' stable/… ')
    # |^gtk-common-themes |^gtk2-common-themes |^snapcraft ')
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


#install_whatsappelectron

install_base

installApps

createTemplates

restore_from_old_install

##restoreSnaps

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
