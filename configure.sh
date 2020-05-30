#!/usr/bin/bash

# Run after Ubuntu 20.04 clean install
# installs and config stuff.

DIR=$(pwd)
cd ~

# common file for extend bash and zsh rc files. Name can be edited.
COMMON=.uborzzrc

# help function to append content to the rc file
add_to_rc () {
	echo "" >> ~/$COMMON
	echo $1 >> ~/$COMMON
}

# update system
sudo apt update
sudo apt upgrade

# curl
sudo apt install curl 

# git
sudo apt install git

# zsh + oh my zsh
sudo apt install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
chsh -s /usr/bin/zsh

# make .bashrc & .zshrc use the common rc file
echo "" >> .bashrc
echo "source ~/$COMMON" >> .bashrc
echo "" >> .zshrc
echo "[[ -e ~/$COMMON ]] && emulate sh -c 'source ~/$COMMON'" >> .zshrc

# chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
sudo rm ./google-chrome-stable_current_amd64.deb

# telegram
sudo snap install telegram-desktop

# spotify
sudo snap install spotify

# vlc
sudo snap install vlc

# vscode
sudo snap install code --classic
code --install-extension eamodio.gitlens
code --install-extension yzhang.markdown-all-in-one

# python: pip and venv
sudo apt install python3-pip
sudo apt install python3-venv
sudo ln -s /usr/bin/python /usr/bin/python3
sudo ln -s /usr/bin/pip /usr/bin/pip3

pip install --user pipenv
add_to_rc 'export PATH="$HOME/.local/bin:$PATH"'

code --install-extension ms-python.python

# pycharm
sudo snap install pycharm-community --classic

# docker
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker

# docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# fuck
pip install thefuck
add_to_rc 'eval "$(thefuck --alias)"'

# vim
sudo apt install vim -y

# meld
sudo apt install meld -y

# rust
curl https://sh.rustup.rs -sSf | sh
source $HOME/.cargo/env
add_to_rc 'export PATH="$HOME/.cargo/bin:$PATH"'

code --install-extension bungcip.better-toml
code --install-extension rust-lang.rust
code --install-extension serayuzgur.crates

# deno
curl -fsSL https://deno.land/x/install/install.sh | sh
add_to_rc 'export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"'

# golang
wget https://dl.google.com/go/go1.14.3.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.*.tar.gz
add_to_rc 'export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/projects/go
export PATH=$PATH:$GOPATH/bin'
rm -rf go1.*.tar.gz

# timeshift
sudo apt-get install timeshift

# configure ssh keys
echo "creating ssh key pair without passphrase on ~/.ssh/id_ed25519.pub"
read -p 'Insert label for your key (usually email) >> ' LABEL
yes "" | ssh-keygen -t ed25519 -b 4096 -C $LABEL
printf "\nyour key:\n\n"
cat "$HOME/.ssh/id_ed25519.pub"

# configure git
echo 'Configuring git'
read -p 'What name do you want to use with git? ' GIT_NAME
read -p 'What email do you want to use with git? ' GIT_EMAIL
git config --global user.email $GIT_EMAIL
git config --global user.name $GIT_NAME
git config --global push.default simple

sudo apt update
sudo apt upgrade

# check installs
cd $DIR
bash versions.sh
