function menu_chats() {

    options_title=();
    options_id=();
    options_selected=();

    options_title+=("Telegram Desktop [snap]")
    options_selected+=(FALSE)
    options_id+=("addSnap \"telegram-desktop\"")

    options_title+=("Skype [web apt]")
    options_selected+=(TRUE)
    options_id+=("install_skype_apt")

    options_title+=("Skype [snap classic]")
    options_selected+=(FALSE)
    options_id+=("addSnapClassic \"skype\"")

    options_title+=("Slack [snap classic]")
    options_selected+=(FALSE)
    options_id+=("addSnapClassic \"slack\"")

    options_title+=("Microsoft Teams [web deb]")
    options_selected+=(FALSE)
    options_id+=("addPosCommand \"pos_install_chats_teams\"")

    options_title+=("Discord [flatpak]")
    options_selected+=(FALSE)
    options_id+=("addFlatpak \"com.discordapp.Discord\"")


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

