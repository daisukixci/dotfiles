" do not load defaults if ~/.vimrc is missing
"let skip_defaults_vim=1

" USER DAISU SETTINGS
" Launch plugin manager
syntax on
filetype plugin indent on

" Set the map leader key
let mapleader = '\'

" FZF
set rtp+=~/fzf

nmap <silent> <space>f :FZF<CR>

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" An action can be a reference to a function that processes selected lines
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val, "lnum": 1 }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - Popup window (center of the screen)
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

" - Popup window (center of the current window)
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'relative': v:true } }

" - Popup window (anchored to the bottom of the current window)
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'relative': v:true, 'yoffset': 1.0 } }

" - down / up / left / right
let g:fzf_layout = { 'down': '40%' }

" - Window using a Vim command
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_layout = { 'window': '-tabnew' }
let g:fzf_layout = { 'window': '10new' }

" Customize fzf colors to match your color scheme
" - fzf#wrap translates this to a set of `--color` options
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Enable per-command history
" - History files will be stored in the specified directory
" - When set, CTRL-N and CTRL-P will be bound to 'next-history' and
"   'previous-history' instead of 'down' and 'up'.
let g:fzf_history_dir = '~/.local/share/fzf-history'

" Display line number
set number
" Show (partial) command in status line.
set showcmd
" Show matching brackets.
set showmatch
" Do case insensitive matching
set ignorecase

set autoindent
set smartindent
set showmode

" Set spaces instead of tabs
set tabstop=4
set expandtab
set softtabstop=4
set shiftwidth=4

set mouse=a
set nocompatible
set nofoldenable
set foldmethod=indent
set t_Co=256
set relativenumber
" Define delete behaviour into backspace key
set backspace=2

" Create undo file and put it in dir
set undofile
set undodir=~/.vim/undodir

"Show ruler at 100 character limit (change as needed)
set colorcolumn=120

" Change colorscheme
"colorscheme molokai
colorscheme gruvbox
"colorscheme flexoki-dark
" Enable if i want background colors too
"if has('nvim') || has('termguicolors')
"  set termguicolors
"endif

" Force sudo with w!!
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Show python doc with H
nnoremap <buffer> H :<C-u>execute "!pydoc " . expand("<cword>")<CR>

" Mapping of paste mode
nnoremap <C-Y> :set invrelativenumber<CR>
"nnoremap <C-P> :set invpaste paste?<CR>:set invnu<CR>
"set pastetoggle=<C-P>

