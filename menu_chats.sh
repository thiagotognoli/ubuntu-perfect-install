function menu_chats() {

    options_title=();
    options_id=();
    options_selected=();

    options_title+=("Telegram Desktop [snap]")
    options_selected+=(FALSE)
    options_id+=("addSnap \"telegram-desktop\"")

    options_title+=("Skype [snap classic]")
    options_selected+=(FALSE)
    options_id+=("addSnapClassic \"skype\"")

#    options_title+=("Skype [apt]")
#    options_selected+=(TRUE)
#    options_id+=("addSnapClassic \"skype\"")


    options_title+=("Slack [snap classic]")
    options_selected+=(FALSE)
    options_id+=("addSnapClassic \"slack\"")

    options_title+=("Microsoft Teams [web deb]")
    options_selected+=(FALSE)
    options_id+=("addPosCommand \"pos_install_chats_teams\"")

    options_title+=("Discord [flatpak]")
    options_selected+=(FALSE)
    options_id+=("addFlatpak \"com.discordapp.Discord\"")

    options_title+=("LSD (ls deluxe) [web deb]")
    options_selected+=(FALSE)
    options_id+=("addPosCommand \"pos_install_lsd\"")

    options_title+=("WhatsDesk Fork TT [web deb]")
    options_selected+=(TRUE)
    options_id+=("addPosAptCommand \"install_whatsdesk_apt\"")

    #options_title+=("WhatsApp Electrom [git]")
    #options_selected+=(FALSE)
    #options_id+=("addPosCommand \"pos_install_chats_whatsappelectron\"")

    #options_title+=("WhatsDesk [snap]")
    #options_selected+=(FALSE)
    #options_id+=("addSnap \"whatsdesk\"")

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


function install_skype_apt() {
    download_install_apt skype "$skypeDownloadLastUrl"
}

function install_whatsdesk_apt() {
    download_install_apt whatsdesk "$whatsdeskDownloadLastUrl"
}