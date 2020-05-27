" Source plugins
source ~/.config/nvim/plugins.vim

" Global prefix key
nnoremap <space> <Nop>
let mapleader = " "

" General settings--------------------------------------------------------------------{{{
"----------------------------------------------------------------------------------------
set confirm                 " ask to save on accidental quit
set timeoutlen=400          " time in ms to accept successive keystrokes
set nomodeline              " https://www.gilesorr.com/blog/vim-tips-22-modelines.html
set undofile                " persist undo history between sessions
set showcmd                 " show command keypresses in command line
set hidden                  " buffer can be put into background

" toggle use of modelines. Modelines must be executed manually afterwards
nnoremap <silent> <leader>ml :setlocal invmodeline <bar> doautocmd BufRead<cr>

"" Avoid accidental quits with confirmation menu
"cnoremap <silent> q<CR>  :call ConfirmQuit(0)<CR>
"cnoremap <silent> x<CR>  :call ConfirmQuit(1)<CR>
"function! ConfirmQuit(writeFile)
"    if (a:writeFile)
"        if (expand('%:t')=="")
"            echo "Can't save a file with no name."
"            return
"        endif
"        :write
"    endif
"
"    if (winnr('$')==1 && tabpagenr('$')==1)
"        if (confirm("Do you really want to quit?", "&Yes\n&No", 2)==1)
"            :quit
"        endif
"    else
"        :quit
"    endif
"endfu

augroup configgroup
    autocmd!

    " strip whitespace on save
    autocmd BufWritePre * :%s/\s\+$//e

    " resize windows automatically
    autocmd VimResized * :wincmd =

    " source vimrc on every save to see modification effects immediately
    autocmd! BufWritePost *vimrc,init.vim ++nested source % | redraw
augroup END

" Visual representation of undotree
"----------------------------------------------------------------------------------------
nnoremap <silent> <leader>u :MundoToggle<cr>
let g:mundo_preview_bottom = 1
let g:mundo_verbose_graph=0
let g:mundo_right = 1
" }}}

" Color scheme and syntax highlighting------------------------------------------------{{{
"----------------------------------------------------------------------------------------
set termguicolors           " Use 24-bit truecolor support
set background=dark         " Colorscheme theme (dark/light)
set synmaxcol=500           " Maximal row length to highlight

let g:solarized_extra_hi_groups=1
let g:solarized_visibility = "low"
let g:solarized_termtrans=1
colorscheme solarized8_high

highlight CursorLine gui=underline guibg=none

" Go syntax highlighting {{{
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_function_calls = 1
" }}}
" }}}

" Viewport definition-----------------------------------------------------------------{{{
"----------------------------------------------------------------------------------------

" ↳ Viewport management {{{
"----------------------------------------------------------------------------------------
set lazyredraw              " don't redraw screen while executing macros
set splitbelow              " open horizontal splits below current window
set splitright              " open vertical splits right of the current window

" Save viewport cursor position
function! AutoSaveWinView()
    if !exists("w:SavedBufView")
        let w:SavedBufView = {}
    endif

    let w:SavedBufView[bufnr("%")] = winsaveview()
endfunction

" Restore viewport cursor position
function! AutoRestoreWinView()
    let buf = bufnr("%")

    if exists("w:SavedBufView") && has_key(w:SavedBufView, buf)
        let v = winsaveview()
        let atStartOfFile = v.lnum == 1 && v.col == 0

        if atStartOfFile && !&diff
            call winrestview(w:SavedBufView[buf])
        endif

        unlet w:SavedBufView[buf]
    endif
endfunction

if v:version >= 700
    autocmd BufLeave * call AutoSaveWinView()
    autocmd BufEnter * call AutoRestoreWinView()
endif

" Don't display signcolumn when listing registers
let g:peekaboo_window = "vert bo 30new | set scl=no"
" }}}

" ↳ Viewport style {{{
"----------------------------------------------------------------------------------------
set list                    " show whitespace characters

set number                  " show line numbers
set cursorline              " color the line where cursor is located
set colorcolumn=90          " color up last column
set signcolumn=yes          " show sign column (git,lint symbols)

" Define visual representation of whitespace characters
set listchars=tab:\|>\ ,eol:¬,space:·,extends:❯,precedes:❮
set showbreak=↳             " wrap continuation character

" Statusline settings
"----------------------------------------------------------------------------------------
set noshowmode              " don't echo current mode in command line, statusline does that

let g:lightline = {
  \ 'colorscheme': 'solarized',
  \ 'component': {
  \   'filename': '%F',
  \ }
\ }
" }}}
" }}}

