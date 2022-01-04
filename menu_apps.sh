function menuApps() {

    options_title=();
    options_id=();
    options_selected=();

    options_title+=("Timeshift [apt]")
    options_selected+=(TRUE)
    options_id+=("addApt \"timeshift\"")

    options_title+=("Timeshift AutoSnap APT [git]")
    options_selected+=(TRUE)
    options_id+=("install_timeshift_autosnap_apt")

    options_title+=("Ubuntu Restricted Extras [apt]")
    options_selected+=(TRUE)
    options_id+=("addPreCommand \"install_ubuntu_restricted_extras\"")

    options_title+=("Alternative Terminals [seleção]")
    options_selected+=(TRUE)
    options_id+=("menu_alternative_terminals")

    options_title+=("SSH (Client e Server) [apt]")
    options_selected+=(FALSE)
    options_id+=("addApt \"ssh\"")

    #options_title+=("LVM 2 [apt]")
    #options_selected+=(TRUE)
    #options_id+=("addApt \"lvm2\"")

    options_title+=("Aptitude [apt]")
    options_selected+=(TRUE)
    options_id+=("addApt \"aptitude\"")

    options_title+=("Synaptic [apt]")
    options_selected+=(TRUE)
    options_id+=("addApt \"synaptic\"")

    options_title+=("Gnome Software [apt]")
    options_selected+=(FALSE)
    options_id+=("addApt \"gnome-software gnome-software-plugin-snap gnome-software-plugin-flatpak\"")

    options_title+=("NFS Client [apt]")
    options_selected+=(TRUE)
    options_id+=("addApt \"nfs-common\"")

    options_title+=("Syncthing [apt]")
    options_selected+=(TRUE)
    options_id+=("install_syncthing_apt")


    options_title+=("Monitoramento - htop [apt]")
    options_selected+=(TRUE)
    options_id+=("addApt \"htop\"")

    options_title+=("Monitoramento - iotop [apt]")
    options_selected+=(TRUE)
    options_id+=("addApt \"iotop\"")

    options_title+=("ZSH & Oh My ZSH [apt & git]")
    options_selected+=(TRUE)
    options_id+=("addApt \"zsh fonts-powerline\" && addPosCommand \"pos_install_ohmyzsh\"")

    options_title+=("sshuttle (ssh VPN) [apt]")
    options_selected+=(TRUE)
    options_id+=("addApt \"sshuttle\"")

    options_title+=("Mackup [snap]")
    options_selected+=(TRUE)
    options_id+=("addSnapClassic \"mackup\"")

    options_title+=("LSD (ls deluxe) [web deb]")
    options_selected+=(FALSE)
    options_id+=("addPosCommand \"pos_install_lsd\"")

    options_title+=("Config Gnome Shell [apt & bash]")
    options_selected+=(FALSE)
    options_id+=("config_gnomeshell")

    options_title+=("Gnome Shell Extensions [seleção]")
    options_selected+=(FALSE)
    options_id+=("menu_gnomeshellextensions_group")

    options_title+=("Google Chrome [web deb & apt repo]")
    options_selected+=(TRUE)
    options_id+=("addPosCommand \"install_googlechrome\"")

    options_title+=("Gmail App [git]")
    options_selected+=(TRUE)
    options_id+=("addPosAptCommand \"install_gmail_app\"")

    options_title+=("Caffeine (manter tela ligada) [apt]")
    options_selected+=(TRUE)
    options_id+=("addApt \"caffeine\"")

    options_title+=("Chromium Browser [snap]")
    options_selected+=(FALSE)
    options_id+=("addSnap \"chromium\"")

    options_title+=("Chromium Browser [flat]")
    options_selected+=(TRUE)
    options_id+=("addFlatpak \"org.chromium.Chromium\"")

    options_title+=("Flameshot Screen Shot [apt & app icon]")
    options_selected+=(TRUE)
    options_id+=("addApt \"flameshot\" && addPosCommand \"pos_install_flameshotscreenshot\"")

    options_title+=("Gocryptfs [apt]")
    options_selected+=(TRUE)
    options_id+=("addApt \"gocryptfs\"")

    options_title+=("RClone [apt]")
    options_selected+=(TRUE)
    options_id+=("addApt \"rclone\"")

    options_title+=("Nextcloud Client [apt oficial repo]")
    options_selected+=(TRUE)
    options_id+=("addApt \"nextcloud-desktop\"")

    options_title+=("Nextcloud Client [apt ppa repo]")
    options_selected+=(FALSE)
    options_id+=("install_ppa \"ppa:nextcloud-devs/client\" \"nextcloud-desktop\"")

    options_title+=("Sirikali [apt]")
    options_selected+=(TRUE)
    options_id+=("addApt \"sirikali\"")

    options_title+=("KeepasXC [apt]")
    options_selected+=(TRUE)
    options_id+=("addApt \"keepassxc\"")

    options_title+=("KeepasXC [flat]")
    options_selected+=(FALSE)
    options_id+=("addFlatpak \"org.keepassxc.KeePassXC\"")

    options_title+=("Authenticator (2FA) [flat]")
    options_selected+=(FALSE)
    options_id+=("addFlatpak \"com.github.bilelmoussaoui.Authenticator\"")

    options_title+=("Inkscape (Editor de Desenhos Vetorial) [apt]")
    options_selected+=(TRUE)
    options_id+=("addApt \"inkscape\"")

    options_title+=("Inkscape (Editor de Desenhos Vetorial) [snap]")
    options_selected+=(FALSE)
    options_id+=("addSnap \"inkscape\"")

    options_title+=("GIMP (Editor de Imagens) [apt]")
    options_selected+=(TRUE)
    options_id+=("addApt \"gimp\"")

    options_title+=("GIMP (Editor de Imagens) [snap]")
    options_selected+=(FALSE)
    options_id+=("addSnap \"gimp\"")

    options_title+=("DarkTable (Visualizador de Fotos/Imagens) [snap]")
    options_selected+=(FALSE)
    options_id+=("addSnap \"darktable\"")

    options_title+=("VLC Video Player [apt]")
    options_selected+=(TRUE)
    options_id+=("addApt \"vlc\"")  

    options_title+=("VLC Video Player [snap]")
    options_selected+=(FALSE)
    options_id+=("addSnap \"vlc\"")  

    options_title+=("Chats [seleção]")
    options_selected+=(TRUE)
    options_id+=("menu_chats")

    options_title+=("Devel Tools [seleção]")
    options_selected+=(TRUE)
    options_id+=("menu_develtools")

    options_title+=("Team Viewer [web deb & apt repo]")
    options_selected+=(FALSE)
    options_id+=("addPosCommand \"install_teamviewer\"")

    #options_title+=("Hotfix Snap (Ubuntu+ZFS bug) [apt]")
    #options_selected+=(FALSE)
    #options_id+=("addPreCommand \"pre_install_base_hotfixSnap\"")
    
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

function install_ubuntu_restricted_extras() {
    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
    addApt "ubuntu-restricted-extras"
}

function pos_install_flameshotscreenshot() {
    sudo -u $currentUser bash -c "echo -e '[Desktop Entry]\nVersion=1.1\nType=Application\nName=Flameshot Screenshot\nComment=Screenshot.\nIcon=flameshot\nExec=flameshot gui\nActions=\nCategories=Graphics;' | tee '$currentHomeDir/.local/share/applications/flameshot-screenshot.desktop'" \
        && sudo -u $currentUser chmod +x "$currentHomeDir/.local/share/applications/flameshot-screenshot.desktop"
}

function install_gmail_app() {
    sudo -u $currentUser mkdir -p "$currentHomeDir/tmp/gmail-app-linux" \
        && sudo -u $currentUser git clone https://github.com/thiagotognoli/gmail-app-linux.git "$currentHomeDir/tmp/gmail-app-linux" \
        && sudo -u $currentUser bash "$currentHomeDir/tmp/gmail-app-linux/install-zip.sh"
    sudo -u $currentUser rm -rf "$currentHomeDir/tmp/gmail-app-linux"
    addPreFinishCommand "sudo rm -rf \"$currentHomeDir/tmp\""
}

function install_timeshift_autosnap_apt() {
    sudo -u $currentUser mkdir -p "$currentHomeDir/tmp/timeshift-autosnap-apt" \
        && sudo -u $currentUser git clone https://github.com/wmutschl/timeshift-autosnap-apt.git "$currentHomeDir/tmp/timeshift-autosnap-apt" \
        && sudo -u $currentUser cd "$currentHomeDir/tmp/timeshift-autosnap-apt" \
        && sudo make install
    sudo -u $currentUser rm -rf "$currentHomeDir/tmp/timeshift-autosnap-apt"
    addPreFinishCommand "sudo rm -rf \"$currentHomeDir/tmp\""
}

function install_syncthing_apt() {
    addApt "curl apt-transport-https"
    addPosAptCommand "pre_install_syncthing_apt"
    addAptSecond "syncthing"
}

function pre_install_syncthing_apt() {
    cd /tmp
    sudo curl -s -o /usr/share/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg
    echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
    sudo apt update
}

function install_googlechrome() {
    #zenity --question --width=600 --height=400 --text "Instalar Google Chrome?" || return 0
    mkdir -p /tmp/googlechrome \
        && wget -O /tmp/googlechrome/googlechrome.deb $googleChromeDownloadLastUrl \
        && sudo dpkg -i /tmp/googlechrome/googlechrome.deb
    rm -rf /tmp/googlechrome
}

function install_teamviewer() {
    #zenity --question --width=600 --height=400 --text "Instalar TeamViewer?" || return 0
    sudo mkdir -p /tmp/teamviewerdwl \
        && sudo wget -O /tmp/teamviewerdwl/teamviwer.deb $teamViewerDownloadLastUrl \
        && sudo dpkg -i /tmp/teamviewerdwl/teamviwer.deb
    sudo apt -y -f install
    sudo rm -rf /tmp/teamviewerdwl
}

function pos_install_ohmyzsh() {

    sudo chsh -s $(which zsh) $currentUser

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

    sudo -u $currentUser git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-"$currentHomeDir/.oh-my-zsh/custom"}/plugins/zsh-syntax-highlighting \
        && plugins["zsh-syntax-highlighting"]="zsh-syntax-highlighting"

    sudo -u $currentUser git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-"$currentHomeDir/.oh-my-zsh/custom"}/themes/powerlevel10k \
        && sudo -u $currentUser sed -ri 's/(ZSH_THEME=")([^"]*)(")/\1powerlevel10k\/powerlevel10k\3/g' "$currentHomeDir/.zshrc"


    plugins="${plugins[@]}"
    sed -ri "s/^(plugins\=\()([^\)]*)(\))/\1$plugins\3/g" "$currentHomeDir/.zshrc"

    #sudo wget -N -P /usr/share/fonts/. \
    #    https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Regular.ttf \
    #    https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Bold.ttf \
    #    https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Italic.ttf \
    #    https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Bold%20Italic.ttf


    #sudo wget -N -P /usr/share/fonts/. \
    #    https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/complete/Fura%20Code%20Regular%20Nerd%20Font%20Complete%20Mono.otf \
    #    https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Bold/complete/Fura%20Code%20Bold%20Nerd%20Font%20Complete%20Mono.otf \
    #    https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Light/complete/Fura%20Code%20Light%20Nerd%20Font%20Complete%20Mono.otf \
    #    https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Medium/complete/Fura%20Code%20Medium%20Nerd%20Font%20Complete%20Mono.otf

    sudo wget -N -P /usr/share/fonts/. \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete%20Mono.ttf \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Bold/complete/Fira%20Code%20Bold%20Nerd%20Font%20Complete%20Mono.ttf \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Light/complete/Fira%20Code%20Light%20Nerd%20Font%20Complete%20Mono.ttf \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Medium/complete/Fira%20Code%20Medium%20Nerd%20Font%20Complete%20Mono.ttf
        

    while read profile; do
        if [[ "$profile" != "list" ]]; then
            dconf write "/org/gnome/terminal/legacy/profiles:/$profile/font" "'FiraCode Nerd Font Mono 12'"
            dconf write "/org/gnome/terminal/legacy/profiles:/$profile/use-system-font" "false"

        fi;
    done <<< $(dconf list /org/gnome/terminal/legacy/profiles:/)

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