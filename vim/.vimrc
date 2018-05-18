filetype indent on
filetype plugin on

call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'mattn/emmet-vim'
Plug 'raimondi/delimitmate'
Plug 'bronson/vim-trailing-whitespace'
Plug 'honza/vim-snippets'
Plug 'sirver/ultisnips'
Plug 'ervandew/supertab'
Plug 'mhinz/vim-signify'
Plug 'terryma/vim-multiple-cursors'
Plug 'kien/ctrlp.vim'
Plug 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}
Plug 'christoomey/vim-tmux-navigator'
Plug 'nightsense/vimspectr'
call plug#end()

" Colors
syntax on
colorscheme monokai

" Misc
set nu
set swapfile
set dir=~/.tmp
set ttyfast
set backspace=indent,eol,start
set clipboard=unnamedplus
set splitbelow
set splitright
set autoindent
set smartindent
set mouse=a
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set modelines=1
set cursorline
set showmatch
set lazyredraw
set path+=**
set ignorecase
set incsearch
set nohlsearch
set wildmenu
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/.git/*,*/.hg/*,*/vendor/*,*/bower_components/*,*/node_modules/*,*/proxies/*
let mapleader=","

" Shortcuts
map <C-e> :NERDTreeToggle<CR>
map <C-a> GVgg
map <C-z> u
map <C-w> :close <Enter>
map <C-f> /
map <C-p> <Esc>:find
map <F3> n

" Tab control
nnoremap <C-t> :sp<CR>
inoremap <C-t> <Esc>:sp<CR>

" Multi cursor
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_next_key='<C-d>'
let g:multi_cursor_prev_key='<C-n>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

" NerdTree
let NERDTreeShowHidden=1

" CTRL P
let g:ctrlp_show_hidden=1

" Emmet
let g:user_emmet_leader_key=','

" Powerline
set laststatus=2