" Text formatting and display---------------------------------------------------------{{{
"----------------------------------------------------------------------------------------
" Don't autoinsert comment leader on 'o' and 'O'
autocmd FileType * setlocal formatoptions-=o

" ↳ Line wrapping {{{
"----------------------------------------------------------------------------------------
set nowrap                  " don't wrap by default
set linebreak               " break on whole words
set breakindent             " indent wrapped lines as the first line
set textwidth=0             " don't do hard wrap(don't insert \n on wrap)

" Toggle wrap shortcut
nnoremap <silent> <leader>w :set wrap!<CR>
" }}}

" ↳ Indentation {{{
"----------------------------------------------------------------------------------------
set expandtab               " insert spaces rather than tabs for <Tab>
set tabstop=8               " the visible width of tabs
set softtabstop=4           " edit as if the tabs are 4 characters wide
set shiftwidth=4            " number of spaces used for indent and unindent
set shiftround              " round indent to a multiple of 'shiftwidth'
" }}}

" ↳ Code folding {{{
"----------------------------------------------------------------------------------------
set foldmethod=syntax       " define folds by language syntax
set foldlevelstart=1        " don't autofold n outer folds
set foldnestmax=3           " deepest fold is 3 levels set foldlevel=2
set foldlevel=3
set foldcolumn=1
set foldtext=MyFoldText('\ ')   " string representation of fold

" toggle folds with Enter
nnoremap <CR> za

"function! MyFoldText()
"    let line = getline(v:foldstart)
"    let nucolwidth = &fdc + &number * &numberwidth + 2
"    let windowwidth = winwidth(0) - nucolwidth - 3
"    let rhs = (v:foldend - v:foldstart) . " L"
"
"    " expand tabs into spaces
"    let onetab = strpart(' ', 0, &tabstop)
"    let line = substitute(line, '\t', onetab, 'g')
"    let line = strpart(line, 0, windowwidth - 2 -len(rhs))
"    let fillcharcount = windowwidth - len(line) - len(rhs)
"
"    return line . '…' . repeat(" ",fillcharcount) . rhs . '…' . ' '
"endfunction
function! MyFoldText(string)
    "get first non-blank line
    let fs = v:foldstart
    if getline(fs) =~ '^\s*$'
      let fs = nextnonblank(fs + 1)
    endif
    if fs > v:foldend
        let line = getline(v:foldstart)
    else
        let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
    endif
    let pat  = matchstr(&l:cms, '^\V\.\{-}\ze%s\m')
    " remove leading comments from line
    let line = substitute(line, '^\s*'.pat.'\s*', '', '')
    " remove foldmarker from line
    let pat  = '\%('. pat. '\)\?\s*'. split(&l:fmr, ',')[0]. '\s*\d\+'
    let line = substitute(line, pat, '', '')

"   let line = substitute(line, matchstr(&l:cms,
"           \ '^.\{-}\ze%s').'\?\s*'. split(&l:fmr,',')[0].'\s*\d\+', '', '')

    let w = get(g:, 'custom_foldtext_max_width', winwidth(0)) - &foldcolumn - (&number ? 8 : 0)
    let foldSize = 1 + v:foldend - v:foldstart
    let foldSizeStr = " " . foldSize . " lines "
    let foldLevelStr = '+'. v:folddashes
    let lineCount = line("$")
    if exists("*strwdith")
        let expansionString = repeat(a:string, w - strwidth(foldSizeStr.line.foldLevelStr))
    else
        let expansionString = repeat(a:string, w - strlen(substitute(foldSizeStr.line.foldLevelStr, '.', 'x', 'g')))
    endif
    return line . expansionString . foldSizeStr . foldLevelStr
endf

" Enable folding for vim config file specifically
autocmd BufRead *vimrc,*init.vim,*plugins.vim setlocal foldmethod=marker foldlevel=0
" }}}
" }}}

" Linting-----------------------------------------------------------------------------{{{
"----------------------------------------------------------------------------------------
let g:ale_change_sign_column_color = 1

highlight ALEWarningSign guibg=none
highlight ALEErrorSign   guibg=none

let g:ale_linters = {
  \ 'python': ['pyls'],
  \ 'rust': ['rls'],
  \ 'go': ['gopls'],
\ }

" Location of go language server executable
let g:ale_go_gopls_executable = $HOME . '/go/bin/gopls'

" List both test and examples for rust
let g:ale_rust_cargo_check_tests = 1
let g:ale_rust_cargo_check_examples = 1

