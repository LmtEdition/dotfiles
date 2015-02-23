" Stan's vimrc
" See https://github.com/spf13/spf13-vim for guide
set nocompatible               " be iMproved
filetype off                   " required!

" vim-plug to manage plugins
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes
Plug 'kien/ctrlp.vim'
Plug 'Raimondi/delimitMate'
Plug 'Yggdroot/indentLine'
"Plug 'tomasr/molokai'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'rstacruz/sparkup',    { 'for': 'html' }
Plug 'scrooloose/syntastic'
Plug 'godlygeek/tabular',   { 'on': 'Tabularize' }
Plug 'majutsushi/tagbar'
Plug 'SirVer/ultisnips'
Plug 'bling/vim-airline'
Plug 'altercation/vim-colors-solarized'
Plug 'ap/vim-css-color'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-repeat'
Plug 'honza/vim-snippets'
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-surround'
Plug 'mhinz/vim-tmuxify'
Plug 'Valloric/YouCompleteMe'

" All of your Plugins must be added before the following line
call plug#end()
filetype plugin indent on    " required

" Brief help
" :PlugInstall    - Installs plugins
" :PlugUpdate     - Install or update plugins
" :PlugClean[!]   - confirms removal of unused plugins;
"                   append `!` to auto-approve removal
" :PlugUpgrade    - Upgrade vim- plug itself
" :PlugStatus     - Check the status of plugins
" :PlugDiff       - See the updated changes from the previous PlugUpdate
" :PlugSnapshot   - Generate script for restoring current snapshot of plugins


" General {
    set shell=/bin/bash  " Fish is non POSIX compatible; for plugin support
    function! GetRunningOS()
      if has("win32")
        return "Windows"
      endif
      if has("unix")
        if system('uname')=~'Darwin'
          return "Darwin"
        else
          return "Linux"
        endif
      endif
    endfunction
    let os=GetRunningOS()

    syntax enable        " Syntax highlighting
    set background=dark  " Assume a dark background
    "set mouse=a          " Automatically enable mouse usage, I don't know why this is useful
    set mousehide        " Hide the mouse cursor while typing
    scriptencoding utf-8 " Set encoding for this script
    set encoding=utf-8   " Set file encoding to utf-8

    set shortmess+=filmnrxoOtT " Abbrev. of messages (avoids 'hit enter')
    set history=1000           " Allow more history (default is 20)
    set hidden                 " Allow switching edited buffers without saving

    " Instead of reverting the cursor to the last position in the buffer, we
    " set it to the first line when editing a git commit message
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

    " Jump to the last position when reopening a file
    if has("autocmd")
        au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    endif

    " Save undo history
    if has('persistent_undo')
        set undodir=~/.vim/undodir/ " Put undo files in one place
        set undofile               " Allow persistent undo
        set undolevels=1000        " Maximum number of changes that can be undone
        set undoreload=10000       " Maximum number lines to save for undo on a buffer reload
    endif

    " Time out on key codes but not mappings.
    " Basically this makes terminal Vim work sanely.
    set notimeout
    set ttimeout
    set ttimeoutlen=100
" }

