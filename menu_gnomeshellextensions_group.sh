function menu_gnomeshellextensions_group() {

    addApt "wget bash curl dbus perl git less"
    addPosCommand "pos_install_gnomeshellextensions"

    options_title=();
    options_id=();
    options_selected=();

    eval "$(bash "$basePath/read-config.sh" -g)"

    optionsLength=${#options_id[@]}
    if [ $optionsLength = 1 ]; then
        eval "${options_id[0]}"
        return
    elif [ $optionsLength = 0 ]; then
        return
    else
        optionsToShow=();
        for (( i=0; i<${optionsLength}; i++ ));
        do
            optionsToShow+=(${options_selected[$i]} "${options_title[$i]}")
        done
    fi

    appsSelected=$(zenity  --list  --width=800 --height=640 --text "Selecione Grupos de Extensões do Gnome Shell para Instalar" \
        --checklist \
        --column "Marcar" \
        --column "Grupo de Extensões Gnome Shell" \
        "${optionsToShow[@]}")

	cancelSelection=$?
    if [[ $cancelSelection = 1 ]] ;
	then
		echo "Cancelado!";
		return 0
	fi

    callAppsFunctions "$appsSelected"
}


function menu_gnomeshellextensions() {
    options_title=();
    options_id=();
    options_selected=();

    local groupFilter="$1"
    eval "$(bash "$basePath/read-config.sh" -e "$groupFilter")"

    optionsLength=${#options_id[@]}
    if [ $optionsLength = 0 ]; then
        return;
    else
        optionsToShow=();
        for (( i=0; i<${optionsLength}; i++ ));
        do
            optionsToShow+=(${options_selected[$i]} "${options_title[$i]}")
        done
    fi

    appsSelected=$(zenity  --list  --width=800 --height=640 --text "Selecione Extensões [$groupFilter] do Gnome Shell para Instalar" \
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

    callAppsFunctions "$appsSelected"
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
    	sudo -u $currentUser "/usr/bin/gnome-shell-extension-installer" --update --yes
	
	
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