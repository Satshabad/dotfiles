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
Plugin 'ervandew/supertab'
Plugin 'Vimjas/vim-python-pep8-indent'
Plugin 'airblade/vim-gitgutter'
Plugin 'Townk/vim-autoclose'
Plugin 'tpope/vim-surround'
Plugin 'vim-tags'
Plugin 'junegunn/vim-peekaboo'
Plugin 'alvan/vim-closetag'


Plugin 'vim-syntastic/syntastic' " Install flake8
let g:syntastic_python_checkers = ['flake8']

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

Plugin 'kien/ctrlp.vim'
let g:ctrlp_map = '<c-f>'
let g:ctrlp_cmd = 'CtrlPMRU'
let g:ctrlp_working_path_mode = "rc"

Plugin 'bling/vim-airline'
set laststatus=2
let g:airline_theme='dark'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '◀'
let g:airline_branch_prefix = '⎇ '
let g:airline_section_y = ""
let g:airline_section_x = ""

Plugin 'mileszs/ack.vim'
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" Trailing space is significant
nnoremap <leader>a :Ack 

" All of your Plugins must be added before the following line
call vundle#end()            " required
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
autocmd BufWritePre *.py :call SafeFormat()
filetype plugin indent on    " required

" set spell in commit messages
au BufNewFile,BufRead COMMIT_EDITMSG setlocal spell

" make sure you have vim-gtk
set clipboard=unnamedplus

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


" " to select autocomplete results with j/k
inoremap <expr> j ((pumvisible())?("\<C-n>"):("j"))
inoremap <expr> k ((pumvisible())?("\<C-p>"):("k"))
set complete-=i

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
set iskeyword+='-'
