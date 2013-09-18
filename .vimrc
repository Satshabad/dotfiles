set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'

Bundle 'chrisbra/NrrwRgn'
vnoremap <leader>n :NarrowRegion<cr>

autocmd FileType python map <buffer> <F8> :call Flake8()<CR>
Bundle 'bitc/vim-bad-whitespace'

Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-unimpaired'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-commentary'

Bundle 'bling/vim-airline'
set laststatus=2
let g:airline_theme='dark'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '◀'
let g:airline_branch_prefix = '⎇ '
let g:airline_section_y = ""
let g:airline_section_x = ""

Bundle 'rking/ag.vim'
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'tomtom/tlib_vim'
Bundle 'godlygeek/tabular'
Bundle 'terryma/vim-multiple-cursors'
Bundle 'ervandew/supertab'

Bundle 'sjl/gundo.vim'
nnoremap <F7> :GundoToggle<CR>

Bundle 'kien/ctrlp.vim'
let g:ctrlp_map = '<c-f>'
let g:ctrlp_cmd = 'CtrlPMRU'
let g:ctrlp_extensions = ['tag']
let g:ctrlp_working_path_mode = "rc"

Bundle 'garbas/vim-snipmate'
Bundle 'hynek/vim-python-pep8-indent'

Bundle 'maksimr/vim-jsbeautify'
nnoremap <F6> :Tab/: <CR>
autocmd FileType javascript noremap <buffer> \fk :call JsBeautify() <cr>
nnoremap \fg :%g/"\([^\\"]\\|\\\(u\x\{4}\\|["trf\\bn\/]\)\)*"/:Tab/: <cr>
nmap \fj \fk\fg``<cr>
autocmd FileType html noremap <buffer> \fj :call HtmlBeautify()<cr>

Bundle 'airblade/vim-gitgutter'

Bundle 'Floobits/floobits-vim'
Bundle 'Townk/vim-autoclose'

Bundle 'majutsushi/tagbar'
nnoremap <F5> :Tagbar<CR>

" vim-scripts repos
Bundle 'vim-tags'

filetype plugin indent on     " required!


" set spell in commit messages
au BufNewFile,BufRead COMMIT_EDITMSG setlocal spell

set clipboard=unnamedplus

" better indent
set smartindent
set autoindent

set number

" for faster redrawing
set ttyfast

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

filetype plugin on

" to select autocomplete results with j/k
inoremap <expr> j ((pumvisible())?("\<C-n>"):("j"))
inoremap <expr> k ((pumvisible())?("\<C-p>"):("k"))

" to yank to end of line
map Y y$

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
vnoremap p "_dP

" to jump around more easily
nnoremap <space> %

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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FUNCTION STUFF
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" extract variable (sketchy)  (from gb)
function! ExtractVariable()
    let name = input("Variable name: ")
    if name == ''
        return
    endif
    " Enter visual mode (not sure why this is needed since we're already in
    " visual mode anyway)
    normal! gv

    " Replace selected text with the variable name
    exec "normal c" . name
    " Define the variable on the line above
    exec "normal! O" . name . " = "
    " Paste the original selected text to be the variable value
    normal! $p
endfunction
vnoremap <leader>e :call ExtractVariable()<cr>

" inline variable (sketchy)
function! InlineVariable()
    " Copy the variable under the cursor into the 'a' register
    :let l:tmp_a = @a
    :normal "ayiw
    " Delete variable and equals sign
    :normal 2daW
    " Delete the expression into the 'b' register
    :let l:tmp_b = @b
    :normal "bd$
    " Delete the remnants of the line
    :normal dd
    " Go to the end of the previous line so we can start our search for the
    " usage of the variable to replace. Doing '0' instead of 'k$' doesn't
    " work; I'm not sure why.
    normal k$
    " Find the next occurence of the variable
    exec '/\<' . @a . '\>'
    " Replace that occurence with the text we yanked
    exec ':.s/\<' . @a . '\>/' . @b
    :let @a = l:tmp_a
    :let @b = l:tmp_b
endfunction
nnoremap <leader>i :call InlineVariable()<cr>


" Start editing the vimrc in a new buffer
nnoremap <leader>v :call Edit_vimrc()<CR>
function! Edit_vimrc()
    exe 'edit ' . '~/.vimrc'
endfunction

" toggle spell checking
nnoremap <silent> <leader>s :set spell!<CR>

" run test that i'm currently editing
function! CreateTestString()

    normal ma
    normal ?def
w"dyiw
    normal ?class
w"cyiw
    normal 'a
    return @% . ":" . @c  . "." . @d

endfunction

" auto format the file
vnoremap <leader>8 :! autopep8 - -a<cr>

nmap <Space><Space>  :w\|!make test <CR>
nmap s<Space>  :execute ' :w\|!make test SINGLETEST="' .  CreateTestString() . '"' <CR>

" for gitgutter
highlight clear SignColumn
