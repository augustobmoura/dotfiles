call plug#begin('~/.local/share/nvim/plugged')

Plug 'chriskempson/base16-vim'
Plug 'sheerun/vim-polyglot'
Plug 'w0rp/ale'

call plug#end()

" Theme
let base16colorspace=256
if filereadable(expand("~/.vimrc_background"))
  source ~/.vimrc_background
endif

" Keymaps
set nu
set rnu

nmap <Esc> :noh<CR>
