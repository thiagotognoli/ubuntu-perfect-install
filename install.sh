#!/bin/bash

#TODO: quando for linik na home, sem o destino, criar link mesmo inválido trocando a base da url
#TODO: listar home configs de flatpak e snap e deixar escolher qual importar (home/user/.var e home/user/snap)
#TODO: listar home configs  (home/user/.config)
#TODO: listar todas pasta raíz da home, exceto as defaults e já nomeadas e perguntar se deseja importar

#TODO: apt-btrfs instalar lib python, https://github.com/jf647/btrfs-snap , grub-btrfs-snapshot
#	http://snapper.io/, http://snapper.io/faq.html, https://wiki.archlinux.org/index.php/Snapper, https://github.com/Antynea/grub-btrfs
#TODO: rodar mackup
#TODO: fontes hackeadas corretamente
#TODO: automatizar tt mscorefonts
#TODO: extensoes shell perguntar de uma vez somente e add as novas indicadas aqui
#TODO: erros de nao existe, do rsync, ver se diretorio origem esta va\io, se tiver nao fazer
#TODO: https://github.com/tliron/em-dash e dash to dock
#TODO: snap, com e sem maquina antiga
#TODO: virtualbox
#TODO: criar snapshot zfs, opcional
#TODO: whatsapp electgron ou o outro repo
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


apt=()
apt_second=()
snap=()
snapClassic=()
snapEdgeClassic=()
gnomeShellExtension=()

preCommand=()
posAptCommand=()
posCommand=()
preFinishCommand=()



function installAllAfterSelections() {
    installPreCommands
    installApt
    installPosAptCommands
    installAptSecond
    intstallSnap
    installFlatpak
    installPosCommands
    installPreFinishCommand
}


function addApt() {
    apt+=("$1")
}

function addAptSecond() {
    apt_second+=("$1")
}

function addSnap() {
    snap+=("$1")
}

function addSnapClassic() {
    snapClassic+=("$1")
}

function addSnapEdgeClassic() {
    snapEdgeClassic+=("$1")
}


function addPreCommand() {
    preCommand+=("$1")
}

function addPosAptCommand() {
    posAptCommand+=("$1")
}

function addPosCommand() {
    posCommand+=("$1")
}

function addPreFinishCommand() {
    preFinishCommand+=("$1")
}

function addGnomeShellExtension() {
    gnomeShellExtension+=("$1")
}

function addFlatpak() {
    flatpak+=("$1")
}


function installPreCommands() {
    echo "============================="
    echo " Pré Instalação"
    echo "============================="

    for i in "${preCommand[@]}"
    do
        echo "Executando> eval \"$i\""
        eval "$i"
    done    
}

function installApt() {
    echo "============================="
    echo " Instalando APT"
    echo "============================="

    aptToInstall=()

    for line in "${apt[@]}"
    do
        local IF="\ "
        for i in $line # note that $var must NOT be quoted here!
        do
            if [[ $(sudo apt-cache search "^$i$") ]]; then
                aptToInstall+=("$i")
            fi
        done
    done

    echo "Executando> sudo apt install -y -f \"${aptToInstall[@]}\""
    sudo apt install -y -f "${aptToInstall[@]}"
}

function installAptSecond() {
    echo "============================="
    echo " Instalando Segundo Passo APT"
    echo "============================="

    aptToInstall=()

    for line in "${apt_second[@]}"
    do
        local IF="\ "
        for i in $line # note that $var must NOT be quoted here!
        do
            if [[ $(sudo apt-cache search "^$i$") ]]; then
                aptToInstall+=("$i")
            fi
        done
    done

    echo "Executando> sudo apt install -y -f \"${aptToInstall[@]}\""
    sudo apt install -y -f "${aptToInstall[@]}"
}

function intstallSnap() {
    echo "============================="
    echo " Instalando Snaps"
    echo "============================="

    for i in "${snap[@]}"
    do
        echo "Executando> sudo snap install \"$i\""
        sudo snap install "$i"
    done
    for i in "${snapClassic[@]}"
    do
        echo "Executando> sudo snap install --classic \"$i\""
        sudo snap install --classic "$i"
    done
    for i in "${snapEdgeClassic[@]}"
    do
        echo "Executando> sudo snap install --edge --classic \"$i\""
        sudo snap install --edge --classic "$i"
    done
}

function installFlatpak() {
    echo "============================="
    echo " Instalando Flatpaks"
    echo "============================="

    #executar apos o pos, ou add o repo before this after apt
    for i in "${flatpak[@]}"
    do
        echo "Executando> sudo -u $currentUser flatpak install -y \"$i\""
        sudo -u $currentUser flatpak install -y "$i"
    done    
}

function installPosAptCommands() {
    echo "============================="
    echo " Pós APT Instalação"
    echo "============================="

    for i in "${posAptCommand[@]}"
    do
        echo "Executando> eval \"$i\""
        eval "$i"
    done    
}

function installPosCommands() {
    echo "============================="
    echo " Pós Instalação"
    echo "============================="
    for i in "${posCommand[@]}"
    do
        echo "Executando> eval \"$i\""
        eval "$i"
    done    
}

