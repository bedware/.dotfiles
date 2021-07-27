" Use OS clipboard in Neovim
set clipboard+=unnamedplus

" Disable arrow keys
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" No swap file
set noswapfile

" Save undo-trees in files
set undofile
set undodir=$HOME/.config/nvim/undo

" Set number of undo saved
set undolevels=5000
set undoreload=5000

" Set line number
set number
set relativenumber

" Indent
set autoindent
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
