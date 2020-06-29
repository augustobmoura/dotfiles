
let plugged_path = '~/.local/share/nvim/plugged'

if ! has('nvim')
	let plugged_path = '~/.vim/plugged'
endif

" Plug
call plug#begin(plugged_path)

Plug 'chriskempson/base16-vim'
Plug 'tpope/vim-fugitive'
Plug 'sheerun/vim-polyglot'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'prettier/vim-prettier', { 'do': 'npm install' }

call plug#end()

if has('nvim')
	" Fix highlighting for spell checks in terminal
	function! s:base16_customize() abort
		" Colors: https://github.com/chriskempson/base16/blob/master/styling.md
		" Arguments: group, guifg, guibg, ctermfg, ctermbg, attr, guisp
		call Base16hi("SpellBad",   "", "", g:base16_cterm08, g:base16_cterm00, "", "")
		call Base16hi("SpellCap",   "", "", g:base16_cterm0A, g:base16_cterm00, "", "")
		call Base16hi("SpellLocal", "", "", g:base16_cterm0D, g:base16_cterm00, "", "")
		call Base16hi("SpellRare",  "", "", g:base16_cterm0B, g:base16_cterm00, "", "")
	endfunction

	augroup on_change_colorschema
		autocmd!
		autocmd ColorScheme * call s:base16_customize()
	augroup END

	" Theme
	let base16colorspace=256
	if filereadable(expand("~/.vimrc_background"))
		source ~/.vimrc_background
	endif
	colorscheme base16-seti
endif

inoremap <silent><expr> <c-space> coc#refresh()

" Options
set nu
set rnu

" Invisibles
set list listchars=tab:»─,extends:›,precedes:‹,nbsp:·,trail:·,space:·
set tabstop=2
set softtabstop=2
set shiftwidth=2

" Hide search highlighting on double Esc
nmap <Esc> :noh<CR>

" ctrl-p
nnoremap <C-p> :Files<CR>

" ---
" Config for CoC, mostly coppied from the example configuration
" ---

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