function installPreFinishCommand() {
    echo "============================="
    echo " Pré Finish Instalação"
    echo "============================="
    for i in "${preFinishCommand[@]}"
    do
        echo "Executando> eval \"$i\""
        eval "$i"
    done    
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

function menuApps() {

    options_title=();
    options_id=();
    options_selected=();

    options_title+=("Ubuntu Restricted Extras [apt]")
    options_selected+=(TRUE)
    options_id+=("addPreCommand \"install_ubuntu_restricted_extras\"")

    options_title+=("Alternative Terminals [seleção]")
    options_selected+=(TRUE)
    options_id+=("menu_alternative_terminals")

    options_title+=("LVM 2 [apt]")
    options_selected+=(TRUE)
    options_id+=("addApt \"lvm2\"")

    options_title+=("Aptitude [apt]")
    options_selected+=(TRUE)
    options_id+=("addApt \"aptitude\"")

    options_title+=("Synaptic [apt]")
    options_selected+=(TRUE)
    options_id+=("addApt \"synaptic\"")

    options_title+=("Gnome Software [apt]")
    options_selected+=(TRUE)
    options_id+=("addApt \"gnome-software gnome-software-plugin-snap gnome-software-plugin-flatpak\"")

    options_title+=("NFS Client [apt]")
    options_selected+=(TRUE)
    options_id+=("addApt \"nfs-common\"")

    options_title+=("Monitoramento - htop [apt]")
    options_selected+=(TRUE)
    options_id+=("addApt \"htop\"")

    options_title+=("Monitoramento - iotop [apt]")
    options_selected+=(TRUE)
    options_id+=("addApt \"iotop\"")

    options_title+=("ZSH & Oh My ZSH [apt & git]")
    options_selected+=(TRUE)
    options_id+=("addApt \"zsh fonts-powerline\" && addPosCommand \"pos_install_ohmyzsh\"")

    options_title+=("Mackup [snap]")
    options_selected+=(TRUE)
    options_id+=("addSnapClassic \"mackup\"")

    options_title+=("LSD (ls deluxe) [web deb]")
    options_selected+=(TRUE)
    options_id+=("addPosCommand \"pos_install_lsd\"")

    options_title+=("Config Gnome Shell [apt & bash]")
    options_selected+=(TRUE)
    options_id+=("config_gnomeshell")

    options_title+=("Gnome Shell Extensions [seleção]")
    options_selected+=(TRUE)
    options_id+=("menu_gnomeshellextensions")

    options_title+=("Google Chrome [web deb & apt repo]")
    options_selected+=(TRUE)
    options_id+=("addPosCommand \"install_googlechrome\"")

    options_title+=("Chromium Browser [snap]")
    options_selected+=(TRUE)
    options_id+=("addSnap \"chromium\"")

    options_title+=("Flameshot Screen Shot [apt & app icon]")
    options_selected+=(TRUE)
    options_id+=("addApt \"flameshot\" && addPosCommand \"pos_install_flameshotscreenshot\"")

    options_title+=("Gocryptfs [apt]")
    options_selected+=(TRUE)
    options_id+=("addApt \"gocryptfs\"")

    options_title+=("Nextcloud Client [apt]")
    options_selected+=(TRUE)
    options_id+=("addApt \"nextcloud-desktop\"")

    options_title+=("Sirikali [apt]")
    options_selected+=(TRUE)
    options_id+=("addApt \"sirikali\"")

    options_title+=("KeepasXC [flat]")
    options_selected+=(TRUE)
    options_id+=("addFlatpak \"org.keepassxc.KeePassXC\"")

    options_title+=("Authenticator (2FA) [flat]")
    options_selected+=(TRUE)
    options_id+=("addFlatpak \"com.github.bilelmoussaoui.Authenticator\"")

    options_title+=("Inkscape (Editor de Desenhos Vetorial) [snap]")
    options_selected+=(TRUE)
    options_id+=("addSnap \"inkscape\"")

    options_title+=("GIMP (Editor de Imagens) [snap]")
    options_selected+=(TRUE)
    options_id+=("addSnap \"gimp\"")

    options_title+=("DarkTable (Visualizador de Fotos/Imagens) [snap]")
    options_selected+=(TRUE)
    options_id+=("addSnap \"darktable\"")

    options_title+=("VLC Video Player [snap]")
    options_selected+=(TRUE)
    options_id+=("addSnap \"vlc\"")

    options_title+=("Chats [seleção]")
    options_selected+=(TRUE)
    options_id+=("menu_chats")

    options_title+=("Devel Tools [seleção]")
    options_selected+=(TRUE)
    options_id+=("menu_develtools")

    options_title+=("Team Viewer [web deb & apt repo]")
    options_selected+=(TRUE)
    options_id+=("addPosCommand \"install_teamviewer\"")

    options_title+=("Hotfix Snap (Ubuntu+ZFS bug) [apt]")
    options_selected+=(TRUE)
    options_id+=("addPreCommand \"pre_install_base_hotfixSnap\"")
    
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

	cancelSelection=$?
    if [[ $cancelSelection = 1 ]] ;
	then
		echo "Cancelado!";
		return 0
	fi

    callAppsFunctions "$appsSelected"
}


function install_base() {

    addPreCommand "pre_install_base"

    #addApt "ubuntu-restricted-extras"

    addPreCommand "pre_install_zfs_snapshot"

    #addPreCommand "pre_install_base_hotfixSnap"
    
    addApt "apt-transport-https ca-certificates curl gnupg-agent software-properties-common"

    addApt "flatpak "
    addPosAptCommand "flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo"

    addApt "wget curl rsync git bash dbus perl less mawk sed"

}

function install_ubuntu_restricted_extras() {
    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
    addApt "ubuntu-restricted-extras"
}

function pre_install_base() {
    sudo apt update
    #disable gnome lock # buck freezy computer
    gnomeSessionIdleDelay=$(gsettings get org.gnome.desktop.session idle-delay | cut -d " " -f 2)
    gsettings set org.gnome.desktop.session idle-delay 0

    addPreFinishCommand "sudo apt -y -f install"
    addPreFinishCommand "sudo apt -y upgrade"
    
    addPreFinishCommand "gsettings set org.gnome.desktop.session idle-delay $gnomeSessionIdleDelay"
}

function pre_install_zfs_snapshot() {
    #cria zfs zsys snapshot
    [ -e /usr/libexec/zsys-system-autosnapshot ] && sudo /usr/libexec/zsys-system-autosnapshot snapshot && sudo /usr/libexec/zsys-system-autosnapshot update-menu
    #zfsSnapshotName="upi_pre"
    #[ -e /usr/libexec/zsys-system-autosnapshot ] && sudo zsysctl state save "$zfsSnapshotName" --system --no-update-bootmenu --auto && sudo /usr/libexec/zsys-system-autosnapshot update-menu
    
    #desabilita apt-zfs-snapshot
    [ -e /etc/apt/apt.conf.d/90_zsys_system_autosnapshot ] && sudo mkdir -p /etc/apt/apt.conf.d.upi_tmp/ && sudo rsync --remove-source-files -aHAXxh --devices --specials --numeric-ids /etc/apt/apt.conf.d/90_zsys_system_autosnapshot /etc/apt/apt.conf.d.upi_tmp/90_zsys_system_autosnapshot

    addPreFinishCommand "[ ! -e /etc/apt/apt.conf.d/90_zsys_system_autosnapshot ] && [ -e /etc/apt/apt.conf.d.upi_tmp/90_zsys_system_autosnapshot ] && sudo rsync -aHAXxh --devices --specials --numeric-ids /etc/apt/apt.conf.d.upi_tmp/90_zsys_system_autosnapshot /etc/apt/apt.conf.d/90_zsys_system_autosnapshot; rm -rf /etc/apt/apt.conf.d.upi_tmp"
}

function pre_install_base_hotfixSnap() {
    
    #bug ubuntu zfs
    sudo apt purge -y snapd
    addApt "snapd"
}

function menu_alternative_terminals() {

    options_title=();
    options_id=();
    options_selected=();

    options_title+=("Terminator [apt]")
    options_selected+=(TRUE)
    options_id+=("addApt \"terminator\"")

    options_title+=("Terminology [snap edge classic]")
    options_selected+=(FALSE)
    options_id+=("addSnapEdgeClassic \"terminology\"")

    options_title+=("Cool Retro Term [snap classic]")
    options_selected+=(TRUE)
    options_id+=("addSnapClassic \"cool-retro-term\"")

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

	cancelSelection=$?
    if [[ $cancelSelection = 1 ]] ;
	then
		echo "Cancelado!";
		return 0
	fi

    callAppsFunctions "$appsSelected"
}


function pos_install_flameshotscreenshot() {
    sudo -u $currentUser bash -c "echo -e '[Desktop Entry]\nVersion=1.1\nType=Application\nName=Flameshot Screenshot\nComment=Screenshot.\nIcon=flameshot\nExec=flameshot gui\nActions=\nCategories=Graphics;' | tee '$currentHomeDir/.local/share/applications/flameshot-screenshot.desktop'" \
        && sudo -u $currentUser chmod +x "$currentHomeDir/.local/share/applications/flameshot-screenshot.desktop"
}

function pos_install_ohmyzsh() {

    sudo -u $currentUser mkdir -p "$currentHomeDir/tmp/zsh" \
        && sudo -u $currentUser wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O "$currentHomeDir/tmp/zsh/install.sh" \
	    && sudo -u $currentUser sh -c "RUNZSH='no'; sh '$currentHomeDir/tmp/zsh/install.sh' --unattended" \
        && sudo -u $currentUser rm -rf "$currentHomeDir/.zshrc" \
        && sudo -u $currentUser cp "$currentHomeDir/.oh-my-zsh/templates/zshrc.zsh-template" "$currentHomeDir/.zshrc" \
        && sudo -u $currentUser sed -ri 's/(ZSH_THEME=")([^"]*)(")/\1agnoster\3/g' "$currentHomeDir/.zshrc" \
        && sudo -u $currentUser git clone https://github.com/abertsch/Menlo-for-Powerline.git "$currentHomeDir/tmp/zsh/Menlo-for-Powerline" \
        && sudo mv "$currentHomeDir/tmp/zsh/Menlo-for-Powerline/"*.ttf /usr/share/fonts/.  \
        && cd /tmp \
        && sudo fc-cache -vf /usr/share/fonts
        ##sudo -u $currentUser chsh -s /bin/zsh root \

        #&& sudo -u $currentUser sed -ri 's/(plugins=\()([^\)]*)(\))/\1git git-extras git-flow gitignore ubuntu cp extract sudo systemd last-working-dir docker docker-compose web-search vscode laravel laravel5 npm yarn zsh-syntax-highlighting\3/g' "$currentHomeDir/.zshrc" \

    declare -A plugins;
    local IFS=" "; 
    
    currentPlugins="$(sudo -u $currentUser grep -E "^plugins=(.*)" "$currentHomeDir/.zshrc" | sed -r "s/^(plugins\=\()([^\)]*)(\))/\2/")"
    for plugin in $currentPlugins; do
        plugins["$plugin"]="$plugin";
    done

    plugins["git"]="git"
    plugins["git-extras"]="git-extras"
    plugins["git-flow"]="git-flow"
    plugins["gitignore"]="gitignore"
    plugins["ubuntu"]="ubuntu"
    plugins["cp"]="cp"
    plugins["extract"]="extract"
    plugins["sudo"]="sudo"
    plugins["systemd"]="systemd"
    plugins["last-working-dir"]="last-working-dir"
    plugins["docker"]="docker"
    plugins["docker-compose"]="docker-compose"
    plugins["web-search"]="web-search"
    plugins["vscode"]="vscode"
    plugins["laravel"]="laravel"
    plugins["laravel5"]="laravel5"
    plugins["npm"]="npm"
    plugins["yarn"]="yarn"


    addPreFinishCommand "sudo rm -rf \"$currentHomeDir/tmp\""

    sudo -u $currentUser git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-"$currentHomeDir/.oh-my-zsh/custom"}/plugins/zsh-syntax-highlighting
        && plugins["zsh-syntax-highlighting"]="zsh-syntax-highlighting"

    sudo -u $currentUser git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-"$currentHomeDir/.oh-my-zsh/custom"}/themes/powerlevel10k \
        && sudo -u $currentUser sed -ri 's/(ZSH_THEME=")([^"]*)(")/\1powerlevel10k\/powerlevel10k\3/g' "$currentHomeDir/.zshrc"


    plugins="${plugins[@]}"
    sed -ri "s/^(plugins\=\()([^\)]*)(\))/\1$plugins\3/g" "$currentHomeDir/.zshrc"

    sudo wget -P /usr/share/fonts/. \
        https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Regular.ttf \
        https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Bold.ttf \
        https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Italic.ttf \
        https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Bold%20Italic.ttf

    sudo fc-cache -vf /usr/share/fonts
}

