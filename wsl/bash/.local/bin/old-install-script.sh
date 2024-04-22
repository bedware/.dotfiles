#!/usr/bin/env bash

log() {
    # Colorfull log function
    echo ${RED}"$@"${RESET}
}
preparing_step() {
    log "Preparing to install"
    # Setting up colors
	# Only use colors if connected to a terminal
	if [ -t 1 ]; then
		RED=$(printf '\033[31m')
		GREEN=$(printf '\033[32m')
		YELLOW=$(printf '\033[33m')
		BLUE=$(printf '\033[34m')
		BOLD=$(printf '\033[1m')
		RESET=$(printf '\033[m')
	else
		RED=""
		GREEN=""
		YELLOW=""
		BLUE=""
		BOLD=""
		RESET=""
	fi
    # Updating indexes
    sudo apt update
}

install() {
    for name in $@; do
        eval install_$name
    done
}
install_zsh() {
    log "Installing zsh"
    sudo apt install -y zsh
    log "Changing default shell to zsh"
    sudo chsh $USER -s $(which zsh)
}
install_oh_my_zsh() {
    log "Installing oh-my-zsh"
    curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash -s -- --unattended --keep-zshrc
}
install_starship() {
    log "Installing Starship"
    curl -fsSL https://starship.rs/install.sh | bash -s -- -y
    echo 'eval "$(starship init zsh)"' >> ~/.zshrc
}
install_neovim() {
    log "Installing Neovim"
    # sudo apt install -y neovim
    wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
    chmod u+x nvim.appimage
    sudo mv ./nvim.appimage /usr/bin/nvim
    mkdir -p ~/.config/nvim/plugin
    mkdir -p ~/.config/nvim/after/plugin
    mkdir -p ~/.config/nvim/lua
    mkdir -p ~/.vim/undodir
}
install_brew() {
    log "Installing Brew"
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash
    echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> /home/$USER/.zprofile
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    sudo apt install build-essential -y
}
install_utils() {
    log "Installing Utils"
    brew install exa tldr hub clang
    sudo apt install jq -y
}
install_dotfiles() {
    log "Installing Dotfiles"
    cd $HOME
    rm .zshrc .oh-my-zsh/custom/example.zsh
    git init && \
    git remote add origin https://github.com/bedware/dotfiles.git && \
    git pull origin master
    log "Installing VimPlug"
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    log "Installing VimPlug plugins..."
    nvim --headless +PlugInstall +qa 2>&1 | sed -e '/Error detected while processing/d' -e '/line\s\+[0-9]\+:/d' -e '/E185:/d'
    SSH_INSTALL=yes
    printf "${YELLOW}Do you want to skip ssh keys installation? [Y/n]${RESET} "
    read o
    case $o in
        y*|Y*|"") echo "Going to next step..."; SSH_INSTALL=no ;;
        n*|N*) echo "SSH keys are going to install" ;;
        *) echo "Invalid choice. SSH keys installation will be skipped."; SSH_INSTALL=no ;;
    esac
    if [ $SSH_INSTALL = yes ]; then
        git submodule update --init -j 2 && \
        chmod 0600 .ssh/id_*
    fi
}

post_step() {
    log "Setup complete! Please relogin."
}

# Combine all together
main() {
    preparing_step
    install zsh oh_my_zsh starship neovim
    # If --fast arg exists don't install stuff below
    if [[ -n `echo $* | grep -- --fat` ]]; then
       install brew utils
    fi
    install dotfiles
    post_step
}
# Run it
main
