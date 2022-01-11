function install_base() {

    addPreCommand "pre_install_base"

    #addApt "ubuntu-restricted-extras"

    #addPreCommand "pre_install_zfs_snapshot"

    #addPreCommand "pre_install_base_hotfixSnap"
    
    addApt "apt-transport-https ca-certificates curl gnupg-agent software-properties-common"

    addApt "flatpak "
    #addPosAptCommand "flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo"

    addApt "wget curl rsync git bash dbus perl less mawk sed"

    addApt "nodejs npm"

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
