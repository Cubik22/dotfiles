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

command W :execute ':silent w !sudo tee % > /dev/null' | :edit!
