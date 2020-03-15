# Requirements
- Git 2.14.6+
- VIM 8.2+

# Installation
In ~ (HOME) directory run sequentially:
```
git init
git remote add origin https://github.com/bedware/dotfiles.git
git pull origin master
git submodule update --init --recursive -j 2
chmod 0600 .ssh/id_*
```