" Disable vim-go autocompletion and lint
let g:go_code_completion_enabled = 0
let g:go_gopls_enabled = 0
let g:go_fmt_autosave = 0
let g:go_echo_go_info = 0

" Position cursor to next error
nmap [w <plug>(ale_previous_wrap)
nmap ]w <plug>(ale_next_wrap)
" }}}

" Autocompletion----------------------------------------------------------------------{{{
"----------------------------------------------------------------------------------------
" TODO: This is a good feature, but needs to be made context aware
" Issue tracker (https://github.com/jiangmiao/auto-pairs/issues/270)
let g:AutoPairsMultilineClose = 0

let g:deoplete#enable_at_startup = 1
call deoplete#custom#option({
  \ 'smart_case': v:true,
\ })
let g:UltiSnipsExpandTrigger="<C-Space>"

" Don't abbreviate the list of suggested comletions
call deoplete#custom#source('_', 'max_menu_width', 0)
call deoplete#custom#source('_', 'max_abbr_width', 0)
call deoplete#custom#source('_', 'max_kind_width', 0)

" Navigate completion menu with Tab
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Disable autocompletion in Comment/String syntaxes
call deoplete#custom#source('_', 'disabled_syntaxes', ['Comment', 'String'])

" TODO: Is this fine?
" Disable context aware autocompletion, use only language keyword completion
call deoplete#custom#option('ignore_sources', {'_': ['around', 'buffer']})

" Autoclose preview window after autocompletion
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | silent! pclose | endif

" set complete=.,w,b,u,t
"set completeopt+=longest
"set completeopt-=preview
"
" Insert Mode Completion
"inoremap <c-f> <c-x><c-f>
"inoremap <c-]> <c-x><c-]>
"inoremap <c-l> <c-x><c-l>

"TODO: Decide where to show autocomplete preview
" Show preview window on the right
"augroup previewWindowPosition
"   au!
"   autocmd BufWinEnter * call PreviewWindowPosition()
"augroup END
"function! PreviewWindowPosition()
"   if &previewwindow
"      wincmd L
"   endif
"endfunction

" Command line autocompletion
set wildmode=longest:full,full  " completion format, alternatively: (longest:list,full)
set wildignorecase              " ignore case in command line completion
" }}}

" Project navigation------------------------------------------------------------------{{{
"----------------------------------------------------------------------------------------
let g:rooter_silent_chdir = 1

"Close vim if only NERD tree is open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree")
  \ && b:NERDTree.isTabTree()) | q | endif

let NERDTreeShowHidden = 1

let NERDTreeDirArrowExpandable = '▸'
let NERDTreeDirArrowCollapsible = '▿'

let NERDTreeIgnore = ['\~$', '.*\.pyc$', '^\.\?tags.*']

" NERDTree syntax highlight (separate plugin)
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1

" Automatic generation of tags
let g:gutentags_project_root = ['.root']
let g:gutentags_ctags_tagfile = '.tags'

nnoremap <silent> <leader>n :NERDTreeFind<CR> :set scl=no<CR>
nnoremap <silent> <C-n> :NERDTreeToggleVCS<CR> :set scl=no<CR>

nnoremap <silent> <leader>] :ALEGoToDefinition<CR>
nnoremap <silent> <leader>d :ALEFindReferences<CR>
" }}}

" Searching --------------------------------------------------------------------------{{{
"----------------------------------------------------------------------------------------
set ignorecase              " case insensitive searching
set smartcase               " case sensitive only if capital letter is present
set hlsearch                " highlight all search results, not just current
set showmatch               " jump to matching brace and back when inserting brace

if (has('nvim'))
    set inccommand=nosplit " show real-time substition in current window
endif

let g:vim_current_word#highlight_current_word = 0
let g:vim_current_word#highlight_delay = 500

if &background == "dark"
    highlight CurrentWordTwins guibg=#073642
    highlight CurrentWord      guibg=#073642
else
    highlight CurrentWordTwins guibg=#fdf6e3
    highlight CurrentWord      guibg=#fdf6e3
endif

" ↳ Fuzzy file finder {{{
"----------------------------------------------------------------------------------------
let g:fzf_prefer_tmux = 1

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(
    \ <q-args>,
    \ {'options': ['--info=inline', '--preview', 'bat {} --color=always']},
    \ <bang>0
\ )

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --no-heading --line-number --column --hidden --follow --color=always '.shellescape(<q-args>),
  \ 1, fzf#vim#with_preview(), <bang>0
\ )

let g:fzf_action = {
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit',
  \ 'ctrl-t': 'tab split'
\ }

