set nocompatible               " be iMproved
filetype off                   " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'bitc/vim-bad-whitespace'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-commentary'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'Vimjas/vim-python-pep8-indent'
Plugin 'airblade/vim-gitgutter'
Plugin 'junegunn/vim-peekaboo'
Plugin 'alvan/vim-closetag'
Plugin 'tpope/vim-sleuth'
Plugin 'wincent/terminus'
Plugin 'tmhedberg/SimpylFold'
Plugin 'majutsushi/tagbar'
Plugin 'jparise/vim-graphql'
Plugin 'peitalin/vim-jsx-typescript'
Plugin 'ludovicchabant/vim-gutentags'

let g:gutentags_ctags_exclude = ["node_modules"]
let g:gutentags_enabled = 0
augroup auto_gutentags
  au FileType python,typescript let g:gutentags_enabled = 1
augroup end



Plugin 'maxbrunsfeld/vim-yankstack'
nmap <C-p> <Plug>yankstack_substitute_older_paste
let g:yankstack_map_keys = 0

" This needs to come after Yankstack see  https://github.com/maxbrunsfeld/vim-yankstack/issues/9
Plugin 'tpope/vim-surround'

Plugin 'Konfekt/FastFold'
set foldlevelstart=99

Plugin 'Townk/vim-autoclose'
let g:AutoClosePumvisible = {"ENTER": "<C-Y>", "ESC": "<ESC>"}

Plugin 'ervandew/supertab'
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabContextDefaultCompletionType = "<c-n>"

Plugin 'MilesCranmer/gso'
nnoremap <C-s> :GSO

Plugin 'vim-syntastic/syntastic' " Install flake8
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_html_checkers=['tidy']
" Couldn't get this working
" let g:syntastic_htmldjango_checkers = ['html/tidy']
" let g:syntastic_html_tidy_args="--show-body-only yes --quiet yes -i=2 -w 80"
" let g:syntastic_htmldjango_tidy_args="--show-body-only yes --quiet yes -i=2 -w 80"
" let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute " ,"trimming empty <", "unescaped &" , "lacks \"action", "is not recognized!", "discarding unexpected"]
let g:syntastic_quiet_messages = { 'regex': 'W504'}
let g:syntastic_always_populate_loc_list = 1

Plugin 'elzr/vim-json'
nmap <leader>jq :%!jq "."<CR><CR>

" lisp plugins
Plugin 'paredit.vim'
Plugin 'tpope/vim-fireplace'
Plugin 'tpope/vim-classpath'
Plugin 'guns/vim-clojure-static'
Plugin 'guns/vim-clojure-highlight'
let g:clojure_align_multiline_strings = 1
Plugin 'fwolanski/vim-clojure-conceal'
nmap cpP :Eval <CR>
Bundle 'luochen1990/rainbow'
let g:rainbow_active = 1

Bundle 'terryma/vim-expand-region'
map <C-e> <Plug>(expand_region_expand)
map <C-d> <Plug>(expand_region_shrink)

Plugin 'mbbill/undotree'
nnoremap <leader>u :UndotreeToggle<CR>
let g:undotree_SetFocusWhenToggle = 1

set undodir=~/.undodir/
set undofile

Plugin 'bling/vim-airline'
set laststatus=2
let g:airline_theme='dark'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '◀'
let g:airline_branch_prefix = '⎇ '
let g:airline_section_y = ""
let g:airline#extensions#branch#enabled = 0
let g:airline#extensions#hunks#enabled = 0
let g:airline#extensions#tagbar#flags = 'f'

Plugin 'mileszs/ack.vim'
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" All of your Plugins must be added before the following line
call vundle#end()            " required

" order matters
call yankstack#setup()

call plug#begin()

Plug 'junegunn/vim-easy-align'
xmap ga <Plug>(EasyAlign)

Plug 'sbdchd/neoformat'
let g:neoformat_enabled_python = ['yapf']
let g:neoformat_try_formatprg = 1

augroup fmt
  autocmd!
  autocmd BufWritePre *.py undojoin | Neoformat
augroup END

if has('nvim')
  Plug 'HerringtonDarkholme/yats.vim'
  Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1
let g:nvim_typescript#default_mappings = 1

Plug 'zchee/deoplete-jedi'

augroup omnifuncs
  autocmd!
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
augroup end

Plug 'Shougo/echodoc.vim'
let g:echodoc#enable_at_startup = 1

Plug 'iberianpig/tig-explorer.vim'
Plug 'rbgrouleff/bclose.vim'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
nnoremap <leader>a :Ag<CR>
let $FZF_DEFAULT_COMMAND = 'ag -g ""'

" So that you can cycle through the commands
function! s:fzf_next(idx)
  let commands = ['History', 'Files', 'Tags', 'BLines']
  execute commands[a:idx]
  let next = (a:idx + 1) % len(commands)
  execute 'tnoremap <buffer> <silent> <c-f> <c-\><c-n>:close<cr>:sleep 100m<cr>:call <sid>fzf_next('.next.')<cr>'
