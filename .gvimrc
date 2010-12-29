colorscheme wombat256
set nocompatible
set tabstop=4
set shiftwidth=4
set expandtab
set showcmd
set ruler
set number
set confirm
set fileformats=unix 
set background=dark
set guifont=Liberation\ Mono\ 8
:imap <F7> <C-o>:setlocal spell! spelllang=en_us<CR>
set autoindent
set smartindent
set mouse=a
set pdev=bjork
set wildmenu
set wildmode=list:longest
set title
set wildmenu
set wildmode=list:longest,full
syntax on
filetype plugin indent on
filetype indent on    " Enable filetype-specific indenting
filetype on           " Enable filetype detection

noremap <S-Insert> "+gP
inoremap <S-Insert> <ESC>"+gP
