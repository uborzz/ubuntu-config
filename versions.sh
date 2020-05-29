#!/usr/bin/bash
zsh --version
git --version
docker --version
docker-compose --version
python --version
pip --version
pipenv --version
rustc --version
deno --version
go version
echo vscode $(code -v | head -1)
vim --version | head -1
curl --version | head -1 | awk '{print $1" "$2}'
thefuck --version
meld --version
google-chrome --version
vlc --version | head -0
spotify --version
timeshift | head -2 | tail -1
