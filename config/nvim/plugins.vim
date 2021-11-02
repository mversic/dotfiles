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

" Sensible Vim defaults
Plug 'tpope/vim-sensible'

"  1. Colorschemes and statuslines {{{
"----------------------------------------------------------------------------------------
Plug 'lifepillar/vim-solarized8'
Plug 'itchyny/lightline.vim'
Plug 'bling/vim-bufferline'
" }}}

"  2. Lint and autocompletion {{{
"----------------------------------------------------------------------------------------
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
" }}}

"  3. Project navigation {{{
"----------------------------------------------------------------------------------------
" Fuzzy file finder
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'
" TODO: Is this required?
Plug 'nvim-lua/popup.nvim'

" Automatic tag generation
Plug 'ludovicchabant/vim-gutentags'

" View registers by pressing "
Plug 'junegunn/vim-peekaboo'

" File explorer tree
Plug 'kyazdani42/nvim-tree.lua'
Plug 'kyazdani42/nvim-web-devicons'

" Define project root as working dir
Plug 'airblade/vim-rooter'

" Restore cursor on file open
Plug 'dietsche/vim-lastplace'

" Highlight twin words under the cursor
Plug 'dominikduda/vim_current_word'
" }}}

"  4. Utilities {{{
"----------------------------------------------------------------------------------------
" Pasting fix (Context-aware pasting)
Plug 'sickill/vim-pasta'

" Visually distinct indentation
Plug 'Yggdroot/indentLine'

" Search for selection in visual mode with * and #
Plug 'nelstrom/vim-visual-star-search'

" Git diff indicators
Plug 'mhinz/vim-signify'

" Visually distinctive yanked lines
Plug 'machakann/vim-highlightedyank'

" Automatic closing of quotes, parenthesis, brackets, etc.
Plug 'windwp/nvim-autopairs'

" TODO: Configure
" Smooth scrolling with <C-u> and <C-d>
Plug 'yuttie/comfortable-motion.vim'

" TODO: This is slow. It's used rarely and loaded on demand
Plug 'simnalamburt/vim-mundo', { 'on': ['MundoToggle'] }

"TODO: Use if folding is slow
"Plug 'Konfekt/FastFold'
" }}}

" 5. Language specific support {{{
"----------------------------------------------------------------------------------------
Plug 'simrat39/rust-tools.nvim'
Plug 'mboughaba/i3config.vim'
Plug 'cespare/vim-toml'
" }}}

" TODO: Interesting plugins
"----------------------------------------------------------------------------------------
"Plug 'tpope/vim-dispatch'
"Plug 'tpope/vim-surround'
"Plug 'junegunn/gv.vim'
"Plug 'vim-scripts/YankRing.vim'
"Plug 'markonm/traces.vim'
"Plug 'Valloric/ListToggle'

"Plug 'tpope/vim-fugitive'
"Plug 'jreybert/vimgit'
"Plug 'rhysd/git-messenger.vim'

"Plug 'troydm/zoomwintab.vim'
"Plug 'tpope/vim-commentary'
"Plug 'kana/vim-textobj-entire'

call plug#end()

