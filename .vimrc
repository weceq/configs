""""""""""""""""""""""""""""
"" vundle -- package manager
""""""""""""""""""""""""""""

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
"Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
"Plugin 'L9'
" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Avoid a name conflict with L9
"Plugin 'user/L9', {'name': 'newL9'}

""" NERDTree
Plugin 'scrooloose/nerdtree'

""" Tagbar class outline viewer
Plugin 'majutsushi/tagbar'

""" ctrlp fuzzy file, buffer, mru, tag, ... finder for Vim.
Plugin 'ctrlpvim/ctrlp.vim'

""" auto-completion
Plugin 'valloric/youcompleteme'

""" tcomment plugin for managing comments
Plugin 'tomtom/tcomment_vim'

""" Plugins for org-mode
Plugin 'hsitz/VimOrganizer'
Plugin 'calendar.vim'
Plugin 'NrrwRgn'
Plugin 'utl.vim'

""" todo.txt
Plugin 'freitass/todo.txt-vim'

""" Solarized color theme
Plugin 'altercation/vim-colors-solarized'

""" Airline status bar
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

""" GIT integration
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'

""" Buffer statusline
Plugin 'bling/vim-bufferline'

""" Syntactic
Plugin 'scrooloose/syntastic'

""" Python
"Plugin 'klen/python-mode'

""" virtualenv
Plugin 'jmcantrell/vim-virtualenv'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

"""""""""""""""""""""""""""""
"" VimOrganizer
"""""""""""""""""""""""""""""

au! BufRead,BufWrite,BufWritePost,BufNewFile *.org
au BufEnter *.org call org#SetOrgFileType()



"""""""""""""""""""""""""""""
" General settings
"""""""""""""""""""""""""""""
set tabstop=4 shiftwidth=4 expandtab smarttab
syntax enable
set number
set laststatus=2
set autochdir
set autoread
set more
set cursorline

" Highlight search results
set nohlsearch
" Makes search act like search in modern browsers
set incsearch
" For regular expressions turn magic on
set magic
" Set very magic
nnoremap / /\v
vnoremap / /\v
cnoremap %s/ %smagic/
cnoremap \>s/ \>smagic/
nnoremap :g/ :g/\v
nnoremap :g// :g//

" Show matching brackets when text indicator is over them
set showmatch

" set wildmode=longest,list,full
set wildmenu

set background=dark
colorscheme solarized

""" Over 80 character highlight

" highlight OverLength ctermfg=darkred guifg=darkred
" match OverLength /\%81v.\+/
set colorcolumn=80

""" NERDTree
let NERDTreeShowHidden=1

""" ctrlp
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'

""" Tabline
let g:airline#extensions#tabline#enabled = 1

""" Syntactic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_python_checkers = ['python', 'pylint']
let g:syntastic_python_python_exec = 'python3'
"let g:syntastic_python_pylint_exec = 'python3 -m pylint'
"let g:syntastic_debug=32

""" python-mode
"let g:pymode_python = 'python3'

""" YouCompleteMe
let g:ycm_autoclose_preview_window_after_completion = 1

""""""""""""""""""""""""""
""" Shortcuts and bindings
""""""""""""""""""""""""""

""" Close buffer not the window
nmap ,d :b#<bar>bd#<CR>
nmap ,n :NERDTreeToggle<CR>
nmap ,t :TagbarToggle<CR>
nnoremap ,jd :YcmCompleter GoTo<CR>

