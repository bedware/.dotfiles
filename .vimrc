" Remap leader
let mapleader = " "

" Plugins
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-surround'
call plug#end()

" My settings
colorscheme peachpuff

" Some basics
filetype plugin indent on
syntax on
set encoding=utf-8
set clipboard^=unnamed,unnamedplus
set number
set relativenumber
set hlsearch
set softtabstop=2
set shiftwidth=2
set showcmd " display incomplete commands
set ruler
set et
set title

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowritebackup
set nowb
set noswapfile

" Miscellaneous
nmap <silent> // :nohlsearch<CR>
nnoremap <leader>f :normal! gg=G``<CR> " format the entire file

