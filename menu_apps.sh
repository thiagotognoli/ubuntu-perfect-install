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

    options_title+=("Chromium Browser [snap]")
    options_selected+=(FALSE)
    options_id+=("addSnap \"chromium\"")

    options_title+=("Chromium Browser [flat]")
    options_selected+=(TRUE)
    options_id+=("addFlatpak \"org.chromium.Chromium\"")

    options_title+=("Microsoft Edge Browser [apt]")
    options_selected+=(TRUE)
    options_id+=("replaceAptRepo \"deb [arch=amd64] https://packages.microsoft.com/repos/edge/ stable main\" \"microsoft-edge.list\" && addApt \"microsoft-edge-stable\"")

    options_title+=("Gmail App [git]")
    options_selected+=(TRUE)
    options_id+=("addPosAptCommand \"install_gmail_app\"")

    options_title+=("Caffeine (manter tela ligada) [apt]")
    options_selected+=(TRUE)
    options_id+=("addApt \"caffeine\"")

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

    options_title+=("Syncthing [apt]")
    options_selected+=(TRUE)
    options_id+=("install_syncthing_apt")

    options_title+=("NFS Client [apt]")
    options_selected+=(TRUE)
    options_id+=("addApt \"nfs-common\"")

    options_title+=("Mackup [snap]")
    options_selected+=(TRUE)
    options_id+=("addSnapClassic \"mackup\"")

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

    options_title+=("Linux Dynamic Wallpapers (like MacOS) [git]")
    options_selected+=(TRUE)
    options_id+=("addPosAptCommand \"install_linux_dynamic_wallpapers\"")

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

