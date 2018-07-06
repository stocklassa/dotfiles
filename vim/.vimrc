"Where am I?
set ruler

"What am I doing?
set showmode

"What year is this?
set nocompatible

"Proper Backspace behavior
set backspace=2

syntax enable
filetype plugin on
filetype indent on

set t_Co=256

set path+=**

set wildmenu

"Slant made me set my leader key to Space! Is that... wise?
let mapleader = " "

"For modifiying my .vimrc a lot
nmap <Leader>v :source $MYVIMRC<CR>

"Mappings for phpactor
nmap <Leader>mm :call phpactor#ContextMenu()<CR>
nmap <Leader>o :call phpactor#GotoDefinition()<CR>
nmap <Leader>u :call phpactor#UseAdd()<CR>
nmap <Leader>nn :call phpactor#Navigate()<CR>
nmap <Leader>tt :call phpactor#Transform()<CR>
nmap <Leader>cc :call phpactor#ClassNew()<CR>
nmap <silent><Leader>ee :call phpactor#ExtractExpression(v:false)<CR>
vmap <silent><Leader>ee :<C-U>call phpactor#ExtractExpression(v:true)<CR>
vmap <silent><Leader>em :<C-U>call phpactor#ExtractMethod()<CR>

"Vim-test
let test#strategy = "dispatch"
nmap <silent> <Leader>t :TestNearest<CR>
nmap <silent> <Leader>T :TestFile<CR>
nmap <silent> <Leader>a :TestSuite<CR>
nmap <silent> <Leader>l :TestLast<CR>
nmap <silent> <Leader>g :TestVisit<CR>

"Just for PHP
nmap <silent> <F9> :TestSuite tests/<CR>

"git with fugitive
nmap <Leader>gs :Gstatus<CR>
