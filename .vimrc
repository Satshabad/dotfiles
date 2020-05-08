set nocompatible               " be iMproved
filetype off                   " required
" Point YCM to the Pipenv created virtualenv, if possible
" At first, get the output of 'pipenv --venv' command.
let pipenv_venv_path = system('pipenv --venv')
" The above system() call produces a non zero exit code whenever
" a proper virtual environment has not been found.
" So, second, we only point YCM to the virtual environment when
" the call to 'pipenv --venv' was successful.
" Remember, that 'pipenv --venv' only points to the root directory
" of the virtual environment, so we have to append a full path to
" the python executable.
if v:shell_error == 0
  let venv_path = substitute(pipenv_venv_path, '\n', '', '')
  let g:ycm_python_binary_path = venv_path . '/bin/python'
  let isort_path = venv_path . '/bin/isort'
else
  let g:ycm_python_binary_path = 'python'
  let isort_path = 'isort'
endif
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()


" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
" Plugin 'airblade/vim-rooter'
Plugin 'bitc/vim-bad-whitespace'
Plugin 'tpope/vim-fugitive'
Plugin 'christoomey/vim-conflicted'
set stl+=%{ConflictedVersion()}
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-commentary'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'Vimjas/vim-python-pep8-indent'
Plugin 'airblade/vim-gitgutter'
nmap <leader>f :GitGutterFold<CR>
Plugin 'junegunn/vim-peekaboo'
Plugin 'alvan/vim-closetag'
Plugin 'tpope/vim-sleuth'
Plugin 'wincent/terminus'
Plugin 'tmhedberg/SimpylFold'
nmap zm zM
Plugin 'majutsushi/tagbar'
Plugin 'jparise/vim-graphql'
Plugin 'peitalin/vim-jsx-typescript'
Plugin 'janko/vim-test'
let test#python#pytest#executable = 'pipenv run python -m pytest'
nmap <leader>t :TestNearest<CR>
Plugin 'mgedmin/python-imports.vim'
map <leader>i    :ImportName<CR>
Plugin 'tpope/vim-unimpaired'
" So annoying that if there's a single error you gotta use :cfirst, and that
" it don't loop by default
command! Lnext try | lnext | catch | lfirst | catch | endtry
nmap <leader>l :Lnext<CR>





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

Plugin 'MilesCranmer/gso'
nnoremap <C-s> :GSO

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

Plug 'jceb/vim-orgmode'

Plug 'junegunn/vim-easy-align'
xmap ga <Plug>(EasyAlign)

Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.vue PrettierAsync

Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
let g:mkdp_auto_start = 1

Plug 'sbdchd/neoformat'
let g:neoformat_python_docformatter = {
            \ 'exe': '/home/satshabad/.pyenv/versions/neovim3.7.2/bin/docformatter',
            \ 'args': ['-', '--wrap-summaries 88', '--wrap-descriptions 88'],
            \ 'stdin': 1,
            \ }

let g:neoformat_python_isort = {
            \ 'exe': isort_path,
            \ 'args': ['-', '-m 3', '--trailing-comma', '-fgw 0', '-up', '-l 88', '--quiet'],
            \ 'stdin': 1,
            \ }

let g:neoformat_enabled_python = ['isort', 'docformatter']
let g:neoformat_run_all_formatters = 1

command! -bang -nargs=* Neo try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry
nnoremap <leader>n :Neo<CR>

set completeopt-=preview

Plug 'ncm2/ncm2'
Plug 'ncm2/float-preview.nvim'
let g:float_preview#docked = 0


Plug 'Shougo/echodoc.vim'
let g:echodoc#enable_at_startup = 1

Plug 'rbgrouleff/bclose.vim'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'


Plug 'neoclide/coc.nvim', {'branch': 'release'}
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

" navigate diagnostics
nmap <silent> <space>j <Plug>(coc-diagnostic-next)
" navigate diagnostics
nmap <silent> <space>k <Plug>(coc-diagnostic-prev)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Resume latest coc list.
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>


Plug 'dense-analysis/ale'

function! s:with_git_root()
  let root = systemlist('git rev-parse --show-toplevel')[0]
  return v:shell_error ? {} : {'dir': root}
endfunction

command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, extend(s:with_git_root(), {'options': '--delimiter : --nth 4..'}), <bang>0)
nnoremap <leader>ga :Ag<CR>

nnoremap <silent> <Leader>gwa :Ag <C-R><C-W><CR>

let $FZF_DEFAULT_COMMAND = 'ag -g ""'
let g:fzf_history_dir = '~/.local/share/fzf-history'
let g:fzf_buffers_jump = 1

" So that you can cycle through the commands
function! s:fzf_next(idx)
  let commands = ['History', 'Files', 'Tags', 'BLines']
  execute commands[a:idx]
  let next = (a:idx + 1) % len(commands)
  execute 'tnoremap <buffer> <silent> <c-f> <c-\><c-n>:close<cr>:sleep 100m<cr>:call <sid>fzf_next('.next.')<cr>'
endfunction

" So that you always search from root
function! s:find_root()
  for vcs in ['.git', '.svn', '.hg']
    let dir = finddir(vcs.'/..', ';')
    if !empty(dir)
      execute 'FZF' dir
      return
    endif
  endfor
  FZF
endfunction

command! Files call s:find_root()

command! Cycle call <sid>fzf_next(0)
nmap <C-f> :Cycle <CR>


call plug#end()
let g:ale_python_mypy_auto_pipenv = 1
let g:ale_python_black_executable = '/home/satshabad/.pyenv/versions/neovim3.7.2/bin/black'
let g:ale_python_flake8_executable = '/home/satshabad/.pyenv/versions/neovim3.7.2/bin/flake8'
let g:ale_python_isort_executable = isort_path
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_sign_error = '>>'
let g:airline#extensions#ale#enabled = 1
let g:ale_linters = {
\   'python': ['flake8', 'mypy'],
\}

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'python': ['black', 'isort'],
\}
let g:ale_fix_on_save = 1


" set spell in commit messages
au BufNewFile,BufRead COMMIT_EDITMSG setlocal spell

set clipboard+=unnamedplus

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


" Enter to select from menu
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

set cmdheight=2

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

nnoremap tt :call Edit_todo()<CR>
function! Edit_todo()
    exe 'edit ' . '~/todo.org'
endfunction

" toggle spell checking
nnoremap <silent> <leader>s :set spell!<CR>

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

" When using `dd` in the quickfix list, remove the item from the quickfix list.
function! RemoveQFItem()
  let curqfidx = line('.') - 1
  let qfall = getqflist()
  call remove(qfall, curqfidx)
  call setqflist(qfall, 'r')
  execute curqfidx + 1 . "cfirst"
  :copen
endfunction
:command! RemoveQFItem :call RemoveQFItem()
" Use map <buffer> to only map dd in the quickfix window. Requires +localmap
autocmd FileType qf map <buffer> dd :RemoveQFItem<cr>