endfunction

command! Cycle call <sid>fzf_next(0)
nmap <C-f> :Cycle <CR>


" open tig with current file
nnoremap <Leader>T :TigOpenCurrentFile<CR>

" open tig with Project root path
nnoremap <Leader>t :TigOpenProjectRootDir<CR>

call plug#end()


" two spaces for some reason
autocmd FileType python setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2

function! UndoIfShellError()
    if v:shell_error
        undo
    endif
endfunc

" Format the file and save the position of the cursor
function! SafeFormat()
    let s:pos = getpos( '. ')
    let s:view = winsaveview()
    0,$!yapf
    call UndoIfShellError()
    call setpos( '.', s:pos )
    call winrestview( s:view )
endfunc

" Auto format python
"
" autocmd BufWritePre *.py :call SafeFormat()
filetype plugin indent on    " required

" set spell in commit messages
au BufNewFile,BufRead COMMIT_EDITMSG setlocal spell

set clipboard+=unnamedplus

" remove trailing whitespace for clj files
autocmd BufWritePre *.clj :%s/\s\+$//e

set number

" for faster redrawing
set ttyfast
set lazyredraw

" fix tabs
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

set scrolloff=8

" searching using only lowercase ignores case
set ignorecase
set smartcase

" instant search and keep search highlighted
set incsearch
set hlsearch

" insert the very magic reg-ex mode every time
nnoremap / /\v
nnoremap ? ?\v
nnoremap <leader><leader> :noh<cr>

" plus and minus should be just that
noremap - <C-x>
map + <C-a>

" make it easier to cycle through change spots
nmap ; g;
nmap , g,

" jump paragraphs with these
nmap <c-j> }
nmap <c-k> {
nmap d<c-j> d}
nmap d<c-k> d{

vnoremap <c-j> }
vnoremap <c-k> {

" make paragraphs more consistent with objects
nmap di<c-j> dip
nmap da<c-j> dap

nmap yi<c-j> yip
nmap ya<c-j> yap

nmap vi<c-j> vip
nmap va<c-j> vap


" to select autocomplete results with j/k
" NOTE: this gets bothersome
" inoremap <expr> j ((pumvisible())?("\<C-n>"):("j"))
" inoremap <expr> k ((pumvisible())?("\<C-p>"):("k"))

" Enter to select from menu
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

set cmdheight=2

set complete-=i
set completeopt-=preview

" to yank to end of line
noremap Y y$

" so that surrounds behaves more like a command
map s ys

" hide hidden files when browsing dir
let g:netrw_list_hide="\\(^\\|\\s\\s\\)\\zs\\.\\S\\+"

nmap <silent> <Up> :wincmd k<CR>
nmap <silent> <Down> :wincmd j<CR>
nmap <silent> <Left> :wincmd h<CR>
nmap <silent> <Right> :wincmd l<CR>


nnoremap <silent> <Up> <NOP>
nnoremap <silent> <Down> <NOP>
nnoremap <silent> <Left> <NOP>
nnoremap <silent> <Right> <NOP>

" Move between editor lines (instead of actual lines)
vnoremap j gj
vnoremap k gk
vnoremap $ g$
vnoremap ^ g^
vnoremap 0 g0
nnoremap j gj
nnoremap k gk
nnoremap $ g$
nnoremap ^ g^
nnoremap 0 g0

" so that x and paste in vis doesn't update reg.
noremap x "_x
vnoremap p "_xP

" to jump around more easily
nmap <space> %
vmap <space> %

" visual stuff
hi CursorLine     guifg=Blue        guibg=Red     gui=NONE      ctermfg=NONE        ctermbg=234
set cursorline
colorscheme jellybeans

set guioptions-=r  " no scrollbar on the right
set guioptions-=l  " no scrollbar on the left
set guioptions-=m  " no menu
set guioptions-=T  " no toolbar

" so that only yank writes to default buffer, c has its own buffer
nnoremap c "cc
vnoremap c "cc

" Start editing the vimrc in a new buffer
nnoremap <leader>v :call Edit_vimrc()<CR>
function! Edit_vimrc()
    exe 'edit ' . '~/.vimrc'
endfunction

" Start editing the zshrc in a new buffer
nnoremap <leader>z :call Edit_zshrc()<CR>
function! Edit_zshrc()
    exe 'edit ' . '~/.zshrc'
endfunction

" toggle spell checking
nnoremap <silent> <leader>s :set spell!<CR>

" auto format the file
vnoremap <leader>8 :! autopep8 - -a<cr>

" for gitgutter
highlight clear SignColumn

" Close all tabs but this one
nmap <C-Enter> :only<CR>

" Disable Q and the dreaded Ex mode.
nnoremap Q <nop>

" so that dash-case words are words not WORDS
set iskeyword+=-

" remember last location in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif

" find/replace in a visually selected block
vmap <leader>r :s/\%V
