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

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Git
nnoremap <Leader><f1> :Git blame<CR>

" Colorscheme
colorscheme onedark
set bg=dark

" Vimspector
let g:vimspector_enable_mappings = 'HUMAN'
let g:vimspector_base_dir='/home/alle/.vim/bundle/vimspector'

" Ack
let g:ackprg = 'ag --vimgrep'

" FZF
nnoremap <silent> <Leader>p :GFiles<CR>
nnoremap <silent> <Leader>o :Rg <C-R><C-W><CR>
nnoremap <silent> <Leader>i :Rg<CR>

" Ctags
nnoremap <silent> <Leader><f4> :Ue4Tags<CR>

" Build
function! CompileAndRun() 
    silent call ue4#make('build DebugGame')
    silent call ue4#make('run DebugGame')
endfunction

nnoremap <silent> <Leader><f6> :Ue4Make build DebugGame<CR>
nnoremap <silent> <Leader><f7> :call CompileAndRun()<CR>

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
nnoremap <silent> <Leader>[ gt<CR>
nnoremap <silent> <Leader>] gT<CR>
nnoremap <silent> <Leader>h :set hlsearch!<CR>
nnoremap <silent> <Leader>ff gggqG<CR>

" Quickfix list navigation
nnoremap <silent> cn :cnext<CR>
nnoremap <silent> cp :cprev<CR>

" Split windows
nnoremap <c-j> <c-w><c-j>
nnoremap <c-k> <c-w><c-k>
nnoremap <c-l> <c-w><c-l>
nnoremap <c-h> <c-w><c-h>

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

