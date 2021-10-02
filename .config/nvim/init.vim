"colorscheme gruvbox

set number
set relativenumber
set mouse=a

set ignorecase
set smartcase
set incsearch

set tabstop=4
set softtabstop=0
set noexpandtab
set shiftwidth=4

if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif

" to edit file as sudo
" :w echo "password" | !doas tee %
"command W :execute ':silent w !doas tee % > /dev/null' | :edit!
