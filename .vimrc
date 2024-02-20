call plug#begin()
" color schema
Plug 'altercation/vim-colors-solarized'
Plug 'liuchengxu/space-vim-theme'
Plug 'rafi/awesome-vim-colorschemes'
" General
Plug 'github/copilot.vim'
Plug 'iaalm/terminal-drawer.vim'
Plug 'luochen1990/rainbow'
let g:rainbow_active = 1

Plug 'preservim/nerdtree'
" Easy motion
Plug 'easymotion/vim-easymotion'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" using more Rg now
Plug 'iaalm/fzf-session.vim'
let g:fzf_session_path = $HOME . "/.vim_session"
" set cwd to project root
Plug 'airblade/vim-rooter'
let g:rooter_patterns = ['.git']
" git
Plug 'itchyny/lightline.vim', { 'for': 'cs' }
"set laststatus=2
Plug 'tpope/vim-fugitive'
" logfile highlight
Plug 'mtdl9/vim-log-highlighting'
Plug 'MattesGroeger/vim-bookmarks'
" Python
Plug 'tmhedberg/SimpylFold'
Plug 'jmcantrell/vim-virtualenv'
let g:virtualenv_directory="."
" JSX
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'
" TS
Plug 'leafgarland/typescript-vim'
" C# and Powershell
if has("win32") || has("win64")
    Plug 'pprovost/vim-ps1'

    " COC
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " Make <CR> to accept selected completion item or notify coc.nvim to format
    " <C-g>u breaks current undo, please make your own choice
    inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
    " GoTo code navigation
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)

    " Use K to show documentation in preview window
    nnoremap <silent> K :call ShowDocumentation()<CR>

    function! ShowDocumentation()
      if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
      else
        call feedkeys('K', 'in')
      endif
    endfunction
end
call plug#end()
set bg=light
" end vim-plug

" OS specific setting
if has("mac")
    "Mac
    " use option key as meta
    set macmeta
elseif has("win32") || has("win64") "all Windows, ie win32,win64
    vnoremap <C-c> "+y
    tmap <LeftMouse> <C-w>N
    " use powershell
    let g:terminal_drawer_shell="pwsh"
    " set shell=powershell\ -NoProfile
    " set shellcmdflag=\ -c
    " set shellquote=\"
    " set shellxquote= 
elseif has("win32unix")
    "Cygwin
elseif has("bsd")
    "BSD-based, ie freeBSD"
elseif has("linux")
    "Linux
end

" settings
let mapleader = " "
let maplocalleader = "\\"

nnoremap s :
if has("gui_running")
    colo gruvbox
else
    colo blue
endif
let &bg='dark'
" colo solarized
set nocompatible
" not to enable modeline for security
" set modeline
" because number and relativenumber is local to window, use setg here
setg number
setg relativenumber
set ruler
set cursorline
set wildmenu
set autoread
set colorcolumn=80,120
" search
set ignorecase
set smartcase
set hlsearch
set incsearch
" display tab and tail white space
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smarttab
" complete not search current dir
set complete-=i
" show search [x/y] indicate
set shortmess-=S
set jumpoptions=stack

set list
" Display cwd on title
set titlestring=%{getcwd()}\ %f
set listchars=tab:>-,trail:<
" enable backspace anything
set backspace=indent,eol,start
"set foldmethod=indent
syntax enable
syntax on
set foldmethod=syntax
" set foldcolumn=2
set tags+=tags
set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
set signcolumn=number

" fix vim slow while open big file
" https://vi.stackexchange.com/questions/5128/matchpairs-makes-vim-slow
let g:matchparen_timeout = 2
let g:matchparen_insert_timeout = 2

" better fold display
function! FoldText()
    let line = getline(v:foldstart)
    let foldedlinecount = v:foldend - v:foldstart

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth

    " expand tabs into spaces
    let onetab = strpart('    ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    " always give some space to dash
    let line = strpart(line, 0, windowwidth - len(foldedlinecount) - 8)
    " 2 for two space, one before and one after dash,
    " + 2 for possible sign column
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount) - 4

    return line . " " . repeat("-", fillcharcount) . " " . foldedlinecount
endfunction
set foldtext=FoldText()

" hi Pmenu ctermbg=grey
" hi PmenuSel ctermfg=darkgrey
" hi TabLine ctermfg=Grey ctermbg=Black
" hi TabLineSel ctermfg=Red ctermbg=Yellow
" hi TabLineFill ctermfg=DarkGrey ctermbg=DarkGrey

