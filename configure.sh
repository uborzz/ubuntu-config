#!/usr/bin/bash

# Run after Ubuntu 20.04 clean install
# installs and configs stuff.

DIR=$(pwd)
cd ~

# common file in home directory for extending bash and zsh rc files. 
DEFAULT_FILE=.${USER}rc
read -p "Enter new rc file name (leave blank to use ${DEFAULT_FILE}): " answer
COMMON=${answer:-${DEFAULT_FILE}}

if [ -f "$COMMON" ]; then
	read -p "File $COMMON already found. Things are gonna be appended. Ok? (y/N): " answer	
	case $answer in
		y|Y) ;;
		*) echo "Exiting..." && exit 1
	esac
else
	echo "\nCreating $COMMON file\n"
	touch $COMMON
fi

# help function to append content to the rc file 
add_to_rc () {
	printf "\n$1\n" >> ~/$COMMON
}

add_to_zshrc () {
	printf "\n$1\n" >> ~/.zshrc
}

# help function to print info
info () {
	printf "\n$*\n"
}

# update system
info Running update and upgrade
sudo apt update
sudo apt upgrade


# basic
# -----

# curl
info Installing curl
sudo apt install curl 

# git
info Installing git
sudo apt install git

# zsh + oh my zsh
info Installing zsh and oh my zsh
sudo apt install zsh
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
sh install.sh --unattended
rm install.sh
info Making zsh your default shell...
chsh -s /usr/bin/zsh  # makes zsh the default shell


# make .bashrc & .zshrc use the common rc file
echo "" >> .bashrc
echo "source ~/$COMMON" >> .bashrc
echo "" >> .zshrc
echo "[[ -e ~/$COMMON ]] && emulate sh -c 'source ~/$COMMON'" >> .zshrc


# apps
# ----

# chrome
info Installing chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
sudo rm ./google-chrome-stable_current_amd64.deb

# telegram
info Installing telegram
sudo snap install telegram-desktop

# spotify
info Installing spotify
sudo snap install spotify

# vlc
info Installing VLC
sudo snap install vlc

# discord
info Installing discord
sudo snap install discord


# vscode
info Installing VS Code
sudo snap install code --classic


# python
# ------

info Installing python utils
# version 3.8.X is already installed in ubuntu 20.04

# python: pip and venv
sudo apt install python3-pip
sudo apt install python3-venv
sudo ln -s /usr/bin/python3 /usr/bin/python
sudo ln -s /usr/bin/pip3 /usr/bin/pip

# pipenv
pip install --user pipenv
add_to_rc 'export PATH="$HOME/.local/bin:$PATH"'

code --install-extension ms-python.python

# deadsnakes for other python versions
sudo add-apt-repository ppa:deadsnakes/ppa

# pycharm
info Installing Pycharm
sudo snap install pycharm-community --classic


# docker
# ------

info Installing docker
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker

# docker-compose
info Installing docker compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

code --install-extension ms-azuretools.vscode-docker

# allows user to run docker commands (no sudo needed)
# needed for vscode docker plugin to run propperly 
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

# portainer 
docker volume create portainer_data
docker run -d -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer


# WIP: running in vscode python interpreters from dockerized venvs
# # docker-machine
# curl -L https://github.com/docker/machine/releases/download/v0.16.2/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine &&
#     chmod +x /tmp/docker-machine &&
#     sudo cp /tmp/docker-machine /usr/local/bin/docker-machine


# rust
# ----

info Installing rust
curl https://sh.rustup.rs -sSf | sh
source $HOME/.cargo/env
add_to_rc 'export PATH="$HOME/.cargo/bin:$PATH"'

code --install-extension bungcip.better-toml
code --install-extension rust-lang.rust
code --install-extension serayuzgur.crates


# deno
# ----

info Installing deno
curl -fsSL https://deno.land/x/install/install.sh | sh
add_to_rc 'export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"'


# golang
# ------

info Installing go
wget https://dl.google.com/go/go1.14.3.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.*.tar.gz
add_to_rc 'export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/projects/go
export PATH=$PATH:$GOPATH/bin'
rm -rf go1.*.tar.gz

code --install-extension golang.go


# default java jdk
# ----------------

sudo apt-get install default-jdk
code --install-extension vscjava.vscode-java-pack


# nvm, node, npm
# --------------

info Installing nvm

# nvm
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
# nvm and bash_completion exports are automatically writen in bashrc

# export to use nvm for installs in this script
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# nvm load as plugin in zsh
sed -i 's/plugins=(git)/plugins=(git nvm)/g' .zshrc

# installs node
info Installing node
nvm install node

# node utils
info Installing nodemon
npm install -g nodemon
npm install -g express-generator

# typescript
info Installing tsc
npm install -g typescript


# platformio
# ----------

info Installing PlatformIO on top of VSCode

# platformio core
python3 -c "$(curl -fsSL https://raw.githubusercontent.com/platformio/platformio/develop/scripts/get-platformio.py)"
add_to_rc 'export PATH=$PATH:~/.platformio/penv/bin'

# c++ code utils
code --install ms-vscode.cpptools

# platformio ide
code --install-extension platformio.platformio-ide


# more tools
# ----------

# fuck
info Installing fuck
pip install thefuck
add_to_rc 'eval "$(thefuck --alias)"'

