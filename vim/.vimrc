execute pathogen#infect()
syntax enable
filetype plugin indent on
set bs=2
set ts=2
set sw=2
set nu
set ai
map <s-f> :set nu!<cr>
set nu
set smarttab
set expandtab
set laststatus=2
set statusline=%F:\ %l
autocmd FileType rb set tabstop=2
autocmd FileType slim set tabstop=2
autocmd FileType erb set tabstop=2
autocmd FileType html set tabstop=4
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" nmap <F2> :NERDTreeToggle<CR>
" let g:ctrlp_map = 'ff'
" let g:ctrlp_cmd = 'CtrlP'
map gn :bn<cr>
map gp :bp<cr>
map gd :bd<cr>
