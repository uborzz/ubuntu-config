#!/usr/bin/bash

info () {
	printf "\n[ $* ]\n"
}

info MAIN
git --version
docker --version
zsh --version
terminator --version

info PYTHON
python --version
pip --version
pipenv --version

info NODE
. ~/.nvm/nvm.sh
echo nvm $(nvm --version)
echo npm $(npm --version)
echo node $(node --version)

info OTHER LANGUAJES
rustc --version
go version
deno --version

info TOOLS
vim --version | head -1
docker-compose --version
curl --version | head -1 | awk '{print $1" "$2}'
thefuck --version
echo tldr $(tldr --version)
meld --version
echo fzf $(fzf --version)

info APPS
google-chrome --version
timeshift | head -2 | tail -1

info SNAPS
snap list | grep -v canonical | awk '{print $1"\t"$2"\t"$5}' | column -t

info VSCODE EXTENSIONS
code --list-extensions

info SSH PUB KEY
cat ~/.ssh/id_ed25519.pub

info GIT CONFIG
git config --global -l | cat