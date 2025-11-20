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
set hlsearch
set wildignore+=.git,*.o,*.so,Intermediate/**,Plugins/**,Binaries/**,Build/**

set grepprg=rg\ -S\ --line-number\ --column\ --vimgrep\ -uu\ $*
set grepformat=%f:%l:%c:%m

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

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Plug
call plug#begin()

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junkblocker/git-time-lapse', {'branch': 'master'}
Plug 'github/copilot.vim'

call plug#end()

" Copilot
imap <silent><script><expr> <c-j> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true

" Git
nnoremap <Leader><f2> :Git blame<CR>
nnoremap <c-x>d :silent Git difftool<CR>

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
let $FZF_DEFAULT_COMMAND = 'fd --type f --exclude .git --ignore-file ~/.gitignore'

" Ctags
set tags+=/media/workspace/workspace/UnrealEngine/tags
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
nnoremap <Leader>de :call vimspector#Reset()<CR>

nnoremap <c-g>p <Plug>VimspectorUpFrame
nnoremap <c-g>n <Plug>VimspectorDownFrame
nnoremap <c-g>d <Plug>VimspectorDisassemble

nmap <c-g>v <Plug>VimspectorBalloonEval
xmap <c-g>v <Plug>VimspectorBalloonEval

" Misc
nnoremap <C-x>e :tabe<CR>
nnoremap <C-x>c :tabclose<CR>
nnoremap <silent> <Leader>[ gt<CR>
nnoremap <silent> <Leader>] gT<CR>
nnoremap <silent> <C-x>n gt<CR>
nnoremap <silent> <C-x>p gT<CR>
nnoremap <silent> <C-x>h :set hlsearch!<CR>
nnoremap <silent> <Leader>ff gggqG<CR>
nnoremap <silent> <Leader>vt :vert terminal<CR>
nnoremap <silent> <C-x><space> :Exp<CR>
nnoremap <silent> <C-x>j :vim /\C<C-R><C-W>/ **/*.cpp **/*.h<CR> 

" Copy visual selection to clipboard using wl-copy
vnoremap <silent> <Leader>y :w !wl-copy<CR><CR>

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

" Rust
let g:rustfmt_autosave = 1

" COC
inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
inoremap <silent> <c-space> coc#refresh()
inoremap <expr> <Tab> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
inoremap <expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"

" Clang format (on save) for C/CPP files
function! FormatCppOnSave()
    let l:formatdiff = 1
    if has('python')
        pyf /usr/share/clang/clang-format.py
    elseif has('python3')
        py3f /usr/share/clang/clang-format.py
    endif
endfunction

autocmd BufWritePre *.h,*.cc,*.cpp,*.hpp call FormatCppOnSave()

set path=.,,**