"My surround.
function! AddParenthese(place)
    let [lnum_start, cnum_start] = getpos("'<")[1:2]
    let [lnum_end, cnum_end] = getpos("'>")[1:2]
    call cursor(lnum_end, cnum_end)
    norm! a)
    call cursor(lnum_start, cnum_start)
    norm! i(
    if a:place == 1
        call cursor(lnum_end, cnum_end+2)   "two character for ()
    endif
endfunction
" select and add () around it
vnoremap ( :call AddParenthese(0)<CR>
vnoremap ) :call AddParenthese(1)<CR>
" leaders
nnoremap <leader>q :q<CR>
nnoremap <leader>s :nohlsearch<CR>
nnoremap <leader>p :Commands<CR>
nnoremap <leader>n :NERDTreeFind<CR>
nnoremap <leader>N :NERDTreeToggle<CR>
nnoremap <leader>r :Sessions<CR>
" toggle backgroud between light and dark
nnoremap <leader>f :Rg <C-R><C-W><CR>
vnoremap <leader>f y:Rg <C-R>"<CR>
nnoremap <leader>g :G<CR><C-W>10_
nnoremap <leader>t :term<CR><C-W>15_
"nnoremap <leader>g :vertical botright Git<CR>
nnoremap <leader>c gg"+yG
nnoremap <leader>yf :let @+ = expand("%")<CR>
nnoremap <leader>yp :let @+ = expand("%:p")<CR>
nnoremap <C-p> :GFiles<CR>

" vim bookmark plugins
let g:bookmark_no_default_key_mappings = 1
let g:bookmark_sign = '>'
let g:bookmark_annotation_sign = '#'	
let g:bookmark_save_per_working_dir = 1
let g:bookmark_auto_save = 1
let g:bookmark_center = 1
nmap <Leader>mm <Plug>BookmarkToggle
nmap <Leader>mi <Plug>BookmarkAnnotate
nmap <Leader>ma <Plug>BookmarkShowAll
nmap <Leader>mn <Plug>BookmarkNext
nmap <Leader>mp <Plug>BookmarkPrev

" it seems a good idea to default no fold
set foldlevel=20
set sessionoptions-=buffers sessionoptions-=folds

" terminal
" if has('nvim')
"     autocmd TermOpen * setlocal nonumber norelativenumber
" else
"     autocmd TerminalOpen * setlocal nonumber norelativenumber
" endif

" C sharp
autocmd FileType cs set laststatus=2
" autocmd FileType cs set foldlevel=2    " display namespace - class - function
autocmd FileType cs let g:sharpenup_statusline_opts = { 'Highlight': 0 }
autocmd FileType cs let g:lightline = {
\ 'active': {
\   'right': [['lineinfo'], ['percent'], ['fileformat', 'fileencoding', 'filetype']]
\ },
\ 'inactive': {
\   'right': [['lineinfo'], ['percent']]
\ },
\ 'component': {
\ }
\}

" Json
autocmd FileType json set foldlevel=20

" JavaScript
autocmd FileType javascript,typescript setlocal shiftwidth=2 tabstop=2 softtabstop=0 expandtab

" Windows projects
autocmd BufNewFile,BufRead *.proj set filetype=xml
autocmd BufNewFile,BufRead *.csproj set filetype=xml
autocmd BufNewFile,BufRead *.vcxproj set filetype=xml
autocmd BufNewFile,BufRead *.nuproj set filetype=xml
autocmd BufNewFile,BufRead *.sfproj set filetype=xml
autocmd BufNewFile,BufRead *.props set filetype=xml
autocmd BufNewFile,BufRead *.targets set filetype=xml

" Vim verbose log
" the log is very "verbose", so not using hidden file to notice myself to
" delete it
function! ToggleVerbose()
    if !&verbose
        set verbosefile=~/vim_verbose.log
        set verbose=15
    else
        set verbose=0
        set verbosefile=
    endif
endfunction
function! FormatJson()
    %!python -m json.tool
endfunction

function RandomColorScheme()
  let l:colors = split(globpath(&rtp,"**/colors/*.vim"),"\n") 
  let l:color = l:colors[localtime() % len(l:colors)]
  let l:cname = split(split(l:color, "/")[-1], "\\.")[0]
  exe 'colorscheme ' . l:cname
endfunction

function GitPush(bang)
  let l:p = " "
  if a:bang == "!"
    let l:p = " --no-verify"
  endif
  :execute ":Git! push" . l:p ." -u origin " . FugitiveHead()
endfunction

" quick git command
command! -bang -nargs=0 GGPush call GitPush("<bang>")
command! -nargs=0 GGPull :execute ":Git! pull origin " . FugitiveHead()

command! -nargs=0 ReloadConfig :execute ":source $MYVIMRC"
command! -nargs=0 ToggleVerbose :execute "call ToggleVerbose()"
command! -nargs=0 ToggleDark :let &bg=(&bg=='light'?'dark':'light')
command! -nargs=0 LCD :lcd %:p:h
command! -nargs=0 THEX :%!xxd
command! -nargs=0 FHEX :%!xxd -r
command RandomColor call RandomColorScheme()
command TagsBuild :!git ls-tree --full-tree --name-only -r HEAD | ctags -L -
command -nargs=1 TagsAdd :!ctags -a -R "<args>"
command -nargs=0 TagsDel :call delete('tags')
command -nargs=0 NUM :set number relativenumber