" Vim UI {
    set title      " Set terminal title
    set showmode   " Show Insert, Visual, Replace modes in status line
    "set cursorline " Highlight current line

    if has('cmdline_info')
        set ruler   " Show column numbers
        set showcmd " Shows info on current command
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids"
    endif

    if has('statusline')
        set laststatus=2 " Last window will always show status line

        " Broken down into easily includeable segments
        set statusline=%<%f\                         " Filename
        set statusline+=%w%h%m%r                     " Options
        if isdirectory(expand("~/.vim/plugged/vim-fugitive/"))
            set statusline+=%{fugitive#statusline()} " Git Hotness
        endif
        set statusline+=\ [%{&ff}/%Y]                " Filetype
        set statusline+=\ [%{getcwd()}]              " Current dir
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%      " Right aligned file nav info
    endif

    set backspace=indent,eol,start " Backspace through everything in insert mode
    set number                     " Show line numbers in VIM
    "set relativenumber             " Show line numbers relative to current line
    set showmatch                  " Shows matching parentheses

    " Search {
        set ignorecase " Case insensitive
        set smartcase  " Search case sensitive only with uppercase keyword
        set incsearch  " Incremental search
        set hlsearch   " Highlight search terms
        set wildmenu   " Show list of autocompletes instead of just completing
        set wildignore+=*/tmp/*,*.so,*.swp,*.zip
        "set wildmode=list:longest,full " List matches, then longest common part, then all.
    " }

    " Scrolling {
        set scrolloff=8  " Start scrolling when we're 8 lines away from margins
        set sidescrolloff=15
        set sidescroll=1
    " }

    " Folds {
        set nofoldenable        " Dont fold by default
        set foldmethod=indent   " Fold based on indentation
        set foldnestmax=5       " Deepest fold is 5 levels
    " }

    " Highlight whitespaces for tabs, trailing whitespace, and invisible spaces
    " Uses '...' to denote whitespaces
    " Use # sign at the end of lines to mark lines that extend off-screen
    set list
    set listchars=tab:»·,trail:·,extends:#,nbsp:.
" }

" Formatting {
    set nowrap        " Do not wrap long lines
    set autoindent    " Copy indentation of previous line
    set expandtab     " Tabs are spaces, not tabs
    set shiftwidth=2  " Use indents of 2 spaces
    set tabstop=2     " An indentation every 2 columns
    set softtabstop=2 " Let backspace delete indent
    set shiftround    " Indenting with < or > will align to multiples of shiftwidth
    set splitright    " Puts new vsplit windows to the right of the current
    set splitbelow    " Puts new split windows to the bottom of the current

    " Sane indentation on pastes
    " Note: set paste will mess up plugin indentation when on
    nnoremap <F2> :set invpaste paste?<CR>
    set pastetoggle=<F2>
    au InsertLeave * set nopaste " Leave paste mode on exit
" }

" GUI Settings {
    " Remove ctermbg so that the colorscheme background is consistent
    "highlight Normal ctermbg=NONE
    "highlight nonText ctermbg=NONE

    if has('gui_running')
        if os=="Darwin"
          set fullscreen " Start graphical vim in full screen mode

          set guifont=Sauce\ Code\ Powerline\ Semibold:h14
        else
          set guifont=Source\ Code\ Pro\ for\ Powerline\ Semi-Bold\ 14
        endif

        "set guioptions-=T " Remove the toolbar
        set lines=40      " 40 lines of text instead of 24
    else
        " Allow 256 color setting here or
        " in .bashrc: 'export TERM="xterm-256color"'
        if &term == 'xterm' || &term == 'screen'
            set t_Co=256 " Enable 256 colors
        endif
    endif

    " Colors if terminal support 256 colors or in GVIM
    if &t_Co >= 256 || has('gui_running')
        colorscheme solarized
        highlight clear SignColumn " solarized has bad sign column color
    endif

    " Sets a column border
    if exists('+colorcolumn')
        set colorcolumn=81

        " Shades all columns to the right of the colorcolumn
        "execute 'set colorcolumn=' . join(range(81,335), ',')
        "if has('gui_running')
            "highlight ColorColumn guibg=#293739
        "else
            "highlight ColorColumn ctermbg=234
        "endif
    endif
" }

" Key (re)Mappings {
    " Change the mapleader from default \ to ,
    let mapleader=','

    " Easier window navigation
    map <C-h> <C-w>h
    map <C-j> <C-w>j
    map <C-k> <C-w>k
    map <C-l> <C-w>l

    " Wrapped lines goes down/up to next row, rather than next line in file.
    nnoremap j gj
    nnoremap k gk

    " Yank from cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    " Unhighlight searches
    nmap <silent> <leader>/ :nohlsearch<CR>

    " Find merge conflict markers
    map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

    " Visual shifting (does not exit Visual mode)
    "vnoremap < <gv
    "vnoremap > >gv

    " Write to file that needs root permission
    cmap w!! w !sudo tee > /dev/null %

    " Adjust viewports to the same size
    map <leader>= <C-w>=

    " Map <leader>ff to display all lines with keyword under cursor and
    " ask which one to jump to. Type '.<CR>' to remain on same line.
    nmap <leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

    " Easier horizontal scrolling
    map zl zL
    map zh zH

    " Buffer management {
        " Opens a new buffer with the current buffer's path
        map <leader>e :edit <c-r>=expand("%:p:h")<CR>/

        " Switch CWD to the directory of the open buffer
        map <leader>cd :cd %:p:h<CR>:pwd<CR>

        " Close the current buffer
        map <leader>x :bd<CR>

        " Close all the buffers
        map <leader>bw :1,1000 bd!<CR>

        " Show a selectable list of buffers
        map gb :ls<CR>:buffer<Space>

        " Easy buffer switching
        map <leader>n :bn<CR>
        map <leader>p :bp<CR>

        " Toggle between last open buffers
        nnoremap <leader>6 <C-^>
    " }

    " Instead of <S-;> can just type ;
    noremap ; :
    " Regain searching functionality with ; for f or t
    noremap ;; ;

    " Use Q for formatting the current paragraph (or selection)
    vmap Q gq
    nmap Q gqap

    " Switch between popular and unpopular tab modes
    "nmap <leader>t :set expandtab tabstop=4 shiftwidth=4 softtabstop=4<CR>
    "nmap <leader>m :set expandtab tabstop=2 shiftwidth=2 softtabstop=2<CR>

    " Remove trailing whitespace
    " If replacement fails, command exits before last save.
    " So save in the middle.
    nmap <leader>tw gg=G:retab<CR>``:w<CR>:%s/\s\+$//g<CR>:w<CR>

    " For local replace
    nnoremap gr gd[{V%:s/<C-R>///gc<left><left><left>

    " For global replace
    nnoremap gR gD:%s/<C-R>///gc<left><left><left>

    " Toggle spell check
    nnoremap <leader>sc :set spell!<CR>
" }


" Ctags - code indexer via exuberant-ctags {
    " Look in the cur dir up the tree towards ~/.vimtags until 'tags' found
    set tags=./tags;/,~/.vimtags

    " Make tags placed in .git/tags file available in all levels of a repo
    let gitroot = substitute(system('git rev-parse --show-toplevel'),
            \ '[\n\r]', '', 'g')
    if gitroot != ''
        let &tags = &tags . ',' . gitroot . '/.git/tags'
    endif

    " Open the definition in a vertical split
    map <C-\> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
" }


" Native omnicomplete {
    " This doesn't seem to work properly
    "if has("autocmd") && exists("+omnifunc")
        "autocmd FileType *
            "\if &omnifunc == "" |
            "\setlocal omnifunc=syntaxcomplete#Complete |
            "\endif
    "endif
    set omnifunc=syntaxcomplete#Complete

    " Some convenient mappings
    "inoremap <expr> <Esc> pumvisible() ? "\<C-e>" : "\<Esc>"
    "inoremap <expr> <Down> pumvisible() ? "\<C-n>" : "\<Down>"
    "inoremap <expr> <Up> pumvisible() ? "\<C-p>" : "\<Up>"
    "inoremap <expr> <C-d> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
    "inoremap <expr> <C-u> pumvisible() ? "\<PageUp>\<C-p>\<C-u>" : "\<C-u>"

    " Automatically open and close the popup menu / preview window
    "au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
    "set completeopt=menu,preview,longest
" }


" ctrlp.vim - full path fuzzy file, buffer, mru, tag finder {
    if isdirectory(expand("~/.vim/plugged/ctrlp.vim/"))
        " Set ctrlp's local working directory to the nearest ancestor
        " containing .git, .hg, .svn (option r). If none found, then fallback
        " to the directory of the current file (option a).
        let g:ctrlp_working_path_mode = 'ra'

        " CtrlP speed up by ignoring
        let g:ctrlp_custom_ignore = {
            \ 'dir': '\v[\/]\.(git|hg|svn)$\|review$',
            \ 'file': '\v\.(exe|so|dll|pyc)$\|tags',
            \ 'link': '',
            \ }

        let g:ctrlp_max_files = 10000 " Max files to scan

        let g:ctrlp_map = '<C-p><C-p>'       " Allow similar bindings in other modes
        nnoremap <C-p><C-b> :CtrlPBuffer<CR> " Fuzzy find through buffers
        nnoremap <C-p><C-m> :CtrlPMRU<CR>    " Fuzzy find through MRU files
        nnoremap <C-p><C-t> :CtrlPTag<CR>    " Fuzzy find through tags file
    endif
" }


" delimitMate - auto close quotes, parentheses, brackets, etc. {
    if isdirectory(expand("~/.vim/plugged/delimitMate"))
        " Expand on return key so that the next line is indented on enter
        let delimitMate_expand_cr = 1
    endif
" }


" indentLine - display vertical lines for indentation level {
    if isdirectory(expand("~/.vim/plugged/indentLine"))
        let g:indentLine_color_term = 239
        let g:indentLine_color_gui = '#4e4e4e'
        let g:indentLine_char = '┊'
    endif
" }


" nerdtree - filesystem explorer {
    if isdirectory(expand("~/.vim/plugged/nerdtree"))
        nmap <leader>nt :NERDTreeToggle<CR>
        nmap <leader>nf :NERDTreeFind<CR>

        let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$',
            \ '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']

        " Single click to open directories, double click to open files.
        let NERDTreeMouseMode=2

        " Close vim when the only window open is NERDTree
        au bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

    endif
" }


" Ag - The Silver Searcher - faster grep {
    if executable('ag')
        " Use ag over grep
        set grepprg=ag\ --nogroup\ --nocolor\ --smart-case\ --column

        " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
        let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

        " ag is fast enough that CtrlP doesn't need to cache
        let g:ctrlp_use_caching = 0
    endif

    " bind K to grep word under cursor
    nnoremap K :grep! "<C-R><C-W>"<CR>:cw<CR>
    nnoremap <leader>k :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

    " Define new command to search for provided text and open 'quickfix'
    command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!

    " bind \ (backward slash) to grep shortcut
    nnoremap \ :Ag<SPACE>
" }


" syntastic - syntax checking {
    if isdirectory(expand("~/.vim/plugged/syntastic"))
        let g:syntastic_check_on_open = 1 " Syntax check on buffer load and save

        " Always stick detected errors into location-list
        let g:syntastic_always_populate_loc_list = 1

        " Open location-list to display syntax errors
        nmap <leader>lo :lopen<CR>
    endif
" }


" tabular - auto-align text {
    if isdirectory(expand("~/.vim/plugged/tabular"))
        nmap <leader>a& :Tabularize /&<CR>
        vmap <leader>a& :Tabularize /&<CR>
        nmap <leader>a= :Tabularize /=<CR>
        vmap <leader>a= :Tabularize /=<CR>
        nmap <leader>a=> :Tabularize /=><CR>
        vmap <leader>a=> :Tabularize /=><CR>
        nmap <leader>a: :Tabularize /:<CR>
        vmap <leader>a: :Tabularize /:<CR>
        nmap <leader>a:: :Tabularize /:\zs<CR>
        vmap <leader>a:: :Tabularize /:\zs<CR>
        nmap <leader>a, :Tabularize /,<CR>
        vmap <leader>a, :Tabularize /,<CR>
        nmap <leader>a,, :Tabularize /,\zs<CR>
        vmap <leader>a,, :Tabularize /,\zs<CR>
        nmap <leader>a<Bar> :Tabularize /<Bar><CR>
        vmap <leader>a<Bar> :Tabularize /<Bar><CR>
    endif
" }


" tagbar - displays tags of current file in sidebar {
    if isdirectory(expand("~/.vim/plugged/tagbar/"))
        nmap <F8> :TagbarToggle<CR>
    endif
" }


" ultisnips - expand key triggers into full snippets {
    if isdirectory(expand("~/.vim/plugged/ultisnips"))
        " Allow ultisnips to work with youcompleteme
        let g:UltiSnipsExpandTrigger='<C-j>'
        let g:UltiSnipsJumpForwardTrigger='<C-j>'
        let g:UltiSnipsJumpBackwardTrigger='<C-k>'

        " Allow ultisnips to list snippets
        let g:UltiSnipsListSnippets='<C-l>'
    endif
" }


" vim-airline - pretty status line {
    if isdirectory(expand("~/.vim/plugged/vim-airline/"))
        let g:airline_powerline_fonts = 1
    endif
"}


" vim-colors-solarized - Solarized colorscheme {
    if isdirectory(expand("~/.vim/plugged/vim-colors-solarized/"))
      call togglebg#map("")
    endif
"}


" vim-fugitive - Git wrapper {
    if isdirectory(expand("~/.vim/plugged/vim-fugitive"))
        nnoremap <silent> <leader>gs :Gstatus<CR>
        nnoremap <silent> <leader>gd :Gdiff<CR>
        nnoremap <silent> <leader>gc :Gcommit<CR>
        nnoremap <silent> <leader>gb :Gblame<CR>
        nnoremap <silent> <leader>gl :Glog<CR>
        nnoremap <silent> <leader>gp :Gpush<CR>
        nnoremap <silent> <leader>gr :Gread<CR>
        nnoremap <silent> <leader>gw :Gwrite<CR>
        nnoremap <silent> <leader>ge :Gedit<CR>

        " Mnemonic _i_nteractive
        nnoremap <silent> <leader>gi :Git add -p %<CR>
    endif
" }


" vim-gitgutter - display git diff signs {
    if isdirectory(expand("~/.vim/plugged/vim-gitgutter"))
        " Escape grep since we've aliased grep to ag
        let g:gitgutter_escape_grep = 1

        " Toggle gitgutter plugin
        nnoremap <silent> <leader>gg :GitGutterToggle<CR>
    endif
" }


" vim-startify - start fancy fresh vim {
    if isdirectory(expand("~/.vim/plugged/vim-startify"))
        " Don't change into directory of selected file so that ag searching
        " will work across subdirectories
        let g:startify_change_to_dir = 0
        let g:startify_files_number = 20 " Show more files
    endif
" }


" vim-tmuxify - bridge between vim and tmux {
    if isdirectory(expand("~/.vim/plugged/vim-tmuxify"))
      " Custom tmux create command
      let g:tmuxify_custom_command = 'tmux split-window -d -p 20'
    endif
" }


" YouCompleteMe - autocomplete {
    if isdirectory(expand("~/.vim/plugged/YouCompleteMe"))
        " Enable completion from tags
        let g:ycm_collect_identifiers_from_tags_files = 1

        "let g:ycm_global_ycm_extra_conf =
            "\ '~/.vim/plugged/YouCompleteMe/.ycm_extra_conf.py'

        " Enable omni completion.
        autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
        autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
        autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
        autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
        autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
        autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
        autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

        " If not using YCM's clang semantic completer and want to use
        " Syntastic's gcc checker
        let g:ycm_show_diagnostics_ui = 0
    endif
" }


