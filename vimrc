set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

" My Bundles:
"
" github
Bundle 'guns/vim-clojure-static'
Bundle 'kien/rainbow_parentheses.vim'
Bundle 'tpope/vim-fireplace'
Bundle 'derekwyatt/vim-scala'
Bundle 'Shougo/neocomplcache'

filetype plugin indent on

set number
set tabstop=4 expandtab
set autoindent
syntax on
