call plug#begin('~/.vim/plugged')
Plug 'dikiaap/minimalist',
Plug 'tpope/vim-sensible',
Plug 'sentientmachine/Pretty-Vim-Python'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'JuliaEditorSupport/julia-vim'
Plug 'cespare/vim-toml'
Plug 'haystackandroid/snow'
call plug#end()

set number
set ttyfast
set showmode
set title
set hidden

set nobackup
set nowritebackup
set nowb
set noswapfile
set undolevels=1000

set tabstop=2 expandtab shiftwidth=2 smarttab softtabstop=2

set list
set listchars=tab:→\ ,trail:·,nbsp:·

autocmd Filetype julia setlocal tabstop=4 expandtab shiftwidth=4 smarttab softtabstop=4
autocmd Filetype python setlocal tabstop=4 expandtab shiftwidth=4 smarttab softtabstop=4
autocmd Filetype coconut setlocal tabstop=4 expandtab shiftwidth=4 smarttab softtabstop=4
autocmd Filetype make setlocal noexpandtab
set autoindent
syntax on
let g:rehash256 = 1
let g:molokai_original = 1
set t_Co=256
set background=dark
colorscheme snow
" colorscheme monokai
highlight Comment cterm=bold
set cc=80

let g:go_fmt_command = "goimports"

let g:lisp_rainbow = 1
