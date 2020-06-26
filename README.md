# ubuntu-config
Config script for ubuntu. Run after clear install.
* (!) no prevention for reinstalls or repeated adds to rc file
* needs interactions and entering sudo pass several times 

## install
```(bash)
wget https://raw.githubusercontent.com/uborzz/ubuntu-config/master/configure.sh
chmod +x configure.sh
./configure.sh
```
    
## check installed versions
```(bash)
wget https://raw.githubusercontent.com/uborzz/ubuntu-config/master/versions.sh
chmod +x versions.sh
./versions.sh
```

## to-dos
- noscript and ublock as plugins for firefox
- styles and js plugins for vscode
- make more module installs as unhandled
- merge configure and versions files in just 1 file