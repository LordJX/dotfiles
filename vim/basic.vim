
" ------------------------------------------------------------
" General
" ------------------------------------------------------------

" Sets how many lines of history VIM has to remember
set history=500

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","

" Fast saving
nmap <leader>w :w!<cr>

" :W sudo saves the file
command W w !sudo tee % > /dev/null

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Turn backup off, since most stuff is in git, git et.c anyway...
set nobackup
set nowb
set noswapfile

"if has('persistent_undo')
"  set undodir=~/.vim/temp/undo
"  set undofile
"endif


" ------------------------------------------------------------
" User interface
" ------------------------------------------------------------

" Set 7 lines to the cursor - when moving vertically using j/k
set scrolloff=7

" Turn on the Wild menu
set wildmenu

"Always show current position
set ruler

" Height of the command bar
set cmdheight=2

" A buffer becomes hidden when it is abandoned
set hidden

" Configure backspace so it acts as it should act
set backspace=eol,start,indent

" Wrap left and right
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch 

" Don't redraw while executing macros (good performance config)
set lazyredraw 

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch 

" How many tenths of a second to blink when matching brackets
set mat=2

" Show absolute/relative line number
set number relativenumber
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" Add a bit extra margin to the left
"set foldcolumn=1


" ------------------------------------------------------------
" Colors and Fonts
" ------------------------------------------------------------

" Enable syntax highlighting
syntax enable 

" Set vim color scheme 
try
  colorscheme solarized
endtry

" Enable italicised comments in vim
"autocmd ColorScheme * highlight Comment cterm=italic

set background=dark

" toggle background and update lightline color scheme
function! ToggleBackground()
  let &background = ( &background == "dark"? "light" : "dark" )
  if exists("g:colors_name")
    exe "colorscheme " . g:colors_name
  endif
endfunction

" map F2 to ToggleBackground() function
map <F2> :call ToggleBackground()<CR>

" Set extra options when running in GUI mode
if has("gui_running")
  set guioptions-=T
  set guioptions-=e
  set t_Co=256
  set guitablabel=%M\ %t
endif


" -------------------------------------------------------------
" Text, tab and indent related
" -------------------------------------------------------------

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2

" Linebreak on 500 characters
set linebreak
set textwidth=500

set autoindent  "Auto indent
set smartindent "Smart indent
set wrap        "Wrap lines


" -------------------------------------------------------------
" Visual mode related
" -------------------------------------------------------------

" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>


" -------------------------------------------------------------
" Moving around, tabs, windows and buffers
" -------------------------------------------------------------

" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
map <space> /
map <c-space> ?

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Close the current buffer
map <leader>bd :Bclose<cr>:tabclose<cr>gT

" Close all the buffers
map <leader>ba :bufdo bd<cr>

map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove 
map <leader>t<leader> :tabnext 

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers 
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


" -----------------------------------------------------
" Status line
" -----------------------------------------------------

" Always show the status line
set laststatus=2

" -- INSERT -- is unnecessary anymore
set noshowmode

" Enable and setup lightline
let g:lightline = {
    \ 'colorscheme': 'solarized',
    \ 'active': {
    \     'left':  [ [ 'mode', 'paste' ],
    \                [ 'fugitive', 'filename' ] ],
    \     'right': [ [ 'lineinfo' ], 
    \                ['percent'], 
    \                [ 'filetype', 'fileencoding', 'fileformat' ] ]
    \ },
    \ 'component_function': {
    \     'filename':     'LightlineFilename',
    \     'fileformat':   'LightlineFileformat',
    \     'filetype':     'LightlineFiletype',
    \     'fileencoding': 'LightlineFileencoding',
    \     'mode':         'LightlineMode',
    \     'lineinfo':     'LightlineLineinfo',
    \     'percent':      'LightlinePercent',
    \     'readonly':     'LightlineReadonly',
    \     'modified':     'LightlineModified',
    \ },
    \ 'separator':    { 'left': "\ue0b8", 'right': "\ue0be" },
    \ 'subseparator': { 'left': "\ue0b9", 'right': "\ue0bf" },
    \ 'tab': {
    \     'active':   [ 'tabnum', 'filename', 'modified', 'readonly' ],
    \     'inactive': [ 'tabnum', 'filename', 'modified', 'readonly' ]
    \ },
    \ 'tab_component_function': {
    \     'filename': 'TablineFilename',
    \     'modified': 'TablineModified',
    \     'readonly': 'TablineReadonly',
    \ },
    \ 'tabline_separator':    { 'left': "",  'right': "" },
    \ 'tabline_subseparator': { 'left': "|", 'right': "|" }
\ }

