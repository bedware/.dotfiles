" Plugins
call plug#begin("$XDG_CONFIG_HOME/nvim/plugged")
    Plug 'chrisbra/csv.vim'
    Plug 'moll/vim-bbye'
    Plug 'simeji/winresizer'
    Plug 'junegunn/fzf.vim'
    Plug 'simnalamburt/vim-mundo'
call plug#end()

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

" Hidden
set hidden

" Mappings
nnoremap <space> <nop>
let mapleader = "\<space>"

" Buffers
nnoremap <leader>bn :bn<cr>
nnoremap <leader>bp :bp<cr>
nnoremap <leader>bx :Bdelete<cr>

" Tabs
nnoremap <leader>tN :tabe<cr>
nnoremap <leader>tx :tabc<cr>
nnoremap <leader>to :tabo<cr>

" Config for fzf.vim
nnoremap <leader>f :Files<cr>

" Plugins variables
let g:winresizer_start_key = "<leader>w"

" Config for chrisbra/csv.vim
augroup filetype_csv
    autocmd! 

    autocmd BufRead,BufWritePost *.csv :%ArrangeColumn!
    autocmd BufWritePre *.csv :%UnArrangeColumn
augroup END

