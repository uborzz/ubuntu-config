#!/usr/bin/bash

# Run after Ubuntu 20.04 clean install
# installs and configs stuff.

DIR=$(pwd)
cd ~

# common file in home directory for extending bash and zsh rc files. 
read -p "Enter new rc file name (leave blank to use .uborzzrc): " answer
COMMON=${answer:-.uborzzrc}

if [ -f "$COMMON" ]; then
	read -p "File $COMMON already found. Things are gonna be appended. Ok? (y/N): " answer	
	case $answer in
		y|Y) ;;
		*) echo "Exiting..." && exit 1
	esac
fi

# help function to append content to the rc file 
add_to_rc () {
	printf "\n$1\n" >> ~/$COMMON
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


# nvm and node
# ----

info Installing nvm

# nvm
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
# nvm and bash_completion exports are automatically writen in bashrc

# export to use npm for module installs in this script
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# nvm load as plugin in zsh
sed -i 's/plugins=(git)/plugins=(git nvm)/g' .zshrc

# installs node
info Installing node
nvm install node


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
sudo apt-get install fzf

# terminator
infor Installing terminator
sudo apt install terminator

# meld
info Installing meld
sudo apt install meld -y

# tldr
info Installing tldr
sudo npm install -g tldr

# timeshift
info Installing timeshit
sudo apt-get install timeshift

# postman
info Installing postman client
sudo snap install postman

# dbeaver
info Installing dbeaver
sudo snap install dbeaver-ce

# microsoft teams
info Installing microsoft teams
sudo chown _apt /var/lib/update-notifier/package-data-downloads/partial
wget https://packages.microsoft.com/repos/ms-teams/pool/main/t/teams/teams_1.3.00.5153_amd64.deb
sudo apt install ./teams_1.3.00.5153_amd64.deb
rm teams_1.3.00.5153_amd64.deb

# more vscode utilities
info Installing more VS Code extensions
code --install-extension eamodio.gitlens
code --install-extension yzhang.markdown-all-in-one
code --install-extension humao.rest-client
code --install-extension coenraads.bracket-pair-colorizer
code --install-extension formulahendry.auto-rename-tag
code --install-extension vscode-icons-team.vscode-icons
code --install-extension esbenp.prettier-vscode


# configure ssh keys
# ------------------

info "Creating ssh key pair without passphrase on ~/.ssh/id_ed25519.pub"
read -p 'Insert label/comment for your key (usually email) >> ' LABEL
yes "" | ssh-keygen -t ed25519 -b 4096 -C $LABEL
info "Here is your public key:"
cat "$HOME/.ssh/id_ed25519.pub"


# configure git
# -------------

echo 'Configuring git'
read -p 'What name do you want to use with git? ' GIT_NAME
read -p 'What email do you want to use with git? ' GIT_EMAIL
git config --global user.email $GIT_EMAIL
git config --global user.name $GIT_NAME
git config --global push.default simple

info Running update and upgrade again
sudo apt update
sudo apt upgrade


# add to path custom folder shortcuts in user home
read -p "Add shortcuts folder to path? (y, N): " answer
case $answer in
	y|Y) create=true;;
	*) create=false;;
esac
[ $create = true ] && echo "Adding shortcuts to path..." || echo "Not adding..."
[ $create = true ] && add_to_rc 'export PATH="$PATH:$HOME/shortcuts"'
[ $create = true ] && mkdir -p shortcuts 


# back to dir
cd $DIR
info "Thats all! 
Run versions.sh to check versions installed."