# vim
info Installing vim
sudo apt install vim -y

# fzf
info Installing fzf
sudo apt-get install fzf -y
add_to_zshrc 'source /usr/share/doc/fzf/examples/key-bindings.zsh'

# terminator
info Installing terminator
sudo apt install terminator

# meld
info Installing meld
sudo apt install meld -y

# tldr
info Installing tldr
npm install -g tldr

# tree
info Installing tree
sudo apt-get install tree -y

# nmap
info Installing nmap
sudo apt-get install nmap -y

# gparted
sudo apt-get install gparted -y

# timeshift
info Installing timeshit
sudo apt-get install timeshift

# postman
info Installing postman client
sudo snap install postman

# dbeaver
info Installing dbeaver
sudo snap install dbeaver-ce

# robo3t
info Installing robomongo
sudo snap install robo3t-snap

# pgadmin4
info Installing pgadmin
sudo curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add
sudo sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'
sudo apt install pgadmin4

# git-cola
info Installing git-cola
sudo apt-get install git-cola

# parcellite
info Installing parcellite
	# deps
sudo apt install libcanberra-gtk-module libcanberra-gtk3-module
sudo apt install parcellite

# wine
info Installing wine
sudo dpkg --add-architecture i386
wget -O - https://dl.winehq.org/wine-builds/winehq.key | sudo apt-key add -
sudo add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main'
sudo apt update
sudo apt install --install-recommends winehq-stable
sudo apt-get install winetricks

# pdf mix
info Installing PDF Mix Tool
sudo snap install pdfmixtool

# gimp
info Install gimp
sudo apt-get install gimp -y

# joplin
info Install Joplin
wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash

# xnview
info Install XnView
wget https://download.xnview.com/XnViewMP-linux-x64.deb
sudo apt install ./XnViewMP*.deb -y
sudo rm ./XnViewMP*.deb

# kazam
info Install Kazam
sudo apt install kazam

# openshot
info Install OpenShot
sudo apt install openshot

# more vscode utilities
info Installing more VS Code extensions
code --install-extension eamodio.gitlens
code --install-extension yzhang.markdown-all-in-one
code --install-extension humao.rest-client
code --install-extension coenraads.bracket-pair-colorizer
code --install-extension formulahendry.auto-rename-tag
code --install-extension vscode-icons-team.vscode-icons
code --install-extension esbenp.prettier-vscode

# azure cli
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# kubectl
# TODO do this propperly
sudo az aks install-cli
echo "" >> ~/.zshrc
echo "alias k=kubectl" >> ~/.zshrc
echo "" >> ~/.zshrc
echo "if [ $(which kubectl) ]; then source <(kubectl completion zsh); fi" >> ~/.zshrc
echo "" >> ~/.zshrc

# helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
rm get_helm.sh

# minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
sudo dpkg -i minikube_latest_amd64.deb
rm minikube_latest_amd64.deb

# helmfile
git clone https://github.com/roboll/helmfile.git helmfile
cd helmfile
make build
make install
cd ..
rm -rf helmfile


# corporative
# -----------

# microsoft teams
info Installing microsoft teams
sudo chown _apt /var/lib/update-notifier/package-data-downloads/partial
wget https://packages.microsoft.com/repos/ms-teams/pool/main/t/teams/teams_1.4.00.7556_amd64.deb
sudo apt install ./teams_*
rm teams_*

# microsoft outlook
sudo snap install prospect-mail

# configure ssh keys
# ------------------

info "Creating ssh key pair without passphrase on ~/.ssh/id_ed25519.pub"
read -p 'Insert label/comment for your key (usually email) >> ' LABEL
if [[ -z "$LABEL" ]]; then
   printf '%s\n' "No input given. Your username is gonna be used as comment."
   LABEL=$USER
fi
yes "" | ssh-keygen -t ed25519 -b 4096 -C $LABEL
info "Here is your public key:"
cat "$HOME/.ssh/id_ed25519.pub"
read -n 1 -r -s -p $'Take your key and press any key to continue...\n'


# configure git
# -------------

info 'Configuring git'
read -p 'What name do you want to use with git? ' GIT_NAME
read -p 'What email do you want to use with git? ' GIT_EMAIL
git config --global user.email $GIT_EMAIL
git config --global user.name $GIT_NAME
git config --global push.default simple


# add to path custom folder shortcuts in user home
read -p "Add shortcuts folder to path? (y, N): " answer
case $answer in
	y|Y) create=true;;
	*) create=false;;
esac
[ $create = true ] && echo "Adding shortcuts to path..." || echo "Not adding..."
[ $create = true ] && add_to_rc 'export PATH="$PATH:$HOME/shortcuts"'
[ $create = true ] && mkdir -p shortcuts 


info Running update and upgrade again
sudo apt update
sudo apt upgrade

# bugs fix: lags opening apps
sudo apt install appmenu-gtk2-module appmenu-gtk3-module -y
# disables all app autostart (remmina and teams)
rm ~/.config/autostart/*

# needs interaction
# -----------------

# dbschema
info Installing dbschema
wget https://dbschema.com/download/DbSchema_unix_8_4_0.sh
chmod +x DbSchema_unix_*
./DbSchema_unix_*


# back to dir
cd $DIR
info "Thats all! 
Run versions.sh to check versions installed."
