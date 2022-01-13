#!/bin/bash

source "$(sourcePath=`readlink -f "$0"` && cd "${sourcePath%/*}" && pwd)/lib/functions.sh"

checkRoot
setEnvs

source "$basePath/lib/install-commons.sh"


function menu_apps_group() {

    #addApt "wget bash curl dbus perl git less"
    #addPosCommand "pos_install_gnomeshellextensions"

    local options_title=();
    local options_id=();
    local options_selected=();

    eval "$(read_appsGroups 'menu_apps')"
    echo

    local optionsLength=${#options_id[@]}
    local optionsToShow
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

    #|recode html..ascii

    local appsSelected=$(zenity  --list  --width=800 --height=640 --text "Selecione os Grupos de Apps para Instalar" \
        --checklist \
        --column "Marcar" \
        --column "Grupo de Apps" \
        "${optionsToShow[@]}")

	local cancelSelection=$?
    if [[ $cancelSelection = 1 ]] ;
	then
		echo "Cancelado!";
		return 0
	fi

    callAppsFunctions "$appsSelected"
}


function menu_apps() {
    local options_title=();
    local options_id=();
    local options_selected=();

    local groupFilter="$1"
    eval "$(read_apps \"$groupFilter\")"
    echo "$(read_apps \"$groupFilter\")"

    local optionsLength=${#options_id[@]}
    local optionsToShow
    if [ $optionsLength = 0 ]; then
        return;
    else
        optionsToShow=();
        for (( i=0; i<${optionsLength}; i++ ));
        do
            optionsToShow+=(${options_selected[$i]} "${options_title[$i]}")
        done
    fi

    local appsSelected=$(zenity  --list  --width=800 --height=640 --text "Selecione Apps do [$(encodeHtml "$groupFilter")]" \
        --checklist \
        --column "Marcar" \
        --column "App" \
        "${optionsToShow[@]}")

	local cancelSelection=$?
    if [[ $cancelSelection = 1 ]] ;
	then
		echo "Cancelado!";
		return 0
	fi

    ##echo "$appsSelected"

    #callAppsFunctionsDebug "$appsSelected"
    ##callAppsFunctions "$appsSelected"
}


echo "Iniciando Diálogos"

#addPreCommand "install_base"

loadCommands

menu_apps_group

installAllAfterSelections

exit 0

createTemplates

source $basePath/backup.sh

restore_home_old
restore_system_old



# function pos_install_gnomeshellextensions() {
#     cd /
    
#      sudo wget https://raw.githubusercontent.com/brunelli/gnome-shell-extension-installer/master/gnome-shell-extension-installer -O "/usr/bin/gnome-shell-extension-installer" \
#      	&& sudo chmod a+x "/usr/bin/gnome-shell-extension-installer"
    
#     #sudo mkdir -p "$binDir" \
#     #    && sudo rm -rf "$binDir/gnome-shell-extension-installer" \
#     #    && sudo wget https://raw.githubusercontent.com/brunelli/gnome-shell-extension-installer/master/gnome-shell-extension-installer -O "$binDir/gnome-shell-extension-installer" \
#     #    && sudo chmod a+x "$binDir/gnome-shell-extension-installer"

    
    
#     if [ $? -eq 0 ]; then
#     	echo "Atualizando Extensions"
#     	sudo -u $currentUser "/usr/bin/gnome-shell-extension-installer" --update --yes
	
	
#         echo "Installing Extensions"

#         # get length of an array
#         gnomeShellExtensionsIdlength=${#gnomeShellExtension[@]}
#         # use for loop to read all values and indexes
#         for (( i=0; i<${gnomeShellExtensionsIdlength}; i++ ));
#         do
#             gnomeShellExtensionIndex="${gnomeShellExtension[$i]}"
#             echo "Installing ${gnomeExtensions_Name[$gnomeShellExtensionIndex]} Gnome Shell Extension"
#             sudo -u $currentUser "/usr/bin/gnome-shell-extension-installer" --yes "${gnomeExtensions_Id[$gnomeShellExtensionIndex]}"
#         done
#     else
#         echo "Fail to install pre-requisites to Gnome Extensions"
#     fi
# }