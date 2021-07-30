# Extend fpath (autoload from external)
fpath=($ZDOTDIR/external $fpath)

# Aliases
source "$XDG_CONFIG_HOME/zsh/aliases"

# Options
# https://zsh.sourceforge.io/Doc/Release/Options.html
# unsetopt CASE_GLOB

# Push the current directory visited on to the stack
setopt AUTO_PUSHD
# Do not store duplicate directories in the stack
setopt PUSHD_IGNORE_DUPS
# Do not print the directory stack after using pushd or popd
setopt PUSHD_SILENT

# Autocomplete
autoload -Uz compinit; compinit
# Autocomplete hidden files
_comp_options+=(globdots)
source $HOME/dotfiles/zsh/external/completion.zsh

# Prompt
autoload -Uz prompt_purification_setup; prompt_purification_setup

# Vim-mode
bindkey -v
export KEYTIMEOUT=1
autoload -Uz cursor_mode && cursor_mode
zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# Keys
# localectl set-x11-keymap --no-convert us,ru pc105 "" "grp:win_space_toggle,caps:ctrl_modifier"

typeset -g -A key
key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
bindkey -- "${key[Home]}"       beginning-of-line
bindkey -M vicmd "${key[Home]}"       beginning-of-line
bindkey -- "${key[End]}"        end-of-line
bindkey -M vicmd "${key[End]}"        end-of-line

# Vim edit command
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Go back to directory
source $HOME/dotfiles/zsh/external/bd.zsh

# Load custom scripts
source $DOTFILES/zsh/scripts.sh

# Fuzzy finder
if [ $(command -v "fzf") ]; then
    source /usr/share/fzf/completion.zsh
    source /usr/share/fzf/key-bindings.zsh
    bindkey '\ed' fzf-cd-widget
    bindkey '^F' fzf-file-widget
fi

# Run X11
if [ "$(tty)" = "/dev/tty1" ];
then
    pgrep i3 || exec startx "$XDG_CONFIG_HOME/X11/.xinitrc"
fi

# Highlighting in the prompt
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

