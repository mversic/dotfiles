"----------------------------------------------------------------------------------------
" Install vim-plug
"----------------------------------------------------------------------------------------
let plugpath = expand('<sfile>:p:h'). '/autoload/plug.vim'
if !filereadable(plugpath)
    if executable('curl')
        let plugurl = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        call system('curl -fLo ' . shellescape(plugpath) . ' --create-dirs ' . plugurl)
        if v:shell_error
            echom "Error downloading vim-plug. Please install it manually.\n"
            exit
        endif
    else
        echom "vim-plug not installed. Please install it manually or install curl.\n"
        exit
    endif
endif

"----------------------------------------------------------------------------------------
" Plugins
"----------------------------------------------------------------------------------------
call plug#begin('~/.config/nvim/plugged')

Plug 'tpope/vim-sensible'

"  1. Colorschemes and statuslines
"----------------------------------------------------------------------------------------
Plug 'lifepillar/vim-solarized8'
Plug 'itchyny/lightline.vim'
Plug 'bling/vim-bufferline'

"  2. Lint and autocompletion
"----------------------------------------------------------------------------------------
Plug 'dense-analysis/ale'
Plug 'Shougo/deoplete.nvim'

" Snippet support
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

"  3. Project navigation
"----------------------------------------------------------------------------------------
" Fuzzy file finder
Plug 'junegunn/fzf.vim'

" Automatic tag generation
Plug 'ludovicchabant/vim-gutentags'

" View registers by pressing "
Plug 'junegunn/vim-peekaboo'

Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggleVCS', 'NERDTreeFind'] }
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
"Plug 'Xuyuanp/nerdtree-git-plugin'     TODO: Is this bloat?

" Define project root as working dir
Plug 'airblade/vim-rooter'

" Restore cursor on file open
Plug 'dietsche/vim-lastplace'

" Highlight twin words under the cursor
Plug 'dominikduda/vim_current_word'

"  4. Utilities
"----------------------------------------------------------------------------------------
" Pasting fix (Context-aware pasting)
Plug 'sickill/vim-pasta'

" Visually distinct indentation
Plug 'Yggdroot/indentLine'

" Search for selection in visual mode with * and #
Plug 'nelstrom/vim-visual-star-search'

" Git diff indicators
Plug 'mhinz/vim-signify'

" Automatic closing of quotes, parenthesis, brackets, etc.
Plug 'jiangmiao/auto-pairs'

" TODO: Configure
" Smooth scrolling with <C-u> and <C-d>
Plug 'yuttie/comfortable-motion.vim'

" This is slow. It's used rarely and loaded on demand
Plug 'simnalamburt/vim-mundo', { 'on': ['MundoToggle'] }

"TODO: Use if folding is slow
"Plug 'Konfekt/FastFold'

" TODO: Interesting plugins
"----------------------------------------------------------------------------------------
"Plug 'tpope/vim-dispatch'
"Plug 'tpope/vim-surround'
"Plug 'tpope/vim-fugitive'
"Plug 'junegunn/gv.vim'
"Plug 'vim-scripts/YankRing.vim'
"Plug 'markonm/traces.vim'
"Plug 'Valloric/ListToggle'

call plug#end()

