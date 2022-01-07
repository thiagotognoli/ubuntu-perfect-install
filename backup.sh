
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
        options_title+=("Visual Studio Code Modules")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.vscode' '$homeDir/'")
    fi

    if [[ -e "$oldHome/.config/Code" || -L "$oldHome/.config/Code" ]]; then
        options_title+=("Visual Studio Code Configs")
        options_selected+=(TRUE)
        options_id+=("sudo $rsyncCommand '$oldHome/.config/Code' '$homeDir/'")
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
