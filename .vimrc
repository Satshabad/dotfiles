call pathogen#infect()

if !exists("autocommands_loaded")
  let autocommands_loaded = 1
  autocmd bufread,BufNewFile,FileReadPost *.txt set spell
endif

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

" searching using only lowercase ignores case
set ignorecase
set smartcase

" instant search and keep search highlighted
set incsearch
set hlsearch
nnoremap <cr> :noh<cr>

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

" make paragraphs more consistent with words
nmap di<c-j> dip
nmap da<c-j> dap

nmap yi<c-j> yip
nmap ya<c-j> yap

nmap vi<c-j> vip
nmap va<c-j> vap


filetype plugin on

" to select autocomplete results
inoremap <expr> j ((pumvisible())?("\<C-n>"):("j"))
inoremap <expr> k ((pumvisible())?("\<C-p>"):("k"))

" to yank to end of line
map Y y$

set scrolloff=8 

" http://codingfearlessly.com/2012/08/21/vim-putting-arrows-to-use/
nmap <Up> ]<Space>
nmap <Down> [<Space>
vmap <Up> [egv
vmap <Down> ]egv
nmap <Left> <<
nmap <Right> >>
vmap <Left> <<
vmap <Right> >>
vmap <Up> [egv
vmap <Down> ]egv

" so that x and paste in vis doesn't update reg.
noremap x "_x
vnoremap p "_dP

" to jump around more
nnoremap <space> %

hi CursorLine     guifg=Blue        guibg=Red     gui=NONE      ctermfg=NONE        ctermbg=234
set cursorline
colorscheme jellybeans 


set guioptions-=r  " no scrollbar on the right
set guioptions-=l  " no scrollbar on the left
set guioptions-=m  " no menu
set guioptions-=T  " no toolbar

map <C-O> :exe "!wmctrl -r ".v:servername." -b toggle,fullscreen"


" so that surrounds behaves more like a command
map s ys


" so that only yank writes to default buffer, c has its own
nnoremap c "cc
vnoremap c "cc

set backup
set swapfile

"for gitgutter
highlight clear SignColumn


" Next and Last {{{

" Motion for "next/last object". For example, "din(" would go to the next "()" pair
" and delete its contents.

onoremap an :<c-u>call <SID>NextTextObject('a', 'f')<cr>
xnoremap an :<c-u>call <SID>NextTextObject('a', 'f')<cr>
onoremap in :<c-u>call <SID>NextTextObject('i', 'f')<cr>
xnoremap in :<c-u>call <SID>NextTextObject('i', 'f')<cr>

onoremap al :<c-u>call <SID>NextTextObject('a', 'F')<cr>
xnoremap al :<c-u>call <SID>NextTextObject('a', 'F')<cr>
onoremap il :<c-u>call <SID>NextTextObject('i', 'F')<cr>
xnoremap il :<c-u>call <SID>NextTextObject('i', 'F')<cr>

function! s:NextTextObject(motion, dir)
    let c = nr2char(getchar())
    let d = ''

    if c ==# "b" || c ==# "(" || c ==# ")"
        let c = "("
    elseif c ==# "B" || c ==# "{" || c ==# "}"
        let c = "{"
    elseif c ==# "r" || c ==# "[" || c ==# "]"
        let c = "["
    elseif c ==# "'"
        let c = "'"
    elseif c ==# '"'
        let c = '"'
    else
        return
    endif

" Find the next opening-whatever.
    execute "normal! " . a:dir . c . "\<cr>"

    if a:motion ==# 'a'
" If we're doing an 'around' method, we just need to select around it
" and we can bail out to Vim.
        execute "normal! va" . c
    else
" Otherwise we're looking at an 'inside' motion. Unfortunately these
" get tricky when you're dealing with an empty set of delimiters because
" Vim does the wrong thing when you say vi(.

        let open = ''
        let close = ''

        if c ==# "("
            let open = "("
            let close = ")"
        elseif c ==# "{"
            let open = "{"
            let close = "}"
        elseif c ==# "["
            let open = "\\["
            let close = "\\]"
        elseif c ==# "'"
            let open = "'"
            let close = "'"
        elseif c ==# '"'
            let open = '"'
            let close = '"'
        endif

" We'll start at the current delimiter.
        let start_pos = getpos('.')
        let start_l = start_pos[1]
        let start_c = start_pos[2]

" Then we'll find it's matching end delimiter.
        if c ==# "'" || c ==# '"'
" searchpairpos() doesn't work for quotes, because fuck me.
            let end_pos = searchpos(open)
        else
            let end_pos = searchpairpos(open, '', close)
        endif

        let end_l = end_pos[0]
        let end_c = end_pos[1]

        call setpos('.', start_pos)

        if start_l == end_l && start_c == (end_c - 1)
" We're in an empty set of delimiters. We'll append an "x"
" character and select that so most Vim commands will do something
" sane. v is gonna be weird, and so is y. Oh well.
            execute "normal! ax\<esc>\<left>"
            execute "normal! vi" . c
        elseif start_l == end_l && start_c == (end_c - 2)
" We're on a set of delimiters that contain a single, non-newline
" character. We can just select that and we're done.
            execute "normal! vi" . c
        else
" Otherwise these delimiters contain something. But we're still not
" sure Vim's gonna work, because if they contain nothing but
" newlines Vim still does the wrong thing. So we'll manually select
" the guts ourselves.
            let whichwrap = &whichwrap
            set whichwrap+=h,l

            execute "normal! va" . c . "hol"

            let &whichwrap = whichwrap
        endif
    endif
endfunction

" }}}
" }}}

nnoremap <F6> :GundoToggle<CR>

" Autoformatjs stuff
nnoremap <F6> :Tab/: <CR>
autocmd FileType javascript noremap <buffer> \fk :call JsBeautify() <cr>
nnoremap \fg :%g/"\([^\\"]\\|\\\(u\x\{4}\\|["trf\\bn\/]\)\)*"/:Tab/: <cr>
nmap \fj \fk\fg``<cr>


let g:netrw_list_hide="\\(^\\|\\s\\s\\)\\zs\\.\\S\\+" 

" for ctrlp fuzzy search
let g:ctrlp_map = '<c-f>'
let g:ctrlp_cmd = 'CtrlPMRU'
let g:ctrlp_extensions = ['tag']

function! CreateTestString()

    normal ma
    normal ?defw"dyiw
    normal ?classw"cyiw
    normal 'a
    return @% . ":" . @c  . "." . @d

endfunction

nmap <Space><Space>  :w\|!make test <CR>

nmap s<Space>  :execute ' :w\|!make test SINGLETEST="' .  CreateTestString() . '"' <CR>

set laststatus=2
let g:airline_theme='dark'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '◀'
let g:airline_branch_prefix = '⎇ '

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" EXTRACT VARIABLE (SKETCHY)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INLINE VARIABLE (SKETCHY)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
