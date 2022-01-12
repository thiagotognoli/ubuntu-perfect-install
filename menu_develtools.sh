function menu_develtools() {
    
    options_title=();
    options_id=();
    options_selected=();

    options_title+=("Docker e Docker Compose [apt repo]")
    options_selected+=(TRUE)
    options_id+=("install_docker")

    options_title+=("VirtualBox 6.1 [apt repo]")
    options_selected+=(FALSE)
    options_id+=("install_virtualbox \"6.1\"")

    options_title+=("Java JRE (Open JRE) [apt]")
    options_selected+=(TRUE)
    options_id+=("addApt \"default-jre\"")

    options_title+=("Java JDK (Open JDK) [apt]")
    options_selected+=(TRUE)
    options_id+=("addApt \"default-jdk\"")

    options_title+=("Go Lang & Yaegi [snap classic & go]")
    options_selected+=(TRUE)
    options_id+=("addSnapClassic \"go\" && addPosCommand \"pos_install_golang\"")
    
    #options_title+=("NodeJS [official apt]")
    #options_selected+=(FALSE)
    #options_id+=("addApt \"nodejs npm\"")

    options_title+=("NodeJS [snap edge classic]")
    options_selected+=(FALSE)
    options_id+=("addSnapEdgeClassic \"node\"")

    options_title+=("NVM, node 15, yarn [script]")
    options_selected+=(TRUE)
    options_id+=("install_nvm")

    options_title+=("Yarn [apt]")
    options_selected+=(FALSE)
    options_id+=("install_yarn_apt")

    #options_title+=("Yarn [npm]")
    #options_selected+=(FALSE)
    #options_id+=("install_yarn_apt")

    options_title+=("Visual Studio Code [apt repo]")
    options_selected+=(TRUE)
    options_id+=("install_vscode_apt")

    options_title+=("Visual Studio Code [snap classic]")
    options_selected+=(FALSE)
    options_id+=("addSnapClassic \"code\" && addPosCommand \"pos_install_vscode_snap\"")

    options_title+=("Netbeans [snap classic]")
    options_selected+=(FALSE)
    options_id+=("addSnapClassic \"netbeans\"")

    options_title+=("Filezilla (FTP GUI Client) [apt]")
    options_selected+=(TRUE)
    options_id+=("addApt \"filezilla\"")
    
    options_title+=("BaseX [apt]")
    options_selected+=(TRUE)
    options_id+=("addApt \"basex default-jre libtagsoup-java libjing-java\"")

    options_title+=("MySQL Workbench (Mysql GUI Client) [apt]")
    options_selected+=(TRUE)
    options_id+=("addApt \"mysql-workbench\"")

    options_title+=("Robot3t (MongoDB Gui Client) [snap]")
    options_selected+=(TRUE)
    options_id+=("addSnap \"robo3t-snap\"")

    options_title+=("Git Kraken (Git Gui Client) [snap]")
    options_selected+=(TRUE)
    options_id+=("addSnap \"gitkraken\"")

    options_title+=("Gitmoji [npm]")
    options_selected+=(TRUE)
    options_id+=("addNpm gitmoji")

    options_title+=("Insomnia (HTTP Rest Client) [apt]")
    options_selected+=(TRUE)
    options_id+=("install_insomnia")

    options_title+=("Insomnia (HTTP Rest Client) [snap]")
    options_selected+=(FALSE)
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

