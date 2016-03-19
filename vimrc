"===============================================================================
" Message from...
" * http://phuzz.org/vimrc.html
" * http://www.vim.org/scripts/script_search_results.php
"===============================================================================
set ls=2            " always show status line
set tabstop=4       " numbers of spaces of tab character
set shiftwidth=4    " numbers of spaces to (auto)indent
set scrolloff=3     " keep 3 lines when scrolling
set nostartofline   " don't jump to first character when paging
set ruler           " show current row and column numbers
set backspace=2     " make backspace work like most other apps
set statusline+=%F  " Add full file path to your existing statusline
set nu              " Set line number

" Indentation settings
"set expandtab       " tabs are converted to spaces, use only when required
"set autoindent      " always set autoindenting on
"set smartindent     " smart indent
"set cindent         " cindent
set noautoindent
set nosmartindent
set nocindent

" Disable beep, and show visual beep instead
set noerrorbells visualbell t_vb=

" Syntax highlight setting
" colorscheme list are in "/usr/share/vim/vim*/colors"
syntax on            " syntax highlighing
colorscheme evening  " vim color scheme
"autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Set status line
" http://archive09.linux.com/feature/120126
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L] 
set laststatus=2

" Browse compressed files automatically
" http://vim.1045645.n5.nabble.com/How-to-vim-a-class-file-in-a-jar-file-with-the-java-decompiler-executed-td1151967.html
au BufReadCmd *.jar,*.ear,*.war call zip#Browse(expand("<amatch>"))
