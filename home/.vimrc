if empty(glob('~/.vim/autoload/plug.vim'))
      silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
          \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif

set nocompatible
filetype on
filetype plugin indent on
let mapleader = ','
map <leader>Q :q! <return>
map <leader>W :w !SUDO_ASKPASS=/usr/lib/ssh/x11-ssh-askpass sudo -A tee % > /dev/null<return>
map <leader>q :q <return>
map <leader>w :w <return>
nnoremap <C-H> <C-W><C-H>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> :nohl<CR><C-L>
nnoremap <C-L> <C-W><C-L>
nnoremap <silent><expr> <Leader>h (&hls && v:hlsearch ? ':nohls' : ':set hls')."\n"
set autoindent
set backspace=indent,eol,start	
set colorcolumn=100
set expandtab
set hlsearch
set ignorecase
set incsearch
set linebreak
"set mouse=a
set nobackup
set noswapfile
set nottimeout
set pastetoggle=<C-B>
set relativenumber
set ruler
set shiftwidth=2
set showmatch
set smartcase
set smartindent
set softtabstop=2
set splitbelow
set splitright
set tabstop=2
set title
set undodir=$HOME/.vim/undo
set undofile
set undolevels=1000
set undoreload=10000
set visualbell
set wildmenu
syntax on
vnoremap <leader>s :sort<return>
let g:airline#extensions#tabline#enabled = 1
"set hidden

nnoremap <C-N> :bnext<CR>
nnoremap <C-M> :bprev<CR>
nnoremap <Leader>d :bdelete<CR>
nnoremap <Leader>D :bdelete!<CR>

"==================== NerdTree ====================
" For toggling
let NERDTreeShowHidden=1
noremap - :NERDTreeFind<cr>
"let NERDTreeQuitOnOpen = 1
let NERDTreeMinimalUI = 1
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '\#',
    \ "Unknown"   : "?"
    \ }
let g:NERDTreeShowIgnoredStatus = 1
au VimEnter *  NERDTreeFind | wincmd p
autocmd StdinReadPre * let s:std_in=1
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeDirArrows = 1

" Close nerdtree and vim on close file
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"=============================================
call plug#begin()
"if has('nvim')
  "Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"else
  "Plug 'Shougo/deoplete.nvim'
  "Plug 'roxma/nvim-yarp'
  "Plug 'roxma/vim-hug-neovim-rpc'
"endif
"Plug 'Shougo/neosnippet-snippets'
"Plug 'Shougo/neosnippet.vim'
"Plug 'Valloric/YouCompleteMe'
"Plug 'avakhov/vim-yaml'
"Plug 'ctrlpvim/ctrlp.vim'
"Plug 'ervandew/supertab'
"Plug 'juliosueiras/vim-terraform-completion'
"Plug 'majutsushi/tagbar'
"Plug 'msanders/snipmate.vim'
"Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
"Plug 'scrooloose/syntastic'
"Plug 'tpope/vim-vinegar'
"Plug 'vim-syntastic/syntastic'
"Plug 'zchee/deoplete-go', { 'do': 'make'}
"let g:deoplete#enable_at_startup = 1
Plug 'junegunn/gv.vim'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': './install.sh'
    \ }
Plug 'danilamihailov/beacon.nvim'
Plug 'Chiel92/vim-autoformat'
Plug 'NLKNguyen/papercolor-theme'
Plug 'Raimondi/delimitMate'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'terryma/vim-multiple-cursors'
Plug 'tc50cal/vim-terminal'
Plug 'airblade/vim-gitgutter'
Plug 'benmills/vimux'
Plug 'christianrondeau/vim-base64'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'hashivim/vim-terraform'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }}
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-startify'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'towolf/vim-helm'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tsandall/vim-rego'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-notes'
Plug 'yggdroot/indentline'
call plug#end()

set background=dark
colorscheme PaperColor

let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:deoplete#enable_at_startup = 1
"set rtp+=~/.fzf
set list
let g:indentLine_enabled = 1
set foldmethod=indent
set foldlevelstart=20
let g:diminactive_use_syntax = 1
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
nmap <leader>t :TagbarToggle<CR>

"speedup Ctrl-P on git projects
let g:ctrlp_use_caching = 0
if executable('ag')
    set grepprg=ag\ --nogroup\ --nocolor

    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
else 
  let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
  let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("e")': ['<space>', '<cr>', '<2-LeftMouse>'],
    \ }
endif

let g:notes_directories = ['~/Synced/VimNotes']
"prettier configuration
"let g:prettier#autoformat = 0
"autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html Prettier


" fzf
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>f :Files<CR>
nnoremap <leader>a :Ag<CR>
nnoremap <leader>h :History<CR>
nnoremap <Leader>l :BLines<CR>
nnoremap <Leader>L :Lines<CR>
nnoremap <Leader>C :Commands<CR>


" vim-go
let g:go_fmt_command = "goimports"
let g:go_autodetect_gopath = 1
let g:go_list_type = "quickfix"

let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_generate_tags = 1
"command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)
au BufNewFile,BufRead Jenkinsfile setf groovy


" -------------------------------------------------------------------------------------------------
" coc.nvim default settings
" -------------------------------------------------------------------------------------------------

let g:coc_global_extensions = ['coc-yaml', 'coc-json']
" if hidden is not set, TextEdit might fail.
set hidden
" Better display for messages
set cmdheight=2
" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300
" don't give |ins-completion-menu| messages.
set shortmess+=c
" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use U to show documentation in preview window
nnoremap <silent> U :call <SID>show_documentation()<CR>

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
"vmap <leader>f  <Plug>(coc-format-selected)
"nmap <leader>f  <Plug>(coc-format-selected)
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" disable vim-go :GoDef short cut (gd)
" this is handled by LanguageClient [LC]
let g:go_def_mapping_enabled = 0
let g:go_term_enabled = 1
"let g:go_metalinter_autosave = 1
"let g:go_metalinter_autosave_enabled = ['vet', 'golint']

"" terraform settings
let g:terraform_align=1
let g:terraform_fold_sections=1
let g:terraform_remap_spacebar=1
let g:terraform_commentstring='//%s'
let g:terraform_fmt_on_save=1


""""" REGO
let g:formatdef_rego = '"opa fmt"'
let g:formatters_rego = ['rego']
let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
au BufWritePre *.rego Autoformat

""" https://github.com/DanilaMihailov/beacon.nvim
"let g:beacon_size = 80

""" https://github.com/Yggdroot/indentLine
""" disable conceal for yaml and json to have double quotes back.
let g:vim_json_conceal=0
let g:markdown_syntax_conceal=0
