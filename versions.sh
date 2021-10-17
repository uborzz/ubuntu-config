#!/usr/bin/bash

info () {
	printf "\n[ $* ]\n"
}

info MAIN
curl --version | head -1 | awk '{print $1,$2}'
zsh --version
git --version
terminator --version
echo vscode $(code --version | head -1)

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
echo "$(deno --version | tr '\n' ' ')"
echo "java $(java --version | head -1)"

info CONTAINERS
docker --version
docker-compose --version
az --version 2> /dev/null  | head -1
echo kubectl $(kubectl version -o json | grep gitVersion | awk '{print $2}' | tr -d '",')
echo helm $(helm version | grep -o "Version:[^,]*,\s") 
helmfile --version
kind --version
minikube version | head -1

info TOOLS
vim --version | head -1
thefuck --version
echo tldr $(tldr --version)
meld --version
echo fzf $(fzf --version)
tree --version
nmap --version | head -1
ccat --version
cola --version

info APPS
google-chrome --version
timeshift | head -2 | tail -1
gimp --version

info SNAPS
snap list | grep -v canonical | awk '{print $1"\t"$2"\t"$5}' | column -t

info VSCODE EXTENSIONS
code --list-extensions

info NOT CHECKED APPS
echo parcellite
echo joplin
echo pdfmixtool
echo xnview
echo kazam
echo openshot

info SSH PUB KEY
cat ~/.ssh/id_ed25519.pub

info GIT CONFIG
git config --global -l | cat
