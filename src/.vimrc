set nocompatible              " be iMproved, required
set number
filetype off                  " required

set autoindent
set expandtab
set tabstop=4
set shiftwidth=4
set textwidth=80
set ignorecase
set smartcase
set incsearch
set scrolloff=10
set autoread
set noswapfile
set splitbelow
set splitright
set hidden

set grepprg=rg\ -S\ --line-number\ --column\ $*
set grepformat=%f:%l:%c%m

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'mileszs/ack.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'morhetz/gruvbox'
Plugin 'joshdick/onedark.vim'
Plugin 'prabirshrestha/async.vim'
Plugin 'prabirshrestha/vim-lsp'
Plugin 'prabirshrestha/asyncomplete.vim'
Plugin 'puremourning/vimspector'
Plugin 'drichardson/vim-unreal'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'madox2/vim-ai'
Plugin 'Exafunction/codeium.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Codeium
let g:codeium_disable_bindings = 1

imap <script><silent><nowait><expr> <C-j> codeium#Accept()
imap <script><silent><nowait><expr> <C-k> codeium#AcceptNextWord()
imap <script><silent><nowait><expr> <C-l> codeium#AcceptNextLine()
imap <C-s>n <Cmd>call codeium#CycleCompletions(1)<CR>
imap <C-s>N <Cmd>call codeium#CycleCompletions(-1)<CR>
imap <C-s>c <Cmd>call codeium#Clear()<CR>

" Git
nnoremap <Leader><f2> :Git blame<CR>

" Colorscheme
colorscheme desert
set bg=dark
syntax on

" Vimspector
let g:vimspector_enable_mappings = 'HUMAN'
let g:vimspector_base_dir='/home/alle/.vim/bundle/vimspector'

" Ack
let g:ackprg = 'ag --vimgrep'

" FZF
nnoremap <silent> <Leader>p :Files<CR>
nnoremap <silent> <Leader>o :Rg <C-R><C-W><CR>
nnoremap <silent> <Leader>i :Rg<CR>
nnoremap <silent> <C-x>f :Files<CR>
nnoremap <silent> <C-x>o :Rg <C-R><C-W><CR>
nnoremap <silent> <C-x>i :Rg<CR>

let g:fzf_layout = { 'down': '40%' }

" FZF with top preview
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   "rg --column --line-number --no-heading --color=always --smart-case -- ".shellescape(<q-args>), 1, 
  \   fzf#vim#with_preview('up', 'ctrl-/'), 1)

" Ctags
set tags+=/home/alle/workspace/UnrealEngine54/tags
nnoremap <silent> <Leader><f4> :!genctags.sh<CR>

" Build
nnoremap <Leader><f6> :make -f Makefile-AP compile<CR>
nnoremap <Leader><f7> :make -f Makefile-AP test<CR>
nnoremap <Leader><f8> :make -f Makefile-AP all<CR>
nnoremap <c-x><c-x> :make -f Makefile-AP run<cr>
nnoremap <c-x>m :make build<cr>
nnoremap <c-x>r :make run<cr>

" Vimspector - non human mappings
" From here: https://dev.to/iggredible/debugging-in-vim-with-vimspector-4n0m
nnoremap <Leader>dd :call vimspector#Launch()<CR>
nnoremap <Leader>de :call vimspector#Reset()<CR>
nnoremap <Leader>dc :call vimspector#Continue()<CR>

nnoremap <Leader>dt :call vimspector#ToggleBreakpoint()<CR>
nnoremap <Leader>dT :call vimspector#ClearBreakpoints()<CR>

nmap <Leader>dk <Plug>VimspectorRestart
nmap <Leader>dh <Plug>VimspectorStepOut
nmap <Leader>dl <Plug>VimspectorStepInto
nmap <Leader>dj <Plug>VimspectorStepOver

" Misc
nnoremap <C-x>e :tabe<CR>
nnoremap <silent> <Leader>[ gt<CR>
nnoremap <silent> <Leader>] gT<CR>
nnoremap <silent> <C-x>n gt<CR>
nnoremap <silent> <C-x>p gT<CR>
nnoremap <silent> <C-x>h :set hlsearch!<CR>
nnoremap <silent> <Leader>ff gggqG<CR>
nnoremap <silent> <Leader>vt :vert terminal<CR>

" Break ini coma-separated lists into multiple lines
nnoremap <silent> <Leader>cc :%s/,/\r/g<CR>

" Quickfix list navigation
nnoremap <silent> <Leader><Leader> :cnext<CR>
nnoremap <silent> cn :cnext<CR>
nnoremap <silent> cp :cprev<CR>

" Split windows
nnoremap <Leader><f3> :close<CR>
nnoremap <c-j> <c-w><c-j>
nnoremap <c-k> <c-w><c-k>
nnoremap <c-l> <c-w><c-l>
nnoremap <c-h> <c-w><c-h>

" Ultisnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsSnippetDirectories=$HOME.'/.vim/UltiSnips'

" Clang format (on save)
function! FormatOnSave()
    let l:formatdiff = 1
    if has('python')
        pyf /usr/share/clang/clang-format.py
    elseif has('python3')
        py3f /usr/share/clang/clang-format.py
    endif
endfunction

autocmd BufWritePre *.h,*.cc,*.cpp,*.hpp call FormatOnSave()

