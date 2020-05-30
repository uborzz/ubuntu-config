#!/usr/bin/bash

# Run after Ubuntu 20.04 clean install
# installs and config stuff.

DIR=$(pwd)
cd ~

# common file for extend bash and zsh rc files. Name can be edited.
COMMON=.uborzzrc

# help functions to append content to the rc file
add_to_rc () {
	printf "\n$1\n" >> ~/$COMMON
}

info () {
	printf "\n$*\n"
}

# update system
info Running update and upgrade
sudo apt update
sudo apt upgrade

# curl
info Installing curl
sudo apt install curl 

# git
info Installing git
sudo apt install git

# zsh + oh my zsh
info Installing zsh and oh my zsh
sudo apt install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
chsh -s /usr/bin/zsh

# make .bashrc & .zshrc use the common rc file
echo "" >> .bashrc
echo "source ~/$COMMON" >> .bashrc
echo "" >> .zshrc
echo "[[ -e ~/$COMMON ]] && emulate sh -c 'source ~/$COMMON'" >> .zshrc

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
code --install-extension eamodio.gitlens
code --install-extension yzhang.markdown-all-in-one

# python: pip and venv
info Installing python utils
sudo apt install python3-pip
sudo apt install python3-venv
sudo ln -s /usr/bin/python /usr/bin/python3
sudo ln -s /usr/bin/pip /usr/bin/pip3

pip install --user pipenv
add_to_rc 'export PATH="$HOME/.local/bin:$PATH"'

code --install-extension ms-python.python

# pycharm
info Installing Pycharm
sudo snap install pycharm-community --classic

# docker
info Installing docker
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker

# docker-compose
info Installing docker compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose


# fuck
info Installing fuck
pip install thefuck
add_to_rc 'eval "$(thefuck --alias)"'

# vim
info Installing vim
sudo apt install vim -y

# meld
info Installing meld
sudo apt install meld -y

# rust
info Installing rust
curl https://sh.rustup.rs -sSf | sh
source $HOME/.cargo/env
add_to_rc 'export PATH="$HOME/.cargo/bin:$PATH"'

code --install-extension bungcip.better-toml
code --install-extension rust-lang.rust
code --install-extension serayuzgur.crates

# deno
info Installing deno
curl -fsSL https://deno.land/x/install/install.sh | sh
add_to_rc 'export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"'

# golang
info Installing go
wget https://dl.google.com/go/go1.14.3.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.*.tar.gz
add_to_rc 'export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/projects/go
export PATH=$PATH:$GOPATH/bin'
rm -rf go1.*.tar.gz

# timeshift
info Installing timeshit
sudo apt-get install timeshift

# configure ssh keys
info "Creating ssh key pair without passphrase on ~/.ssh/id_ed25519.pub"
read -p 'Insert label/comment for your key (usually email) >> ' LABEL
yes "" | ssh-keygen -t ed25519 -b 4096 -C $LABEL
info "Here is your public key:"
cat "$HOME/.ssh/id_ed25519.pub"

# configure git
echo 'Configuring git'
read -p 'What name do you want to use with git? ' GIT_NAME
read -p 'What email do you want to use with git? ' GIT_EMAIL
git config --global user.email $GIT_EMAIL
git config --global user.name $GIT_NAME
git config --global push.default simple

info Running update and upgrade again
sudo apt update
sudo apt upgrade

# back to dir
cd $DIR
info Thats all. Run versions.sh to check versions installed.