" For local replace
nnoremap gr gd[{V%::s/<C-R>///gc<left><left><left>

" For global replace
nnoremap gR gD:%s/<C-R>///gc<left><left><left>

" Move visual selection
vnoremap J :m '>+1gv=gv<CR>gv
vnoremap K :m '<-2gv=gv<CR>gv

" move through split windows
nmap <C-S-Up> :wincmd k<CR>
nmap <C-S-Down> :wincmd j<CR>
nmap <C-S-Left> :wincmd h<CR>
nmap <C-S-Right> :wincmd l<CR>
nmap <C-Up> :bnext<CR>
nmap <C-Down> :bprevious<CR>

" Found who worked on the file
map <F4> :!git shortlog -s -n %<CR>
map <F6> :term<CR>
map <F7> :A<CR>
map <F8> :packadd termdebug<CR>:Termdebug<CR>

"nnoremap <Delete> x

" automatically give executable permissions if file begins with #! and
" contains '/bin/' in the path
function MakeScriptExecuteable()
    if getline(1) =~ "^#!.*/bin/"
        silent !chmod +x <afile>
    endif
endfunction
"au BufWritePost * call MakeScriptExecuteable()"

"Remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Don't add endofline
autocmd BufRead,BufNewFile *.secret setlocal noendofline nofixendofline

command! -nargs=* Blame call s:GitBlame()

" Run git blame with \gb
function! s:GitBlame()
    let cmd = "git blame -w " . bufname("%")
    let nline = line(".") + 1
    botright new
    execute "$read !" . cmd
    execute "normal " . nline . "gg"
    execute "set filetype=perl"
endfunction
nnoremap <leader>gb :Blame

" airline configuration
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#branch#vcs_priority = ["git", "mercurial"]
let g:airline#extensions#whitespace#enabled = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline_theme='wombat'
set laststatus=2
set encoding=utf-8

" Context config
let g:context_enabled = 1

" Doge configuration
let g:doge_doc_standard_python = 'reST'
let g:doge_doc_standard_php = 'phpdoc'
let g:doge_doc_standard_javascript = 'jsdoc'
let g:doge_doc_standard_typescript = 'jsdoc'
let g:doge_doc_standard_coffeescript = 'jsdoc'
let g:doge_doc_standard_lua = 'ldoc'
let g:doge_doc_standard_java = 'javadoc'
let g:doge_doc_standard_groovy = 'javadoc'
let g:doge_doc_standard_ruby = 'YARD'
let g:doge_doc_standard_scala = 'scaladoc'
let g:doge_doc_standard_kotlin = 'kdoc'
let g:doge_doc_standard_r = 'roxygen2'
let g:doge_doc_standard_cpp = 'doxygen'
let g:doge_enable_mappings = 1
let g:doge_mapping = '<F3>'
let g:doge_mapping_comment_jump_forward = '<C-t>'
let g:doge_mapping_comment_jump_backward = '<C-g>'

" Tagbar config
let g:tagbar_compact = 1
let g:tagbar_sort = 1
"let g:tagbar_iconchars = ['▸', '▾']
let g:tagbar_width = 30

" Avoid conceal into json which hide the quote
let g:indentLine_fileTypeExclude = ['json', 'dockerfile', 'markdown']

" Configure snippet
let g:snips_author = 'DaisukiXCI'
let g:snips_email = 'daisuki@tuxtrooper.com'
let g:snips_github = 'https://github.com/daisukixci'

autocmd FileType python let b:coc_root_patterns = ['.git', '.env']
" Coc configuration
let g:coc_global_extensions = ['coc-css', 'coc-diagnostic', 'coc-eslint', 'coc-explorer', 'coc-git', 'coc-go', 'coc-java', 'coc-json', 'coc-prettier', 'coc-pyright', 'coc-sh', 'coc-snippets', 'coc-solargraph', 'coc-tsserver', 'coc-xml', 'coc-yaml']
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
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
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
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

" CocExplorer
nmap <space>e <Cmd>CocCommand explorer<CR>

" Coc Go
" Add missing imports on save
autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')

" Black configuration
set autoread
command! Black
            \   execute 'silent !black ' . expand('%')
            \ | execute 'redraw!'
autocmd BufWritePost *.py execute ':Black'
"nnoremap <F9> :Black<CR>

" Context config
let g:context_add_mappings = 0

" GH line config
let g:gh_line_map_default = 1
"let g:gh_open_command = 'open '
" let g:gh_open_command = 'fn() { echo "$@" | pbcopy; }; fn '
let g:gh_line_map = '<leader>gh'
let g:gh_line_blame_map = '<leader>gb'
let g:gh_use_canonical = 1

" Terraform config
let g:terraform_fmt_on_save=1
let g:terraform_align=1

" Mapping
map <F5> :lopen<CR>
map <C-l> :lnext<CR>
map <C-m> :lprevious<CR>
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>TA :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>

" Vimspector
packadd! vimspector
let g:vimspector_base_dir = expand( '$HOME/.vim/pack/plugins/start/vimspector' )
let g:vimspector_install_gadgets = [ 'debugpy', 'delve' ]
nmap <leader>B <Plug>VimspectorBreakpoints
nmap <F4>	<Plug>VimspectorRestart
nmap <F5>	<Plug>VimspectorContinue
nnoremap <F6> :call vimspector#Reset()<CR>
nmap <F8>	<Plug>VimspectorAddFunctionBreakpoint
nmap <leader>F8	<Plug>VimspectorRunToCursor
nmap <F9>	<Plug>VimspectorToggleBreakpoint
nmap <leader>F9	<Plug>VimspectorToggleConditionalBreakpoint
nmap <F10>	<Plug>VimspectorStepOver
nmap <F11>	<Plug>VimspectorStepInto
nmap <F12>	<Plug>VimspectorStepOut

" Consider all .yar/.yara files to be YARA files.
autocmd BufNewFile,BufRead *.yar,*.yara setlocal filetype=yara

function Ide()
    :CocCommand explorer
    :wincmd l
    :TagbarToggle
endfunction
command IDE exec Ide()
map <F2> <Esc>:IDE<CR>

augroup encrypted
  au!
  autocmd BufReadPre,FileReadPre *.gpg set viminfo=
  autocmd BufReadPre,FileReadPre *.gpg set noswapfile noundofile nobackup
  autocmd BufReadPre,FileReadPre *.gpg set bin
  autocmd BufReadPre,FileReadPre *.gpg let ch_save = &ch|set ch=2
  autocmd BufReadPost,FileReadPost *.gpg '[,']!gpg --decrypt 2> /dev/null
  autocmd BufReadPost,FileReadPost *.gpg set nobin
  autocmd BufReadPost,FileReadPost *.gpg let &ch = ch_save|unlet ch_save
  autocmd BufReadPost,FileReadPost *.gpg execute ":doautocmd BufReadPost " . expand("%:r")
  autocmd BufWritePre,FileWritePre *.gpg '[,']!gpg --default-recipient-self -ae 2>/dev/null
  autocmd BufWritePost,FileWritePost *.gpg u
augroup END
