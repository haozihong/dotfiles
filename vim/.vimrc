" Startup {{{
filetype indent plugin on

" vim 文件折叠方式为 marker
augroup ft_vim
    au!

    au FileType vim setlocal foldmethod=marker
augroup END
" }}}
 
" General {{{
" Vim is based on Vi. Setting `nocompatible` switches from the default
" Vi-compatibility mode and enables useful Vim functionality. This
" configuration option turns out not to be necessary for the file named
" '~/.vimrc', because Vim automatically enters nocompatible mode if that file
" is present. But we're including it here just in case this config file is
" loaded some other way (e.g. saved as `foo`, and then Vim started with
" `vim -u foo`).
set nocompatible

" The backspace key has slightly unintuitive behavior by default. For example,
" by default, you can't backspace before the insertion point set with 'i'.
" This configuration makes backspace behave more reasonably, in that you can
" backspace over anything.
set backspace=indent,eol,start

" This setting makes search case-insensitive when all characters in the string
" being searched are lowercase. However, the search becomes case-sensitive if
" it contains any capital letters. This makes searching more convenient.
set ignorecase
set smartcase

" Enable searching as you type, rather than waiting till you press enter.
set incsearch

"set clipboard+=unnamedplus
let g:clipboard = {
            \   'name': 'WslClipboard',
            \   'copy': {
            \      '+': 'clip.exe',
            \      '*': 'clip.exe',
            \    },
            \   'paste': {
            \      '+': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            \      '*': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            \   },
            \   'cache_enabled': 0,
            \ }
" }}}

" Lang & Encoding {{{
set fileencodings=utf-8,gbk2312,gbk,gb18030,cp936
set encoding=utf-8
" set langmenu=zh_CN
let $LANG = 'en_US.UTF-8'
" language messages zh_CN.UTF-8
" }}}

" GUI {{{
colo desert

" source $VIMRUNTIME/delmenu.vim
" source $VIMRUNTIME/menu.vim
set cursorline
" set cursorcolumn

" Show line numbers.
set number

" This enables relative line numbering mode. With both number and
" relativenumber enabled, the current line shows the true line number, while
" all other lines (above and below) are numbered relative to the current line.
" This is useful because you can tell, at a glance, what count is needed to
" jump up or down to a particular line, by {count}k to go up or {count}j to go
" down.
set relativenumber

" Show a few lines of context around the cursor.
set scrolloff=3

" 分割出来的窗口位于当前窗口下边/右边
set splitbelow
set splitright

" Always show the status line at the bottom, even if you only have one window open.
set laststatus=2

" By default, Vim doesn't let you hide a buffer (i.e. have a buffer that isn't
" shown in any window) that has unsaved changes. This is to prevent you from "
" forgetting about unsaved changes and then quitting e.g. via `:qa!`. We find
" hidden buffers helpful enough to disable this protection. See `:help hidden`
" for more information on this.
set hidden

" Disable audible bell because it's annoying.
set noerrorbells visualbell t_vb=

" Enable mouse support. You should avoid relying on this too much, but it can
" sometimes be convenient.
set mouse+=a
" Enabel mouse resizing windows
if !has('nvim')
    set ttymouse=sgr
endif
" }}}

" Format {{{
" No need to set tab size now. Using plugin sleuth
set smarttab
"set tabstop=4
"set softtabstop=4
"set shiftwidth=4
set expandtab
set autoindent

set foldmethod=indent
" Open all folding when files opened
autocmd BufWinEnter * normal zR

" Turn on syntax highlighting.
syntax on
" }}}

" Keymap {{{
" Fix ALT Key (not used) {{{
" http://www.skywind.me/blog/archives/2021
function! Terminal_MetaMode(mode)
    set ttimeout
    if $TMUX != ''
        set ttimeoutlen=30
    elseif &ttimeoutlen > 80 || &ttimeoutlen <= 0
        set ttimeoutlen=80
    endif
    if has('nvim') || has('gui_running')
        return
    endif
    function! s:metacode(mode, key)
        if a:mode == 0
            exec "set <M-".a:key.">=\e".a:key
        else
            exec "set <M-".a:key.">=\e]{0}".a:key."~"
        endif
    endfunc
    for i in range(10)
        call s:metacode(a:mode, nr2char(char2nr('0') + i))
    endfor
    for i in range(26)
        call s:metacode(a:mode, nr2char(char2nr('a') + i))
        call s:metacode(a:mode, nr2char(char2nr('A') + i))
    endfor
    if a:mode != 0
        for c in [',', '.', '/', ';', '[', ']', '{', '}']
            call s:metacode(a:mode, c)
        endfor
        for c in ['?', ':', '-', '_']
            call s:metacode(a:mode, c)
        endfor
    else
        for c in [',', '.', '/', ';', '{', '}']
            call s:metacode(a:mode, c)
        endfor
        for c in ['?', ':', '-', '_']
            call s:metacode(a:mode, c)
        endfor
    endif
endfunc

"call Terminal_MetaMode(0)
" }}}

let mapleader=" "

" nmap <leader>s :source ~/.vimrc<cr>
" nmap <leader>e :e ~/.vimrc<cr>

" Unbind some useless/annoying default key bindings.
nmap Q <Nop> " 'Q' in normal mode enters Ex mode. You almost never want this.

