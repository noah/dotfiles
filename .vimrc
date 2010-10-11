""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Make vim less vi-compatible
set nocompatible
" ask for confirmation on overwrite, discard changes, etc
set confirm
" enable mouse for [a]ll modes
set mouse=a
" the name of the printer device used for :hardcopy
set pdev=bjork

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Indentation
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" smart indenting for new lines
set smartindent
" number of spaces that a tab counts for
set tabstop=4
" Copy indent from current line when starting a new line
set autoindent
" number of spaces to use for each step of autoindent
set shiftwidth=4
" In Insert mode: Use the appropriate number of spaces to insert a <Tab>
set expandtab

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Display
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" use 256 terminal colors
set t_Co=256
" background color
set background=dark
" colorscheme
colorscheme lettuce
" colorscheme inkpot
" show (partial) command in the last line of the screen
set showcmd
" show the line and column number of the cursor position, separated by a comma
set ruler
" always show line numbers
set number      
" set background=light
" font
set guifont=Liberation\ Mono\ 8
" window title
set title

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Completion
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" enhanced CLI completion
set wildmenu
" completion style:  complete first full match, next match, etc.
set wildmode=list:full

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Wrapping
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Maximum width of text that is being inserted
set textwidth=70
" Number of characters from the right window border where wrapping starts
set wrapmargin=70

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Splits
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Split windows correctly
set splitright
set splitbelow

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Folding
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set foldmethod=syntax

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" toggle spelling with F7 map <F7> :setlocal spell! spelllang=en_us<CR>
" toggle line numbers with F12
map <F12> :set number!<CR>

" turn on syntax highlighting
syntax enable
" turn on detection, plugin, and indent
filetype plugin indent on
" grow/shrink horizontal split windows with plus/minus keys
if bufwinnr(1)
    map + <C-W>+
    map - <C-W>-
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" always open NERDTree explorer
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" always show command line 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap : q:i
nnoremap / q/i
nnoremap ? q?i
