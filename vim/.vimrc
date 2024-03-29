filetype plugin on

call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'mattn/emmet-vim'
Plug 'raimondi/delimitmate'
Plug 'bronson/vim-trailing-whitespace'
Plug 'honza/vim-snippets'
Plug 'ervandew/supertab'
Plug 'mhinz/vim-signify'
Plug 'kien/ctrlp.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'nightsense/vimspectr'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'editorconfig/editorconfig-vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'dart-lang/dart-vim-plugin'
Plug 'arcticicestudio/nord-vim'
call plug#end()

" Colors
syntax on
colorscheme nord
let g:airline_powerline_fonts=1

" Misc
set nu
set swapfile
set dir=/tmp
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
map <C-a> GVgg
map <C-w> :q <Enter>
map <C-p> <Esc>:find

" Replace word
nmap <C-d> cgn

" Tab control
nnoremap <C-t> :sp<CR>
nnoremap <C-n> :tabnew<CR>
" <C-tab>
nnoremap <C-I> :tabnext<CR>

" Indent Guides
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_guide_size=1
let g:indent_guides_auto_colors = 0

" " Multi cursor
" let g:multi_cursor_use_default_mapping=-2
" let g:multi_cursor_next_key='<C-d>'
" let g:multi_cursor_prev_key='<C-n>'
" let g:multi_cursor_skip_key='<C-x>'
" let g:multi_cursor_quit_key='<Esc>'

" NerdTree
let NERDTreeShowHidden=1
map <C-e> :NERDTreeToggle<CR>

" NerdCommenter
let g:NERDSpaceDelims = 1
" <C-/>
noremap <C-_> :call NERDComment(0,"toggle")<CR>

" CTRL P
let g:ctrlp_show_hidden=1

" Emmet
let g:user_emmet_leader_key=','

" Vim-jsx
let g:jsx_ext_required = 0

function Convert4SpacesTo2 ()
    :set ts=4 sts=4 noet
    :retab!
    :set ts=2 sts=2 et
    :retab
endfunction

function Convert2SpacesTo4 ()
    :set ts=2 sts=2 noet
    :retab!
    :set ts=4 sts=4 et
    :retab
endfunction