function pos_install_lsd() {
    sudo -u $currentUser mkdir -p "$currentHomeDir/tmp/lsd" \
        && sudo -u $currentUser wget https://github.com/Peltoche/lsd/releases/download/0.16.0/lsd_0.16.0_amd64.deb -O "$currentHomeDir/tmp/lsd/lsd.deb" \
        && sudo dpkg -i "$currentHomeDir/tmp/lsd/lsd.deb"
    addPreFinishCommand "sudo rm -rf \"$currentHomeDir/tmp\""
}

function config_gnomeshell() {

    addApt "gnome-tweaks chrome-gnome-shell"
    addApt "font-manager"
    addApt "xdotool"
    addPosCommand "pos_config_gnomeshell"

}

function pos_config_gnomeshell() {

    sudo -u $currentUser bash -c "echo -e '[Desktop Entry]\nVersion=1.0\nName=Show Desktop\nExec=xdotool key --clearmodifiers Ctrl+Super+d\nIcon=desktop\nType=Application\nCategories=Application' | tee '$currentHomeDir/.local/share/applications/show-desktop.desktop'" \
        && sudo -u $currentUser chmod +x "$currentHomeDir/.local/share/applications/show-desktop.desktop"

    # Config Click App Icon to Minimize
    sudo -u $currentUser gsettings set org.gnome.shell.extensions.dash-to-dock click-action minimize

    ## Restore to default action
    #sudo -u $currentUser gsettings reset org.gnome.shell.extensions.dash-to-dock click-action
}



