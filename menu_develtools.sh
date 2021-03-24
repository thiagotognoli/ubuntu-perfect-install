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

function install_nvm() {
    addApt "curl"
    addPosAptCommand "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash"
    addPosCommand "pos_install_nvm"
}

function pos_install_nvm() {
    [ -e ~/.bashrc ] && echo "" >> ~/.bashrc \
        && echo 'export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"' >> ~/.bashrc \
        && echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm' >> ~/.bashrc
    [ -e ~/.zshrc ] && echo "" >> ~/.zshrc \
        && echo 'export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"' >> ~/.zshrc \
        && echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm' >> ~/.zshrc
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
    nvm use 15
    sudo npm --global install yarn
    [ -e ~/.bashrc ] && echo "" >> ~/.bashrc \
        && echo 'export PATH=$PATH:$(yarn global bin)' >> ~/.bashrc
    [ -e ~/.zshrc ] && echo "" >> ~/.zshrc \
        && echo 'export PATH=$PATH:$(yarn global bin)' >> ~/.zshrc
}

function install_yarn_apt() {
    addApt "curl apt-transport-https"
    addPosAptCommand "pre_install_yarn_apt"
    addAptSecond "yarn"
}

function pre_install_yarn_apt() {
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
}

function install_vscode_apt() {
    addApt "curl apt-transport-https"
    addPosAptCommand "pre_install_vscode_apt"
    addAptSecond "code gvfs-bin"
}

function pre_install_vscode_apt() {
    cd /tmp
    # configuração para repositórios grandes do vscode
    sudo bash -c "sed -i -r '/^fs.inotify.max_user_watches\=/d' /etc/sysctl.conf && echo \"fs.inotify.max_user_watches=524288\" >> /etc/sysctl.conf"
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt update
}

function install_insomnia() {
    addApt "curl apt-transport-https"
    addPosAptCommand "pre_install_insomnia_apt"
    addAptSecond "insomnia"
}

function pre_install_insomnia_apt() {
    # Add to sources
    echo "deb https://dl.bintray.com/getinsomnia/Insomnia /" \
        | sudo tee -a /etc/apt/sources.list.d/insomnia.list

    # Add public key used to verify code signature
    wget --quiet -O - https://insomnia.rest/keys/debian-public.key.asc \
        | sudo apt-key add -
}

function pos_install_vscode_snap() {
    sudo bash -c "echo >> /etc/sysctl.conf echo \"fs.inotify.max_user_watches=524288\" >> /etc/sysctl.conf" # configuração para repositórios grandes do vscode
}

function pos_install_golang() {
    if ! sudo -u $currentUser bash -c "grep -q \"\$HOME/go\" $currentHomeDir/.profile"; then
        sudo -u $currentUser bash -c "echo -e '\n#set GOPATH and GO_BIN\nif [ -d \"\$HOME/go\" ] ; then\n  export GO_PATH=\"\$HOME/go\"\n   # set PATH so it includes user'\''s go bin if it exists\n  if [ -d \"\$GO_PATH/bin\" ] ; then\n     PATH=\"\$GO_PATH/bin:$PATH\"\n   fi\nfi' >> $currentHomeDir/.profile"
    fi
    go get -u github.com/containous/yaegi/cmd/yaegi
}

function install_virtualbox() {
    addApt "apt-transport-https ca-certificates curl gnupg-agent software-properties-common"
    addPosCommand "pos_install_virtualbox \"$1\""
}

function pos_install_virtualbox() {
    curl -fsSL https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo apt-key add -
    curl -fsSL https://www.virtualbox.org/download/oracle_vbox.asc | sudo apt-key add -

    sudo bash -c "echo -e 'deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian $localUbuntuRelease contrib' >> /etc/apt/sources.list.d/virtualbox.list" \
    && sudo apt update && sudo apt install -y "virtualbox-$1"

    localUbuntuRelease="$ubuntuRelease"
}

function install_docker() {
    addApt "apt-transport-https ca-certificates curl gnupg-agent software-properties-common"
    addPosCommand "pos_install_docker"
}

function pos_install_docker() {
    #zenity --question --width=600 --height=400 --text "Instalar Docker?" || return 0
    localUbuntuRelease="$ubuntuRelease"

    sudo apt remove -y docker docker-engine docker.io containerd runc


    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - \
        && sudo bash -c "echo -e 'deb [arch=amd64] https://download.docker.com/linux/ubuntu $localUbuntuRelease stable\n# deb-src [arch=amd64] https://download.docker.com/linux/ubuntu $localUbuntuRelease stable' >> /etc/apt/sources.list.d/docker.list" \
        && sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io \
        && sudo adduser $currentUser docker \
        ¨&& fileSoArchiteture="$(uname -s)_$(uname -m)" \
        && lastDockerComposeLink="$(getLatestedGitFileLink "docker" "compose" "docker-compose-$fileSoArchiteture")" \
        && sudo curl -L "$lastDockerComposeLink" -o /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose

#    && sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $localUbuntuRelease stable" \

    ##Old Version
    #sudo apt install -y docker.io docker-compose 

    ##Snap (only work in $HOME)
    #sudo addgroup --system docker \
    # && sudo adduser $USER docker \
    # && newgrp docker \
    # && sudo snap install docker \
    # && docker run hello-world
}