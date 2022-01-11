DATE_INI=$(date '+%Y/%m/%d-%H:%M:%S')

argScript="$(readlink -f "$0")"
#basePath="${argScript%/*}"
basePath="$(cd ${argScript%/*} && pwd)"

binDir="${basePath}/bin"



function checkRoot() {
    if [ "$EUID" -ne 0 ]
        then echo "Please run as root"
        exit
    fi
}

function setEnvs() {
    currentUser=`logname`
    currentGroup=`id -gn $currentUser`

    currentHomeDir="$(sudo -u $currentUser bash -c "echo ~")"

    ubuntuRelease=`lsb_release -cs`

    currentDate=$(date +%Y-%m-%d_%H-%M-%S.%N)

    source "$basePath/lib/read-config.sh"

    set -a # export all variables created next
    source $basePath/conf.conf
    set +a # stop exporting


}

function addNpm() {
    npm+=("$1")
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

function addAptRepo() {
    addPreCommand "sudo sh -c 'echo \"$1\" >> \"/etc/apt/sources.list.d/$2.list\"'"
}

function replaceAptRepo() {
    addPreCommand "sudo sh -c 'echo \"$1\" > \"/etc/apt/sources.list.d/$2.list\"'"
}

apt=()
apt_second=()
snap=()
snapClassic=()
snapEdgeClassic=()
gnomeShellExtension=()
npm=()

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
    installNpm
    installPosCommands
    installPreFinishCommand
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

    if [ ${#apt[@]} -eq 0 ]; then
        echo "Nenhum pacote para o APT instalar"
    else
        sudo apt update
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
    fi
}

function installAptSecond() {
    echo "============================="
    echo " Instalando Segundo Passo APT"
    echo "============================="

    if [ ${#apt_second[@]} -eq 0 ]; then
        echo "Nenhum pacote para o APT instalar"
    else
        sudo apt update

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
    fi
}

function intstallSnap() {
    echo "============================="
    echo " Instalando Snaps"
    echo "============================="

    if [ ${#snap[@]} -eq 0 ]; then
        echo "Nenhum pacote para o snap instalar"
    else
        for i in "${snap[@]}"
        do
            echo "Executando> sudo snap install \"$i\""
            sudo snap install "$i"
        done
    fi
    if [ ${#snapClassic[@]} -eq 0 ]; then
        echo "Nenhum pacote para o snap [classic] instalar"
    else
        for i in "${snapClassic[@]}"
        do
            echo "Executando> sudo snap install --classic \"$i\""
            sudo snap install --classic "$i"
        done
    fi
    if [ ${#snapEdgeClassic[@]} -eq 0 ]; then
        echo "Nenhum pacote para o snap [edge classic] instalar"
    else    
        for i in "${snapEdgeClassic[@]}"
        do
            echo "Executando> sudo snap install --edge --classic \"$i\""
            sudo snap install --edge --classic "$i"
        done
    fi
}

function installFlatpak() {
    echo "============================="
    echo " Instalando Flatpaks"
    echo "============================="

    if [ ${#flatpak[@]} -eq 0 ]; then
        echo "Nenhum pacote para o flat instalar"
    else 
        #executar apos o pos, ou add o repo before this after apt
        for i in "${flatpak[@]}"
        do
            echo "Executando> sudo -u $currentUser flatpak install -y \"$i\""
            sudo -u $currentUser flatpak install -y "$i"
        done    
    fi
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

function installNpm() {
    echo "============================="
    echo " Instalando npm"
    echo "============================="

    if [ ${#npm[@]} -eq 0 ]; then
        echo "Nenhum pacote para o npm instalar"
    else 
        sudo npm install -g npm

        npmToInstall=()

        for line in "${npm[@]}"
        do
            local IF="\ "
            for i in $line # note that $var must NOT be quoted here!
            do
                #if [[ $(sudo apt-cache search "^$i$") ]]; then
                    npmToInstall+=("$i")
                #fi
            done
        done

        echo "Executando> sudo npm install -g \"${npmToInstall[@]}\""
        sudo npm install -g "${npmToInstall[@]}"
    fi
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

function callAppsFunctionsDebug() {
	local _optionsTitles=("${options_title[@]}")
	local _optionsCommands=("${options_id[@]}")
	local _optionsLength=("${optionsLength[@]}")
	
    local IFS="|"
    for app in $1;
    do
        for (( i=0; i<${_optionsLength}; i++ ));
        do
            [[ "${_optionsTitles[$i]}" == "$app" ]] && echo "${_optionsCommands[$i]}"
        done
    done
}



function getLatestedGitFileLink() {
    gitUser="$1";
    gitProject="$2";
    fileToDownload="$3";

    curl -s -L https://api.github.com/repos/$gitUser/$gitProject/releases/latest \
    | grep  -E "\"browser_download_url\": \"https://github.com/(.*)/$fileToDownload\"" \
    | sed -r "s@.*\"browser_download_url\": \"(.*\/$fileToDownload)\"@\1@"
}


function download_install_apt() {
    sudo mkdir -p "/tmp/$1" \
        && sudo wget -O "/tmp/$1/$1.deb" "$2" \
        && sudo dpkg -i "/tmp/$1/$1.deb"
    sudo apt -y -f install
    sudo rm -rf "/tmp/$1"
}

function install_ppa() {
    addApt "apt-transport-https ca-certificates curl gnupg-agent software-properties-common"
    addPosAptCommand "sudo add-apt-repository '$1' "
    addAptSecond "$2"
}


function check_page_exist() {
    CURL=$(curl --fail -O "$1" 2>&1)
    # check if error and 404, and save in file
    if [ $? -ne 0 ]; then
        echo $CURL | grep --quiet 'The requested URL returned error: 404'
        #[ $? -eq 0 ] && echo "$url" >> "files.txt"
    fi    
    #http://download.virtualbox.org/virtualbox/debian/dists/groovy/
}

#TODO: adicionar add repositorio apt com chave