function! LightlineFugitive() abort
  if &filetype ==# 'help'
    return ''
  endif
  if has_key(b:, 'lightline_fugitive') && reltimestr(reltime(b:lightline_fugitive_)) =~# '^\s*0\.[0-5]'
    return b:lightline_fugitive
  endif
  try
    if exists('*fugitive#head')
      let head = fugitive#head()
    else
      return ''
    endif
    let b:lightline_fugitive = head !=# '' ? "\ue0a0 ".head : ''
    let b:lightline_fugitive_ = reltime()
    return b:lightline_fugitive
  catch
  endtry
  return ''
endfunction

function! LightlineModified()
  return &ft =~ 'help' ? '' : &modified ? "\uf8ea" : ''
endfunction

function! LightlineReadonly()
  return &ft !~? 'help' && &readonly ? "\ue0a2" : ''
endfunction

function! LightlineMode()
  let fname = expand('%:t')
  return fname =~ 'NERD_tree' ? 'NERDtree' :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! LightlineNormalFile()
  let fname = expand('%:t')
  return ! (fname =~ 'NERD_tree')
endfunction

function! LightlineFilename()
  if winwidth(0) > 100 
    let fname = expand('%:F')
  else
    let fname = expand('%:t')
  endif
  return ! (LightlineNormalFile()) ? '' :
        \ ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
        \ ('' != fname ? fname : '[No Name]') .
        \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
endfunction

function! LightlinePercent()
  return LightlineNormalFile() ? (100 * line('.') / line('$')) . '%' : ''
endfunction

function! LightlineLineinfo()
  return LightlineNormalFile() ? printf("%d:%-2d", line('.'), col('.')) : ''
endfunction

function! LightlineFileformat()
  return winwidth(0) > 80 ? &fileformat : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 80 ? (&filetype !=# '' ? &filetype : 'N/A') : ''
endfunction

function! LightlineFileencoding()
  return winwidth(0) > 80 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

function! TablineModified(n)
  let winnr = tabpagewinnr(a:n)
  return gettabwinvar(a:n, winnr, '&modified') ? "\uf8ea" : gettabwinvar(a:n, winnr, '&modifiable') ? '' : "\uf8ed"
endfunction

function! TablineReadonly(n)
  let winnr = tabpagewinnr(a:n)
  return gettabwinvar(a:n, winnr, '&readonly') ? "\ue0a2" : ''
endfunction

function! TablineFilename(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let tname = expand('#'.buflist[winnr - 1].':t')
  return tname =~ 'NERD_tree' ? 'NERDTree' : tname !=# '' ? tname : '[No Name]'
endfunction

" update lightline theme on fly
augroup LightLineColorscheme
  autocmd!
  autocmd ColorScheme * call s:lightline_update()
augroup END

function! s:lightline_update()
  if !exists('g:loaded_lightline')
    return
  endif
  try
    if g:colors_name =~# 'solarized\|gruvbox'
      let g:lightline.colorscheme = substitute(substitute(g:colors_name, '-', '_', 'g'), '256.*', '', '') 
      if g:lightline.colorscheme ==# 'solarized'
        runtime autoload/lightline/colorscheme/solarized.vim
      endif
      if g:lightline.colorscheme ==# 'gruvbox'
        runtime autoload/lightline/colorscheme/gruvbox.vim
      endif
      call lightline#init()
      call lightline#colorscheme()
      call lightline#update()
    endif
  catch
  endtry
endfunction


" ------------------------------------------------------------
" Editing mappings
" ------------------------------------------------------------

" Remap VIM 0 to first non-blank character
"map 0 ^

" Disable arrow key, use hjkl instead
map <Left>  <Nop>
map <Right> <Nop>
map <Up>    <Nop>
map <Down>  <Nop>

" Enable jk to exit insert mode
imap jk <Esc>


" ------------------------------------------------------------
" Misc
" ------------------------------------------------------------

" Quickly open a buffer for scribble
map <leader>q :e ~/buffer<cr>

" Quickly open a markdown buffer for scribble
map <leader>x :e ~/buffer.md<cr>

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>

" Avoid garbled characters in Chinese language windows OS
let $LANG='en' 
set langmenu=en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32") || has("win64")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