" Have j and k navigate visual lines rather than logical ones
nmap j gj
nmap k gk
"  use H and L for beginning/end of line
nmap <C-h> ^
nmap <C-l> $

map <leader>tn :tabnew<cr>
map <leader>tc :tabclose<cr>
map <leader>th :tabp<cr>
map <leader>tl :tabn<cr>

" 移动分割窗口
"nmap <tab>j <C-W>j
"nmap <m-K> <C-W>k
"nmap <m-H> <C-W>h
"nmap <m-L> <C-W>l

" 正常模式下 alt+j,k,h,l 调整分割窗口大小
"nnoremap <silent><space>= :resize +3<cr>
"nnoremap <M-k> :resize -3<cr>
"nnoremap <M-h> :vertical resize -3<cr>
"nnoremap <M-l> :vertical resize +3<cr>

" 插入模式移动光标 Ctrl + 方向键
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <left>
inoremap <C-l> <Right>

" toggle searching highlighting
nnoremap <F4> :set invhlsearch<cr>

" autocomplete parenthesis
"inoremap ' ''<ESC>i
"inoremap " ""<ESC>i
"inoremap ( ()<ESC>i
"inoremap [ []<ESC>i
"inoremap { {}<ESC>i

" use Esc to exit terminal mode
:tnoremap <Esc> <C-\><C-n>
" }}}

" Plugin {{{
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
" Example {{{
"call plug#begin()
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Vim (Windows): '~/vimfiles/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'

" Make sure you use single quotes

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
"Plug 'junegunn/vim-easy-align'

" Any valid git URL is allowed
"Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Multiple Plug commands can be written in a single line using | separators
"Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" On-demand loading
"Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
"Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" Using a non-default branch
"Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
"Plug 'fatih/vim-go', { 'tag': '*' }

" Plugin options
"Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" Plugin outside ~/.vim/plugged with post-update hook
"Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Unmanaged plugin (manually installed and updated)
"Plug '~/my-prototype-plugin'

" Initialize plugin system
" - Automatically executes `filetype plugin indent on` and `syntax enable`.
"call plug#end()
" You can revert the settings after the call like so:
"   filetype indent off   " Disable file-type-specific indentation
"   syntax off            " Disable syntax highlighting
" }}}

" NERDTree {{{
" On-demand loading
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTree'] }
" 打开vim时如果没有文件自动打开NERDTree
"autocmd vimenter * if !argc() | NERDTree 
" 当NERDTree为剩下的唯一窗口时自动关闭
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

nnoremap <leader>o :NERDTreeFocus<CR>
" nnoremap <C-n> :NERDTree<CR>
nnoremap <leader>e :NERDTreeToggle<CR>
"nnoremap <C-f> :NERDTreeFind<CR>
" }}}

" vim-sleuth (detect indent) {{{
" detect indent
Plug 'tpope/vim-sleuth'
" }}}

" vim-commentary {{{
" Use gcc to comment out a line (takes a count), gc to comment out the target
" of a motion (for example, gcap to comment out a paragraph), gc in visual
" mode to comment out the selection, and gc in operator pending mode to target
" a comment. You can also use it as a command, either with a range like
" :7,17Commentary, or as part of a :global invocation like with
" :g/TODO/Commentary.
Plug 'tpope/vim-commentary'
" }}}

" vim-surround {{{
Plug 'tpope/vim-surround'
" }}}

" argtextobj.vim (provides a text-object 'a' (argument)) {{{
Plug 'vim-scripts/argtextobj.vim'
" }}}

" vim-highlightedyank {{{
Plug 'machakann/vim-highlightedyank'
let g:highlightedyank_highlight_duration = 200
" }}}

" themes {{{
Plug 'morhetz/gruvbox'
"Plug 'joshdick/onedark.vim'
"Plug 'altercation/vim-colors-solarized'
" }}}

" vim-polyglot (syntax highlighting) {{{
Plug 'sheerun/vim-polyglot'
" }}}

" suda.vim (read or write file with sudo) {{{
Plug 'lambdalisue/suda.vim'
" }}}

" vim-mark {{{
"Plug 'inkarkat/vim-ingo-library'
"Plug 'inkarkat/vim-mark'
"let g:mwDefaultHighlightingPalette = 'extended'
" }}}

" Airline {{{
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_powerline_fonts = 1
" }}}

" a.vim (switch between .h and .c/cpp) {{{
" :A switches to the header file corresponding to the current file being edited (or vise versa)
" :AS splits and switches
" :AV vertical splits and switches
" :AT new tab and switches
" :AN cycles through matches
" :IH switches to file under cursor
" :IHS splits and switches
" :IHV vertical splits and switches
" :IHT new tab and switches
" :IHN cycles through matches
" <Leader>ih switches to file under cursor
" <Leader>is switches to the alternate file of file under cursor (e.g. on  <foo.h> switches to foo.cpp)
" <Leader>ihn cycles through matches
Plug 'vim-scripts/a.vim'
" }}}

" Dirvish (directory navigator, replacing netrw) {{{
Plug 'justinmk/vim-dirvish'
" }}}

" Initialize plugin system
" - Automatically executes `filetype plugin indent on` and `syntax enable`.
call plug#end()
" }}}

" Theme {{{
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

colorscheme gruvbox
set background=dark
" set background=light
" }}}