" List all files in project directory
nnoremap <silent> <leader>e :<C-l>Files<cr>

" List and select all active buffers
nnoremap <silent> <leader>b :Buffers<cr>

" Search for all occurrences of word under cursor
nnoremap <silent> <leader>r :Rg <C-R><C-W><CR>

" TODO: Trying out
"nnoremap <silent> <leader>: :Commands<CR>
"nnoremap <silent> <leader>m :History<CR>

"if isdirectory(".git")
"    " if in a git project, use :GFiles
"    nmap <silent> <leader>t :GFiles<cr>
"else
"    " otherwise, use :FZF
"    nmap <silent> <leader>t :FZF<cr>
"endif

"" Insert mode completion
"imap <c-x><c-k> <plug>(fzf-complete-word)
"imap <c-x><c-f> <plug>(fzf-complete-path)
"imap <c-x><c-j> <plug>(fzf-complete-file-rg)
"imap <c-x><c-l> <plug>(fzf-complete-line)
" }}}
" }}}

" Git integration---------------------------------------------------------------------{{{
"----------------------------------------------------------------------------------------
highlight DiffAdd    guibg=none
highlight DiffChange guibg=none
highlight DiffDelete guibg=none

" Fugitive Shortcuts
"nmap <silent> <leader>gs :Gstatus<cr>
"nmap <leader>ge :Gedit<cr>
"nmap <silent><leader>gr :Gread<cr>
"nmap <silent><leader>gb :Gblame<cr>
"
"nmap <leader>m :MarkedOpen!<cr>
"nmap <leader>mq :MarkedQuit<cr>
"nmap <leader>* *<c-o>:%s///gn<cr>

"
"nnoremap <leader>gd :Gdiff<cr>
"nnoremap <leader>gs :Gstatus<cr>
"nnoremap <leader>gw :Gwrite<cr>
"nnoremap <leader>ga :Gadd<cr>
"nnoremap <leader>gb :Gblame<cr>
"nnoremap <leader>gco :Gcheckout<cr>
"nnoremap <leader>gci :Gcommit<cr>
"nnoremap <leader>gm :Gmove<cr>
"nnoremap <leader>gr :Gremove<cr>
"nnoremap <leader>gl :Shell git gl -18<cr>:wincmd \|<cr>
"
"augroup ft_fugitive
"    au!
"
"    au BufNewFile,BufRead .git/index setlocal nolist
"augroup END
"
"" "Hub"
"vnoremap <leader>H :Gbrowse<cr>
"nnoremap <leader>H V:Gbrowse<cr>
"
"" "(Upstream) Hub"
"vnoremap <leader>u :Gbrowse @upstream<cr>
"nnoremap <leader>u V:Gbrowse @upstream<cr>
"
"" Highlight VCS conflict markers
"match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
" }}}

" Built-in key mappings---------------------------------------------------------------{{{
"----------------------------------------------------------------------------------------
" ↳ Movement keys {{{
"----------------------------------------------------------------------------------------
" Move over wrapped lines in practical manner
nnoremap <silent> <expr> j  v:count ?  'j' : 'gj'
nnoremap <silent> <expr> k  v:count ?  'k' : 'gk'
nnoremap <silent> <expr> gj v:count ? 'gj' :  'j'
nnoremap <silent> <expr> gk v:count ? 'gk' :  'k'

"nnoremap <leader>( :tabprev<cr>        " Move to next tab
"nnoremap <leader>) :tabnext<cr>        " Move to previous tab
" }}}

" ↳ Yanking and pasting {{{
"----------------------------------------------------------------------------------------
let g:pasta_disabled_filetypes = []

" More sound than the default
nmap <silent> Y y$

" Copy til the end of the line to clipboard
nmap <leader>Y "+y$

" Copy to clipboard
nmap <leader>y "+yy

" Paste from clipboard after cursor
nmap <leader>p "+p

" Paste from clipboard before cursor
nmap <leader>P "+P
" }}}

" ↳ Miscellaneous {{{
"----------------------------------------------------------------------------------------
" Update rather then write
" TODO: Make up mapping for updating instead of writing

" Enable repeat command in visual mode
vmap . :normal .<cr>

" Move to the begining of the line
cnoremap <C-a> <C-b>

" Switch to previous buffer
nmap <leader>. <c-^>

" Wipeout buffer
"nmap <leader>x :bw<cr>
" }}}
" }}}

"----------------------------------------------------------------------------------------
" TODO: Couldn't determine what this does
set errorbells
set visualbell