function menu_gnomeshellextensions() {
    options_title=();
    options_id=();
    options_selected=();

    options_title+=("Desktop Folder")
    options_selected+=(FALSE)
    options_id+=("addApt \"desktopfolder\"")

    options_title+=("PSensor")
    options_selected+=(TRUE)
    options_id+=("addApt \"psensor\"")


    

    # get length of an array
    gnomeExtensionslength=${#gnomeExtensions_Id[@]}
    # use for loop to read all values and indexes
    for (( i=0; i<${gnomeExtensionslength}; i++ ));
    do
        options_title+=("${gnomeExtensions_Name[$i]}")
        options_selected+=(TRUE)
        options_id+=("addGnomeShellExtension \"$i\"")
    done


    optionsLength=${#options_id[@]}
    optionsToShow=();
    for (( i=0; i<${optionsLength}; i++ ));
    do
        optionsToShow+=(${options_selected[$i]} "${options_title[$i]}")
    done

    appsSelected=$(zenity  --list  --width=800 --height=640 --text "Selecione Extensões do Gnome Shell para Isntalar" \
        --checklist \
        --column "Marcar" \
        --column "Extensão Gnome Shell" \
        "${optionsToShow[@]}")

	cancelSelection=$?
    if [[ $cancelSelection = 1 ]] ;
	then
		echo "Cancelado!";
		return 0
	fi

    addApt "wget bash curl dbus perl git less"

    callAppsFunctions "$appsSelected"

    addPosCommand "pos_install_gnomeshellextensions"
}

function pos_install_gnomeshellextensions() {
    cd /
    
     sudo wget https://raw.githubusercontent.com/brunelli/gnome-shell-extension-installer/master/gnome-shell-extension-installer -O "/usr/bin/gnome-shell-extension-installer" \
     	&& sudo chmod a+x "/usr/bin/gnome-shell-extension-installer"
    
    #sudo mkdir -p "$binDir" \
    #    && sudo rm -rf "$binDir/gnome-shell-extension-installer" \
    #    && sudo wget https://raw.githubusercontent.com/brunelli/gnome-shell-extension-installer/master/gnome-shell-extension-installer -O "$binDir/gnome-shell-extension-installer" \
    #    && sudo chmod a+x "$binDir/gnome-shell-extension-installer"

    
    
    if [ $? -eq 0 ]; then
    	echo "Atualizando Extensions"
    	sudo -u $currentUser "/usr/bin/gnome-shell-extension-installer --update --yes"    
	
	
        echo "Installing Extensions"

        # get length of an array
        gnomeShellExtensionsIdlength=${#gnomeShellExtension[@]}
        # use for loop to read all values and indexes
        for (( i=0; i<${gnomeShellExtensionsIdlength}; i++ ));
        do
            gnomeShellExtensionIndex="${gnomeShellExtension[$i]}"
            echo "Installing ${gnomeExtensions_Name[$gnomeShellExtensionIndex]} Gnome Shell Extension"
            sudo -u $currentUser "/usr/bin/gnome-shell-extension-installer" --yes "${gnomeExtensions_Id[$gnomeShellExtensionIndex]}"
        done
    else
        echo "Fail to install pre-requisites to Gnome Extensions"
    fi
}


function menu_chats() {

    options_title=();
    options_id=();
    options_selected=();

    options_title+=("Telegram Desktop [snap]")
    options_selected+=(TRUE)
    options_id+=("addSnap \"telegram-desktop\"")

    options_title+=("Skype [snap classic]")
    options_selected+=(TRUE)
    options_id+=("addSnapClassic \"skype\"")

    options_title+=("Slack [snap classic]")
    options_selected+=(TRUE)
    options_id+=("addSnapClassic \"slack\"")

    options_title+=("Microsoft Teams [web deb]")
    options_selected+=(TRUE)
    options_id+=("addPosCommand \"pos_install_chats_teams\"")

    options_title+=("Discord [flatpak]")
    options_selected+=(TRUE)
    options_id+=("addFlatpak \"com.discordapp.Discord\"")

    options_title+=("WhatsApp Electrom [git]")
    options_selected+=(FALSE)
    options_id+=("addPosCommand \"pos_install_chats_whatsappelectron\"")

    options_title+=("WhatsDesk [snap]")
    options_selected+=(FALSE)
    options_id+=("addSnap \"whatsdesk\"")

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

	cancelSelection=$?
    if [[ $cancelSelection = 1 ]] ;
	then
		echo "Cancelado!";
		return 0
	fi

    callAppsFunctions "$appsSelected"
    
}

function pos_install_chats_teams() {
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
    
    rm -rf /tmp/teamsmicrosoftinstall
}

function pos_install_chats_whatsappelectron() {
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
    && cd /tmp \
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

function menu_develtools() {
    
    options_title=();
    options_id=();
    options_selected=();

    options_title+=("Docker e Docker Compose [apt repo]")
    options_selected+=(TRUE)
    options_id+=("install_docker")

    options_title+=("Java JRE (Open JRE) [apt]")
    options_selected+=(TRUE)
    options_id+=("addApt \"default-jre\"")

    options_title+=("Java JDK (Open JDK) [apt]")
    options_selected+=(TRUE)
    options_id+=("addApt \"default-jdk\"")

    options_title+=("Go Lang & Yaegi [snap classic & go]")
    options_selected+=(TRUE)
    options_id+=("addSnapClassic \"go\" && addPosCommand \"pos_install_golang\"")
    
    options_title+=("NodeJS [snap edge classic]")
    options_selected+=(TRUE)
    options_id+=("addSnapEdgeClassic \"node\"")

    options_title+=("Visual Studio Code [apt repo]")
    options_selected+=(TRUE)
    options_id+=("install_vscode_apt")

    options_title+=("Visual Studio Code [snap classic]")
    options_selected+=(FALSE)
    options_id+=("addSnapClassic \"code\" && addPosCommand \"pos_install_vscode_snap\"")

    options_title+=("Netbeans [snap classic]")
    options_selected+=(TRUE)
    options_id+=("addSnapClassic \"netbeans\"")

    options_title+=("Filezilla (FTP GUI Client) [apt]")
    options_selected+=(TRUE)
    options_id+=("addApt \"filezilla\"")
    
    options_title+=("BaseX [apt]")
    options_selected+=(TRUE)
    options_id+=("addApt \"basex\"")

    options_title+=("MySQL Workbench (Mysql GUI Client) [apt]")
    options_selected+=(TRUE)
    options_id+=("addApt \"mysql-workbench\"")

    options_title+=("Robot3t (MongoDB Gui Client) [snap]")
    options_selected+=(TRUE)
    options_id+=("addSnap \"robo3t-snap\"")

    options_title+=("Git Kraken (Git Gui Client) [snap]")
    options_selected+=(TRUE)
    options_id+=("addSnap \"gitkraken\"")

    options_title+=("Insomnia (HTTP Rest Client) [snap]")
    options_selected+=(TRUE)
    options_id+=("addSnap \"insomnia\"")

    options_title+=("GhostWriter (MKD Editor) [flat]")
    options_selected+=(TRUE)
    options_id+=("addFlatpak \"io.github.wereturtle.ghostwriter\"")

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

	cancelSelection=$?
    if [[ $cancelSelection = 1 ]] ;
	then
		echo "Cancelado!";
		return 0
	fi
    
    callAppsFunctions "$appsSelected"

}

function install_vscode_apt() {
    addApt "curl apt-transport-https"
    addPosAptCommand "pre_install_vscode_apt"
    addAptSecond "code gvfs-bin "
}

function pre_install_vscode_apt() {
    cd /tmp
    # configuração para repositórios grandes do vscode
    sudo bash -c "sed -i -r '/^fs.inotify.max_user_watches\=/d' /etc/sysctl.conf && echo \"fs.inotify.max_user_watches=524288\" >> /etc/sysctl.conf"
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt update
}

function pos_install_vscode_snap() {
    sudo bash -c "echo >> /etc/sysctl.conf echo \"fs.inotify.max_user_watches=524288\" >> /etc/sysctl.conf" # configuração para repositórios grandes do vscode
}

function pos_install_golang() {
    if ! sudo -u $currentUser bash -c "grep -q \"\$HOME/go\" $currentHomeDir/.profile"; then
        sudo -u $currentUser bash -c "echo -e '\n#set GOPATH and GO_BIN\nif [ -d \"\$HOME/go\" ] ; then\n  export GO_PATH=\"\$HOME/go\"\n   # set PATH so it includes user'\''s go bin if it exists\n  if [ -d \"\$GO_PATH/bin\" ] ; then\n     PATH=\"\$GO_PATH/bin:$PATH\"\n   fi\nfi' >> $currentHomeDir/.profile"
    fi
    go get -u github.com/containous/yaegi/cmd/yaegi
}


function install_teamviewer() {
    #zenity --question --width=600 --height=400 --text "Instalar TeamViewer?" || return 0
    mkdir -p /tmp/teamviewerdwl \
        && wget -O /tmp/teamviewerdwl/teamviwer.deb $teamViewerDownloadLastUrl \
        && sudo dpkg -i /tmp/teamviewerdwl/teamviwer.deb
    sudo apt -y -f install
    rm -rf /tmp/teamviewerdwl
}

function install_docker() {
    addApt "apt-transport-https ca-certificates curl gnupg-agent software-properties-common"
    addPosCommand "pos_install_docker"
}


function pos_install_docker() {
    #zenity --question --width=600 --height=400 --text "Instalar Docker?" || return 0
    localUbuntuRelease="$ubuntuRelease"

    sudo apt remove -y docker docker-engine docker.io containerd runc

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - \
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
    rm -rf /tmp/googlechrome
}

function restore_home_old() {
    rsyncCommand="rsync -aHAXxh --devices --specials --numeric-ids"
    
    zenity --question --width=600 --height=400 --text "Restaurar Home de uma instalação antiga?" || return 0

    homeDir="$currentHomeDir"
    oldHome="$(cd "$currentHomeDir" && zenity --file-selection --title="Selecionar diretório Home antigo" --directory)"

    cancelSelection=$?
    if [[ $cancelSelection = 1 ]] ;
    then
	echo "Cancelado!";
	return 0
    fi
	
    
    #rsyncCommand="rsync -aHAXPxh --numeric-ids"
    #se for remoto
    #rsync_command="sudo rsync -aHAXPxhz --numeric-ids"

    restore_home_configs
    restore_home_data
}


function restore_home_configs() {
    #sudo apt install -y yad

    options_title=();
    options_id=();
    options_selected=();



    if [[ -e "$oldHome/.var" || -L "$oldHome/.var" ]]; then
        options_title+=("Flatpak's Apps Configs")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.var' '$homeDir/'")
    fi

    if [[ -e "$oldHome/snap" || -L "$oldHome/snap" ]]; then
        options_title+=("Snap's Apps Configs")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/snap' '$homeDir/'")
    fi

    if [[ -e "$oldHome/basex" || -L "$oldHome/basex" ]]; then
        options_title+=("BaseX Db's")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/basex' '$homeDir/'")
    fi

    if [[ -e "$oldHome/Applications" || -L "$oldHome/Applications" ]]; then
        options_title+=("Applications")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/Applications' '$homeDir/'")
    fi

    if [[ -e "$oldHome/applications" || -L "$oldHome/applications" ]]; then
        options_title+=("applications")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/applications' '$homeDir/'")
    fi
    
    if [[ -e "$oldHome/Apps" || -L "$oldHome/Apps" ]]; then
        options_title+=("Apps")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/Apps' '$homeDir/'")
    fi
    
    if [[ -e "$oldHome/apps" || -L "$oldHome/apps" ]]; then
        options_title+=("apps")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/apps' '$homeDir/'")
    fi
    
    if [[ -e "$oldHome/bin" || -L "$oldHome/bin" ]]; then
        options_title+=("bin")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/bin' '$homeDir/'")
    fi

    if [[ -e "$oldHome/appimage" || -L "$oldHome/appimage" ]]; then
        options_title+=("appimage")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/appimage' '$homeDir/'")
    fi
    
    if [[ -e "$oldHome/AppImage" || -L "$oldHome/AppImage" ]]; then
        options_title+=("AppImage")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/AppImage' '$homeDir/'")
    fi

    if [[ -e "$oldHome/VirtualBox VMs" || -L "$oldHome/VirtualBox VMs" ]]; then
        options_title+=("VirtualBox VM's")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/VirtualBox VMs' '$homeDir/'")
    fi

    if [[ -e "$oldHome/go" || -L "$oldHome/go" ]]; then
        options_title+=("Go")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/go' '$homeDir/'")
    fi

    if [[ -e "$oldHome/.config/Microsoft" || -e "$oldHome/.config/teams" || -L "$oldHome/.config/Microsoft" || -L "$oldHome/.config/teams" ]]; then
        options_title+=("Microsoft's Apps Configs (Teams, ...)")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.config/Microsoft' '$homeDir/.config/'; sudo $rsyncCommand '$oldHome/.config/teams' '$homeDir/.config/'")
    fi

    if [[ -e "$oldHome/.bashrc" || -L "$oldHome/.bashrc" ]]; then
        options_title+=("Bash config")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.bashrc' '$homeDir/'")
    fi

    if [[ -e "$oldHome/.profile" || -L "$oldHome/.profile" ]]; then
        options_title+=("Profile Config")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.profile' '$homeDir/'")
    fi

    if [[ -e "$oldHome/.zshrc" || -L "$oldHome/.zshrc" ]]; then
        options_title+=("Zsh Config")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.zshrc' '$homeDir/'")
    fi

    if [[ -e "$oldHome/.p10k.zsh" || -L "$oldHome/.p10k.zsh" ]]; then
        options_title+=("Power Level 10K Zsh Config")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.p10k.zsh' '$homeDir/'")
    fi

    if [[ -e "$oldHome/.ssh" || -L "$oldHome/.ssh" ]]; then
        options_title+=("Ssh Config")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.ssh' '$homeDir/'")
    fi

    if [[ -e "$oldHome/.gitconfig" || -L "$oldHome/.gitconfig" ]]; then
        options_title+=("Git Config")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.gitconfig' '$homeDir/'")
    fi

    if [[ -e "$oldHome/.gnupg" || -L "$oldHome/.gnupg" ]]; then
        options_title+=("GnuPG")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.gnupg' '$homeDir/'")
    fi

    if [[ -e "$oldHome/.local/share/keyrings" || -L "$oldHome/.local/share/keyrings" ]]; then
        options_title+=("Gnome Keyrings")
        options_selected+=(TRUE)
        options_id+=("sudo -u $currentUser mv '$homeDir/.local/share/keyrings' '$homeDir/.local/share/keyrings.old' && sudo -u $currentUser mkdir -p '$homeDir/.local/share/keyrings' && sudo -u $currentUser cp -r '$oldHome/.local/share/keyrings/'{login.keyring,user.keystore} '$homeDir/.local/share/keyrings'")
    fi
    
    if [[ -e "$oldHome/.mackup.cfg" || -L "$oldHome/.mackup.cfg" ]]; then
        options_title+=("Mackup Config")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.mackup.cfg' '$homeDir/'")
    fi

    if [[ -e "$oldHome/.thunderbird" || -L "$oldHome/.thunderbird" ]]; then
        options_title+=("Thunderbird Config e E-mails")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.thunderbird' '$homeDir/'")
    fi

    if [[ -e "$oldHome/.config/SiriKali" || -L "$oldHome/.config/SiriKali" ]]; then
        options_title+=("SiriKali Config")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.config/SiriKali' '$homeDir/.config/';")
    fi

    if [[ -e "$oldHome/.SiriKali" || -L "$oldHome/.SiriKali" ]]; then
        options_title+=("SiriKali Diretórios")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.SiriKali/' '$homeDir/.SiriKali/' --exclude '*/*' --include '*'")
    fi

    if [[ -e "$oldHome/.wine" || -L "$oldHome/.wine" ]]; then
        options_title+=("Wine")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.wine' '$homeDir/'")
    fi

    if [[ -e "$oldHome/.vscode" || -L "$oldHome/.vscode" ]]; then
        options_title+=("Visual Studio Code Modules [apt]")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.vscode' '$homeDir/'")
    fi

    if [[ -e "$oldHome/Nextcloud" || -L "$oldHome/Nextcloud" ]]; then
        options_title+=("Nextcloud Repositórios")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/Nextcloud'* '$homeDir/'")
    fi

    if [[ -e "$oldHome/.config/Nextcloud" || -L "$oldHome/.config/Nextcloud" ]]; then
        options_title+=("Nextcloud Config")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.config/Nextcloud' '$homeDir/.config/'")
    fi

    if [[ -e "$oldHome/.snap/netbeans" || -L "$oldHome/.snap/netbeans" ]]; then
        options_title+=("Netbeans Snap Config")
        options_selected+=(TRUE)
        options_id+=("sudo -u $currentUser mv '$homeDir/snap/netbeans' '$homeDir/snap/netbeans.old'; sudo $rsyncCommand '$oldHome/snap/netbeans' '$homeDir/snap/'")
    fi

    if [[ -e "$oldHome/.mysql" || -L "$oldHome/.mysql" ]]; then
        options_title+=("MySQL Client Config")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.mysql'* '$homeDir/'")
    fi

    if [[ -e "$oldHome/.config/filezilla" || -L "$oldHome/.config/filezilla" ]]; then
        options_title+=("Filezzila Config")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.config/filezilla' '$homeDir/.config/'")
    fi

    if [[ -e "$oldHome/.local/share/gnome-shell" || -L "$oldHome/.local/share/gnome-shell" ]]; then
        options_title+=("Gnome Shell Extensions e Configs")
        options_selected+=(FALSE)
        options_id+=("sudo -u $currentUser mkdir -p '$homeDir/.local/share/gnome-shell/'; sudo $rsyncCommand '$oldHome/.local/share/gnome-shell/extensions' '$homeDir/.local/share/gnome-shell/'")
    fi

    if [[ -e "$oldHome/.config/google-chrome" || -L "$oldHome/.config/google-chrome" ]]; then
        options_title+=("Google Chrome Dados e Config")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.config/google-chrome' '$homeDir/.config/'")
    fi

    if [[ -e "$oldHome/.mozilla" || -L "$oldHome/.mozilla" ]]; then
        options_title+=("Mozilla Firefox Dados e Config")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.mozilla' '$homeDir/'")
    fi

    if [[ -e "$oldHome/.config/transmission" || -L "$oldHome/.config/transmission" ]]; then
        options_title+=("Transmission config")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.config/transmission' '$homeDir/.config/'")
    fi

    if [[ -e "$oldHome/.config/teamviewer" || -L "$oldHome/.config/teamviewer" ]]; then
        options_title+=("Team Viewer config")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.config/teamviewer' '$homeDir/.config/'")
    fi

    if [[ -e "$oldHome/.config/libreoffice" || -L "$oldHome/.config/libreoffice" ]]; then
        options_title+=("Libre Office config")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.config/libreoffice' '$homeDir/.config/'")
    fi

    if [[ -e "$oldHome/.psensor" || -L "$oldHome/.psensor" ]]; then
        options_title+=("PSensor config")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.psensor' '$homeDir/'")
    fi

    if [[ -e "$oldHome/.fonts" || -L "$oldHome/.fonts" ]]; then
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
    optionsSelected=$(zenity  --list  --width=800 --height=640 --text "Selecione Configs/Dados para Recuperar" \
        --checklist \
        --column "Marcar" \
        --column "App" \
        "${optionsToShow[@]}")

	cancelSelection=$?
    	if [[ $cancelSelection = 1 ]] ;
	then
		echo "Cancelado!";
		return 0
	fi
	

	echo "============================="
 	echo " Restaurando Configs da Home"
	echo "============================="	
	
    callAppsFunctions "$optionsSelected"


}

function restore_home_data() {

	optionsHomeToShow=();
	optionsHomeTitles=();
	optionsHomeId=();
		
    oldDirectoyPathVars=$(sed -r "s/(#.*)//" "$oldHome/.config/user-dirs.dirs" | sed '/^[[:space:]]*$/d')
    currentDirectoyPathVars=$(sed -r "s/(#.*)//" "$homeDir/.config/user-dirs.dirs" | sed '/^[[:space:]]*$/d')
    local SAVEIFS=$IFS
	local IFS=$'\n'
	currentDirectoyPathVarsArray=($currentDirectoyPathVars)
	local IFS=$SAVEIFS

    currentDirectoyPathVarsLength=${#currentDirectoyPathVarsArray[@]}
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
		optionsHomeCommand+=("[[ -d '$oldDirectoyPath' && -n \"\$(ls -A '$oldDirectoyPath')\" ]] && sudo $rsyncCommand '$oldDirectoyPath/'* '$currentDirectoryPath/'")
    done

	optionsSelected=$(zenity --list --width=800 --height=640 --text "Selecione Pastas da Home Antiga para Recuperar" \
		--checklist \
		--column "Marcar" \
		--column "App" \
		"${optionsHomeToShow[@]}")
	
	
	cancelSelection=$?
    	if [[ $cancelSelection = 1 ]] ;
	then
		echo "Cancelado!";
		return 0
	fi

	echo "============================="
 	echo " Restaurando Dados Home"
	echo "============================="

	optionsHomeLength=${#optionsHomeTitles[@]}
	
	local IFS="|"
	for commandId in $optionsSelected;
	do
		for (( i=0; i<${optionsHomeLength}; i++ ));
		do
			if [[ "${optionsHomeTitles[$i]}" == "$commandId" ]]
			then
				echo "Executando> ${optionsHomeCommand[$i]}"
				eval "${optionsHomeCommand[$i]}"
			fi
		done
	done
}

function restore_system_old() {


    ## Stop Network Manager
    #sudo /etc/init.d/network-manager stop
    ## copy the files from your old system (adapt as needed)
    #sudo rsync -va -c /media/$YOUR_OLD_SYSTEM/etc/NetworkManager/system-connections/ /etc/NetworkManager/system-connections/
    ## Get your new MAC address, and verify it is right.
    ## For example, this should work if you have only one wireless interface
    #export MAC=$(iw dev | grep addr | awk '{print $2}')
    #echo $MAC
    ## Replace the MAC address in all the system-connections files
    #sudo perl -i.bak -pe 's/^(mac-address=)(.*)/$1$ENV{MAC}/' /etc/NetworkManager/system-connections/*
    ## Restart NetworkManager, and wait for nm-applet to also start and connect    
    #sudo /etc/init.d/network-manager start
    ## Delete the backup files with the old MAC addresses
    #sudo rm /etc/NetworkManager/system-connections/*.bak

    zenity --question --width=600 --height=400 --text "Restaurar Sistema de uma instalação antiga?" || return 0

    currentRoot=""
    oldRoot="$(cd "/" && zenity --file-selection --title="Selecionar diretório / (Raíz) antigo" --directory)"

    rsyncCommand="rsync -aHAXxh --devices --specials --numeric-ids"

    options_title=();
    options_id=();
    options_selected=();


    if [[ -e "$oldRoot/etc/NetworkManager/system-connections" ]]; then
        options_title+=("Conexões Network Manager")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldRoot/etc/NetworkManager/system-connections' '$currentRoot/etc/NetworkManager/' && sudo service network-manager reload")
    fi

    if [[ -e "$oldRoot/data" ]]; then
        options_title+=("/data")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldRoot/data' '$currentRoot/'")
    fi

    optionsLength=${#options_id[@]}
    optionsToShow=();
    for (( i=0; i<${optionsLength}; i++ ));
    do
        optionsToShow+=(${options_selected[$i]} "${options_title[$i]}")
    done
    optionsSelected=$(zenity  --list  --width=800 --height=640 --text "Selecione Configs/Dados para Recuperar" \
        --checklist \
        --column "Marcar" \
        --column "App" \
        "${optionsToShow[@]}")
	
	cancelSelection=$?
    	if [[ $cancelSelection = 1 ]] ;
	then
		echo "Cancelado!";
		return 0
	fi
	
    echo "============================="
    echo " Restaurando Dados Sistema"
    echo "============================="

    callAppsFunctions "$optionsSelected"

}

function createTemplates() {
    if zenity --question --width=600 --height=400 --text "Criar Templates?"
    then
        currentDirectoyPathVars="$(sed -r "s/(#.*)//" "$currentHomeDir/.config/user-dirs.dirs" | sed '/^[[:space:]]*$/d')"
        currentDirectoryPath="$(echo "$currentDirectoyPathVars" | grep -E "^XDG_TEMPLATES_DIR\=" | sed -r 's/^([^\=]*)(\=)(")([^"]*)(")/\4/')"
        currentDirectoryPath="$(echo "${currentDirectoryPath/\$HOME/$currentHomeDir}")"
        sudo -u $currentUser touch "$currentDirectoryPath/novo.txt"
        sudo -u $currentUser cp -R "$basePath/home/templates"/* "$currentDirectoryPath/."
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

addPreCommand "install_base"

menuApps
installAllAfterSelections

createTemplates

restore_home_old
restore_system_old

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
