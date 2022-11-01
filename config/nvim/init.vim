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
nnoremap <silent> <leader>ml :setlocal invmodeline <bar> doautocmd BufRead<CR>

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

" Close quickfix/location list on selection
autocmd FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>

" Visual representation of undotree
"----------------------------------------------------------------------------------------
nnoremap <silent> <leader>u :MundoToggle<CR>
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
lua <<EOF
local nvim_lsp = require('lspconfig')

local servers = {
    'rust_analyzer',
    'pyright',
    'gopls',
}

for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
        on_attach = on_attach,
    }
end

require('rust-tools').setup({})
EOF

nnoremap <silent> <space>R <cmd>lua vim.lsp.buf.rename()<CR>

" Code navigation shortcuts
nnoremap <silent> ]w <cmd>lua vim.diagnostic.goto_next()<CR>
nnoremap <silent> [w <cmd>lua vim.diagnostic.goto_prev()<CR>

nnoremap <silent> gr    <cmd>Telescope lsp_references<CR>
nnoremap <silent> g0    <cmd>Telescope lsp_type_definitions<CR>
nnoremap <silent> gi    <cmd>Telescope lsp_implementations<CR>
nnoremap <silent> gd    <cmd>Telescope lsp_definitions<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>

" List all symbols in the document/workspace
nnoremap <silent> gw <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW <cmd>lua vim.lsp.buf.workspace_symbol()<CR>

" Format source code in the current buffer
nnoremap <silent> <leader>f <cmd>lua vim.lsp.buf.format()<CR>
" }}}

" Autocompletion----------------------------------------------------------------------{{{
"----------------------------------------------------------------------------------------
lua <<EOF
local cmp = require('cmp')

cmp.setup({
    completion = {completeopt = 'menu,menuone,noinsert'},

    sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
    },

    mapping = {
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<Tab>']   = cmp.mapping.select_next_item(),
        ['<C-u>']   = cmp.mapping.scroll_docs(-4),
        ['<C-d>']   = cmp.mapping.scroll_docs(4),
        ['<C-q>']   = cmp.mapping.close(),
        ['<CR>']    = cmp.mapping.confirm(),
    },
})

-- Use buffer source for `/`.
-- cmp.setup.cmdline('/', {
--     sources = {
--         { name = 'buffer' }
--     }
-- })

-- -- Use cmdline & path source for ':'.
-- cmp.setup.cmdline(':', {
--     sources = cmp.config.sources({
--         { name = 'path' }
--     }, {
--         { name = 'cmdline' }
--     })
-- })

require('nvim-autopairs').setup{}
EOF

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

" Automatic generation of tags
let g:gutentags_project_root = ['.root']
let g:gutentags_ctags_tagfile = '.tags'

lua <<EOF
require'nvim-tree'.setup {
    view = {
        hide_root_folder = true,
    },

    filters = {
        dotfiles = true,
        --- TODO: add custom filters once patterns are available
        --- custom = { '.*~', '.*\.pyc$', '^\.\?tags.*' }
    },
}
EOF

nnoremap <silent> <C-n>     :NvimTreeToggle<CR>
nnoremap <silent> <leader>n :NvimTreeFindFile<CR>
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
" List all files in project directory
nnoremap <silent> <leader>e <cmd>Telescope find_files<CR>

" List and select all active buffers
nnoremap <silent> <leader>b <cmd>Telescope buffers<CR>

" Search for all references to the word under cursor
nnoremap <silent> <leader>r <cmd>Telescope grep_string<CR>

" Open interface for live grepping
nnoremap <silent> <leader>g <cmd>Telescope live_grep<CR>

nnoremap <silent> <leader>fh <cmd>Telescope help_tags<CR>
nnoremap <silent> <leader>fl <cmd>Telescope git_files<CR>

" TODO: Trying out
"nnoremap <silent> <leader>: :Commands<CR>
"nnoremap <silent> <leader>m :History<CR>

"if isdirectory(".git")
"    " if in a git project, use :GFiles
"    nmap <silent> <leader>t :GFiles<CR>
"else
"    " otherwise, use :FZF
"    nmap <silent> <leader>t :FZF<CR>
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
"nmap <silent> <leader>gs :Gstatus<CR>
"nmap <leader>ge :Gedit<CR>
"nmap <silent><leader>gr :Gread<CR>
"nmap <silent><leader>gb :Gblame<CR>
"
"nmap <leader>m :MarkedOpen!<CR>
"nmap <leader>mq :MarkedQuit<CR>
"nmap <leader>* *<c-o>:%s///gn<CR>

"
"nnoremap <leader>gd :Gdiff<CR>
"nnoremap <leader>gs :Gstatus<CR>
"nnoremap <leader>gw :Gwrite<CR>
"nnoremap <leader>ga :Gadd<CR>
"nnoremap <leader>gb :Gblame<CR>
"nnoremap <leader>gco :Gcheckout<CR>
"nnoremap <leader>gci :Gcommit<CR>
"nnoremap <leader>gm :Gmove<CR>
"nnoremap <leader>gr :Gremove<CR>
"nnoremap <leader>gl :Shell git gl -18<CR>:wincmd \|<CR>
"
"augroup ft_fugitive
"    au!
"
"    au BufNewFile,BufRead .git/index setlocal nolist
"augroup END
"
"" "Hub"
"vnoremap <leader>H :Gbrowse<CR>
"nnoremap <leader>H V:Gbrowse<CR>
"
"" "(Upstream) Hub"
"vnoremap <leader>u :Gbrowse @upstream<CR>
"nnoremap <leader>u V:Gbrowse @upstream<CR>
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

"nnoremap <leader>( :tabprev<CR>        " Move to next tab
"nnoremap <leader>) :tabnext<CR>        " Move to previous tab
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
vmap . :normal .<CR>

" Move to the begining of the line
cnoremap <C-a> <C-b>

" Switch to previous buffer
nmap <leader>. <c-^>

" Wipeout buffer
"nmap <leader>x :bw<CR>
" }}}
" }}}

"----------------------------------------------------------------------------------------
" TODO: Couldn't determine what this does
set errorbells
set visualbell

" TODO: This should find usages of function in combination with ctags
"" cscope
"function! Cscope(option, query)
"  let color = '{ x = $1; $1 = ""; z = $3; $3 = ""; printf "\033[34m%s\033[0m:\033[31m%s\033[0m\011\033[37m%s\033[0m\n", x,z,$0; }'
"  let opts = {
"  \ 'source':  "cscope -dL" . a:option . " " . a:query . " | awk '" . color . "'",
"  \ 'options': ['--ansi', '--prompt', '> ',
"  \             '--multi', '--bind', 'alt-a:select-all,alt-d:deselect-all',
"  \             '--color', 'fg:188,fg+:222,bg+:#3a3a3a,hl+:104'],
"  \ 'down': '40%'
"  \ }
"  function! opts.sink(lines)
"    let data = split(a:lines)
"    let file = split(data[0], ":")
"    execute 'e ' . '+' . file[1] . ' ' . file[0]
"  endfunction
"  call fzf#run(opts)
"endfunction
"
"" Invoke command. 'g' is for call graph, kinda.
"nnoremap <silent> <Leader>g :call Cscope('3', expand('<cword>'))<CR>
