" Options
set nu rnu
set backup
set splitbelow splitright
set encoding=UTF-8
set foldlevel=30
set mouse=a

" Invisibles
set list listchars=tab:»─,extends:›,precedes:‹,nbsp:·,trail:·,space:·
set tabstop=2
set softtabstop=2
set shiftwidth=2

" Split windows mappings
nnoremap <C-w>z <C-w>\| <C-w>_
nnoremap <C-w>% :vnew<CR>

" Mark bash as the default shell syntax
" I'm already familiar with bashisms and I work in bashed sourced files most
" of the time anyways
let g:is_bash = 1

" Disable Language Server Protocol for Ale, because CoC will already handle
" that
let g:ale_disable_lsp = 1

" Hide search highlighting on double Esc
nmap <Esc> :noh<CR>

let use_telescope = has('nvim-0.5')

let plugged_path = '~/.local/share/nvim/plugged'

if ! has('nvim')
	let plugged_path = '~/.vim/plugged'
endif

" Plugins
call plug#begin(plugged_path)

" Theme
Plug 'chriskempson/base16-vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Language support
Plug 'sheerun/vim-polyglot'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'editorconfig/editorconfig-vim'
Plug 'tyru/open-browser.vim'
Plug 'weirongxu/plantuml-previewer.vim'
Plug 'AndrewRadev/tagalong.vim'
Plug 'alvan/vim-closetag'
Plug 'raimondi/delimitmate'
Plug 'honza/vim-snippets'
Plug 'chrisbra/csv.vim'
Plug 'masukomi/vim-markdown-folding'

" Editor tools
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'andymass/vim-matchup'
Plug 'github/copilot.vim'

" Additional tools
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-unimpaired'

" File management
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'airblade/vim-gitgutter'

" File searching
if use_telescope
	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-telescope/telescope.nvim'
else
	Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'
endif

" QOL
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-repeat'
Plug 'ConradIrwin/vim-bracketed-paste'

call plug#end()

autocmd FileType markdown set foldexpr=NestedMarkdownFolds()

let g:coc_global_extensions = [
		\'coc-actions',
		\'coc-angular',
		\'coc-calc',
		\'coc-pyright',
		\'coc-htmldjango',
		\'coc-clangd',
		\'coc-snippets',
		\'coc-css',
		\'coc-emmet',
		\'coc-eslint',
		\'coc-flow',
		\'coc-html',
		\'coc-json',
		\'coc-prettier',
		\'coc-sh',
		\'coc-sql',
		\'coc-tsserver',
		\'coc-spell-checker',
		\'coc-cspell-dicts',
		\'coc-ltex',
		\'coc-xml',
		\'coc-yaml']

" Coc shortcuts
nmap <leader>aa :CocAction<CR>
vmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)
nmap <leader>b <Plug>(coc-format)

" Telescope/fzf shortcuts
if use_telescope
	nnoremap <leader>ff <cmd>Telescope find_files<CR>
	nnoremap <leader>fg <cmd>Telescope live_grep<CR>
	nnoremap <leader>fb <cmd>Telescope buffers<CR>
	nnoremap <leader>fh <cmd>Telescope help_tags<CR>
	if executable('rg')
		lua require('telescope').setup{ 'rg', '--color=never', '--hidden', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case' }
	endif
else
	nnoremap <leader>ff :Files<CR>
	nnoremap <leader>fb :Buffers<CR>
endif

" NERDTree shortcuts
nmap <leader>ne :NERDTreeFocus<CR>
nmap <leader>nf :NERDTreeFind<CR>

if ! has('nvim') 
	let g:coc_disable_startup_warning = 1
endif

" Fix highlighting for spell checks in terminal
function! s:base16_customize() abort
	" Colors: https://github.com/chriskempson/base16/blob/master/styling.md
	" Arguments: group, guifg, guibg, ctermfg, ctermbg, attr, guisp
	call Base16hi("SpellBad",   "", "", g:base16_cterm08, g:base16_cterm00, "", "")
	call Base16hi("SpellCap",   "", "", g:base16_cterm0A, g:base16_cterm00, "", "")
	call Base16hi("SpellLocal", "", "", g:base16_cterm0D, g:base16_cterm00, "", "")
	call Base16hi("SpellRare",  "", "", g:base16_cterm0B, g:base16_cterm00, "", "")
endfunction


" Theme
if filereadable(expand("~/.vimrc_background"))
	let base16colorspace=256
	source ~/.vimrc_background
	augroup on_change_colorschema
		autocmd!
		autocmd ColorScheme * call s:base16_customize()
	augroup END
endif
let g:airline_powerline_fonts = 1
let g:airline_theme='base16_seti'

" Override the diff-mode highlights of base16.
highlight DiffAdd    term=bold ctermfg=0 ctermbg=2 guifg=#2b2b2b guibg=#a5c261
highlight DiffDelete term=bold ctermfg=0 ctermbg=1 gui=bold guifg=#2b2b2b guibg=#da4939
highlight DiffChange term=bold ctermfg=0 ctermbg=4 guifg=#2b2b2b guibg=#6d9cbe
highlight DiffText   term=reverse cterm=bold ctermfg=0 ctermbg=4 gui=bold guifg=#2b2b2b guibg=#6d9cbe

inoremap <silent><expr> <c-space> coc#refresh()

" Set prettier command
command! -nargs=0 Prettier :CocCommand prettier.formatFile

" ---
" Config for CoC, mostly coppied from the example configuration
" ---

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

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

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-cursor)
nmap <leader>a  <Plug>(coc-codeaction-cursor)

" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
