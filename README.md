# Requirements
- curl
- Git 2.14.6+
- VIM 8.2+

# Installation
In ~ (HOME) directory run sequentially:
```
git init
git remote add origin https://github.com/bedware/dotfiles.git
git pull origin master
git submodule update --init -j 2
chmod 0600 .ssh/id_*
```
Open VIM then:
```
:PlugInstall
```
