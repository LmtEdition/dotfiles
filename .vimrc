" Stan's vimrc.
" See https://github.com/spf13/spf13-vim for guide.
set nocompatible          " Be iMproved.
filetype plugin indent on " Turn on filetype plugins.

" vim-plug to manage plugins.
if has('nvim')
  let s:config_dir = '~/.nvim'
else
  let s:config_dir = '~/.vim'
endif
let s:plugin_dir = s:config_dir . '/plugged'

silent! if plug#begin(s:plugin_dir)

Plug 'ctrlpvim/ctrlp.vim'
Plug 'Raimondi/delimitMate'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'sjl/gundo.vim', { 'on': 'GundoToggle' }
Plug 'Yggdroot/indentLine'
"Plug 'tomasr/molokai'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
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
Plug 'ludovicchabant/vim-gutentags'
Plug 'pangloss/vim-javascript'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-repeat'
Plug 'honza/vim-snippets'
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-surround'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'mhinz/vim-tmuxify'
Plug 'tpope/vim-unimpaired'
Plug 'Valloric/YouCompleteMe'

call plug#end()
endif

" Brief help
" :PlugInstall    - Installs plugins
" :PlugUpdate     - Install or update plugins
" :PlugClean[!]   - confirms removal of unused plugins;
"                   append `!` to auto-approve removal
" :PlugUpgrade    - Upgrade vim-plug itself
" :PlugStatus     - Check the status of plugins
" :PlugDiff       - See the updated changes from the previous PlugUpdate
" :PlugSnapshot   - Generate script for restoring current snapshot of plugins


" General {
  set shell=/bin/bash  " Fish is non POSIX compatible; for plugin support.
  function! GetRunningOS()
    if has('win32')
      return 'Windows'
    endif
    if has('unix')
      if system('uname')=~'Darwin'
        return 'Darwin'
      else
        return 'Linux'
      endif
    endif
  endfunction
  let s:os=GetRunningOS()

  syntax enable        " Syntax highlighting.
  set background=dark  " Assume a dark background.
  "set mouse=a          " Automatically enable mouse usage, I don't know why this is useful.
  set mousehide        " Hide the mouse cursor while typing.
  set encoding=utf-8   " Set file encoding to utf-8.

  set shortmess+=filmnrxoOtT " Abbrev. of messages (avoids 'hit enter').
  set history=1000           " Allow more history (default is 20).
  set hidden                 " Allow switching edited buffers without saving.

  " Instead of reverting the cursor to the last position in the buffer, we
  " set it to the first line when editing a git commit message.
  au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

  " Jump to the last position when reopening a file.
  if has('autocmd')
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
  endif

  " Set to autoread when a file is changed from the outside.
  set autoread

  " Save undo history
  if has('persistent_undo')
    let &undodir = s:config_dir . '/undodir/' " Put undo files in one place.
    set undofile         " Allow persistent undo.
    set undolevels=1000  " Maximum number of changes that can be undone.
    set undoreload=10000 " Maximum number lines to save for undo on a buffer reload.
  endif

  " Time out on key codes but not mappings.
  " Basically this makes terminal Vim work sanely.
  set notimeout
  set ttimeout
  set ttimeoutlen=100
" }


" Vim UI {
  set title      " Set terminal title.
  set showmode   " Show Insert, Visual, Replace modes in status line.
  "set cursorline " Highlight current line.

  if has('cmdline_info')
    set ruler   " Show column numbers.
    set showcmd " Shows info on current command.
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids.
  endif

  if has('statusline')
    set laststatus=2 " Last window will always show status line.

    " Broken down into easily includeable segments.
    set statusline=%<%f\                         " Filename.
    set statusline+=%w%h%m%r                     " Options.
    if isdirectory(expand(s:plugin_dir . '/vim-fugitive'))
      set statusline+=%{fugitive#statusline()}   " Git Hotness.
    endif
    set statusline+=\ [%{&ff}/%Y]                " Filetype.
    set statusline+=\ [%{getcwd()}]              " Current dir.
    set statusline+=%=%-14.(%l,%c%V%)\ %p%%      " Right aligned file nav info.
  endif

  set backspace=indent,eol,start " Backspace through everything in insert mode.
  set number                     " Show line numbers in VIM.
  "set relativenumber             " Show line numbers relative to current line.
  set showmatch                  " Shows matching parentheses.

  " Search {
    set ignorecase " Case insensitive.
    set smartcase  " Search case sensitive only with uppercase keyword.
    set incsearch  " Incremental search.
    set hlsearch   " Highlight search terms.
    set wildmenu   " Show list of autocompletes instead of just completing.
    set wildignore+=*/tmp/*,*.so,*.swp,*.zip
    "set wildmode=list:longest,full " List matches, then longest common part, then all.
  " }

  " Scrolling {
    set scrolloff=8       " Start scrolling when we're 8 lines away from margins.
    set sidescrolloff=15
    set sidescroll=1
  " }

  " Folds {
    set nofoldenable      " Don't fold by default.
    set foldmethod=indent " Fold based on indentation.
    set foldnestmax=5     " Deepest fold is 5 levels.
  " }

  " Highlight whitespaces for tabs, trailing whitespace, and invisible spaces.
  " Use # sign at the end of lines to mark lines that extend off-screen.
  set list
  set listchars=tab:»·,trail:·,extends:#,nbsp:.
" }


" Formatting {
  set nowrap        " Do not wrap long lines.
  set autoindent    " Copy indentation of previous line.
  set expandtab     " Tabs are spaces, not tabs.
  set shiftwidth=2  " Use indents of 2 spaces.
  set tabstop=2     " An indentation every 2 columns.
  set softtabstop=2 " Let backspace delete indent.
  set shiftround    " Indenting with < or > will align to multiples of shiftwidth.
  set splitright    " Puts new vsplit windows to the right of the current.
  set splitbelow    " Puts new split windows to the bottom of the current.

  " Sane indentation on pastes.
  " Note: set paste will mess up plugin indentation when on.
  nnoremap <F2> :set invpaste paste?<CR>
  set pastetoggle=<F2>
  au InsertLeave * set nopaste " Leave paste mode on exit.
" }


" GUI Settings {
  " Remove ctermbg so that the colorscheme background is consistent.
  "highlight Normal ctermbg=NONE
  "highlight nonText ctermbg=NONE

  if has('gui_running')
    if s:os == 'Darwin'
      set fullscreen " Start graphical vim in full screen mode.
      set guifont=Droid\ Sans\ Mono\ for\ Powerline:h14
    else
      set guifont=Droid\ Sans\ Mono\ for\ Powerline\ Semi-Bold\ 14
    endif

    "set guioptions-=T " Remove the toolbar
    set lines=40      " 40 lines of text instead of 24
  else
    "if has('nvim')
      "let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    "else
    " Allow 256 color setting here or in .bashrc: 'export TERM="xterm-256color"'
    if &term == 'xterm' || &term == 'screen'
      set t_Co=256 " Enable 256 colors.
    endif
  endif

  colorscheme solarized
  highlight clear SignColumn " solarized has bad sign column color.

  " Sets a column border.
  if exists('+colorcolumn')
    set colorcolumn=81
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

    " Faster escape
    inoremap jk <ESC>
    cnoremap jk <C-c>

    " Copy visual vim text to system clipboard with "+y
    vnoremap <leader>y "+y

    " Yank from cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    " Unhighlight searches
    nnoremap <silent> <leader>/ :nohlsearch<CR>

    " Search for visual selection
    vnoremap // y/<C-R>"<CR>

    " Easier window navigation
    nnoremap <C-h> <C-w>h
    nnoremap <C-j> <C-w>j
    nnoremap <C-k> <C-w>k
    nnoremap <C-l> <C-w>l

    " Wrapped lines goes down/up to next row, rather than next line in file.
    nnoremap j gj
    nnoremap k gk

    " Diff the current (split) files in window
    nnoremap <leader>wdt :windo diffthis<CR>
    nnoremap <leader>wdo :windo diffoff<CR>

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

    " Moving lines {
      xnoremap <silent> <C-k> [egv
      xnoremap <silent> <C-j> ]egv
      xnoremap <silent> <C-h> <gv
      xnoremap <silent> <C-l> >gv
      xnoremap < <gv
      xnoremap > >gv
    " }

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
    nnoremap <leader>tw :%s/\s\+$//g<CR>

    " Remove trailing whitespace and reformat tabs
    " If replacement fails, command exits before last save.
    " So save in the middle.
    nnoremap <leader>rt gg=G:retab<CR>``:w<CR>:%s/\s\+$//g<CR>:w<CR>

    " For local replace
    nnoremap gr gd[{V%:s/<C-R>///gc<left><left><left>

    " For global replace
    nnoremap gR gD:%s/<C-R>///gc<left><left><left>

    " Toggle spell check
    nnoremap <leader>sc :set spell!<CR>

    " Google search
    function! s:goog()
      let url = 'https://www.google.com/#q='
      " Excerpt from vim-unimpaired
      let q = substitute(
            \ '"'.@0.'"',
            \ '[^A-Za-z0-9_.~-]',
            \ '\="%".printf("%02X", char2nr(submatch(0)))',
            \ 'g')
      call system('open ' . url . q)
    endfunction

    xnoremap <leader>? y:call <SID>goog()<CR>
    nnoremap <leader>? :call system('open https://www.google.com')<CR>
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
    if isdirectory(expand(s:plugin_dir . '/ctrlp.vim'))
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

        " Set maximum number of results
        let g:ctrlp_match_window = 'results:30'
    endif
" }


" delimitMate - auto close quotes, parentheses, brackets, etc. {
    if isdirectory(expand(s:plugin_dir . '/delimitMate'))
        " Expand on return key so that the next line is indented on enter
        let delimitMate_expand_cr = 1
    endif
" }


" fzf - fuzzy finder {
  if isdirectory(expand('~/.fzf'))
    " Shorcut for :FZF.
    nnoremap <silent> <Leader>fzf :FZF<CR>

    " Use locate command as source for fzf.
    command! -nargs=1 Locate call fzf#run(
        \ {'source': 'locate <q-args>', 'sink': 'e', 'options': '-m'})

    " Select from open buffers.
    function! s:buflist()
      redir => ls
      silent ls
      redir END
      return split(ls, '\n')
    endfunction

    function! s:bufopen(e)
      execute 'buffer' matchstr(a:e, '^[ 0-9]*')
    endfunction

    command! FZFBuffer call fzf#run({
    \   'source':  reverse(<sid>buflist()),
    \   'sink':    function('<sid>bufopen'),
    \   'options': '+m',
    \   'down':    len(<sid>buflist()) + 2
    \ })<CR>
    nnoremap <silent> <Leader>fzb :FZFBuffer<CR>

    " Simple MRU search.
    command! FZFMru call fzf#run({
          \'source': v:oldfiles,
          \'sink' : 'e ',
          \'options' : '-m',
          \})
    nnoremap <silent> <Leader>fzm :FZFMru<CR>

    " Jump to tags.
    command! FZFTag if !empty(tagfiles()) | call fzf#run({
    \   'source': "sed '/^\\!/d;s/\t.*//' " . join(tagfiles()) . ' | uniq',
    \   'sink':   'tag',
    \ }) | else | echo 'No tags' | endif
    nnoremap <silent> <Leader>fzt :FZFTag<CR>

    " Search lines in all open vim buffers.
    function! s:line_handler(l)
      let keys = split(a:l, ':\t')
      exec 'buf ' . keys[0]
      exec keys[1]
      normal! ^zz
    endfunction

    function! s:buffer_lines()
      let res = []
      for b in filter(range(1, bufnr('$')), 'buflisted(v:val)')
        call extend(res, map(getbufline(b,0,"$"), 'b . ":\t" . (v:key + 1) . ":\t" . v:val '))
      endfor
      return res
    endfunction

    command! FZFLines call fzf#run({
    \   'source':  <sid>buffer_lines(),
    \   'sink':    function('<sid>line_handler'),
    \   'options': '--extended --nth=3..',
    \   'down':    '60%'
    \})
    nnoremap <silent> <Leader>fzl :FZFLines<CR>

    " Narrow ag results within vim.
    function! AgHandler(l)
      let keys = split(a:l,':')
      execute 'tabe +' . keys[-2] . ' ' . escape(keys[-1], ' ')
    endfunction

    function! Arghandler(l)
      return "ag -i " . a:l . " | sed 's@\\(.[^:]*\\):\\(.[^:]*\\):\\(.*\\)@\\3:\\2:\\1@' "
    endfunction

    command! -nargs=1 AgFZF call fzf#run({
        \'source': Arghandler(<f-args>),
        \'sink' : function('AgHandler'),
        \'options' : '-m'
        \})
    nnoremap <Leader>fza :AgFZF<SPACE>

    " Fuzzy command line completion.
    cnoremap <silent> <c-l> <c-\>eGetCompletions()<cr>
    "add an extra <cr> at the end of this line to automatically accept the fzf-selected completions.

    function! Lister()
      call extend(g:FZF_Cmd_Completion_Pre_List,split(getcmdline(),'\(\\\zs\)\@<!\& '))
    endfunction

    function! CmdLineDirComplete(prefix, options, rawdir)
      let l:dirprefix = matchstr(a:rawdir,"^.*/")
      if isdirectory(expand(l:dirprefix))
        return join(a:prefix + map(fzf#run({
              \'options': a:options . ' --select-1  --query=' .
              \ a:rawdir[matchend(a:rawdir,"^.*/"):len(a:rawdir)],
              \'dir': expand(l:dirprefix)
              \}),
              \'"' . escape(l:dirprefix, " ") . '" . escape(v:val, " ")'))
      else
        return join(a:prefix + map(fzf#run({
              \'options': a:options . ' --query='. a:rawdir }),
              \'escape(v:val, " ")'))
        "dropped --select-1 to speed things up on a long query
      endif
    endfunction

    function! GetCompletions()
      let g:FZF_Cmd_Completion_Pre_List = []
      let l:cmdline_list = split(getcmdline(), '\(\\\zs\)\@<!\& ', 1)
      let l:Prefix = l:cmdline_list[0:-2]
      execute "silent normal! :" . getcmdline() . "\<c-a>\<c-\>eLister()\<cr>\<c-c>"
      let l:FZF_Cmd_Completion_List = g:FZF_Cmd_Completion_Pre_List[len(l:Prefix):-1]
      unlet g:FZF_Cmd_Completion_Pre_List
      if len(l:Prefix) > 0 && l:Prefix[0] =~
            \ '^ed\=i\=t\=$\|^spl\=i\=t\=$\|^tabed\=i\=t\=$\|^arged\=i\=t\=$\|^vsp\=l\=i\=t\=$'
        "single-argument file commands
        return CmdLineDirComplete(l:Prefix, "",l:cmdline_list[-1])
      elseif len(l:Prefix) > 0 && l:Prefix[0] =~
            \ '^arg\=s\=$\|^ne\=x\=t\=$\|^sne\=x\=t\=$\|^argad\=d\=$'
        "multi-argument file commands
        return CmdLineDirComplete(l:Prefix, '--multi', l:cmdline_list[-1])
      else
        return join(l:Prefix + fzf#run({
              \'source':l:FZF_Cmd_Completion_List,
              \'options': '--select-1 --query='.shellescape(l:cmdline_list[-1])
              \}))
      endif
    endfunction
  endif
" }


" indentLine - display vertical lines for indentation level {
    if isdirectory(expand(s:plugin_dir . '/indentLine'))
        let g:indentLine_color_term = 239
        let g:indentLine_color_gui = '#4e4e4e'
        let g:indentLine_char = '┊'
    endif
" }


" gundo.vim - graphical undo tree {
    if isdirectory(expand(s:plugin_dir . '/gundo.vim'))
      nnoremap <leader>ut :GundoToggle<CR>

      " Force preview window below current windows for more space
      let g:gundo_preview_bottom = 1

      " Playback delay in milliseconds
      let g:gundo_playback_delay = 300
    endif
" }


" nerdtree - filesystem explorer {
    if isdirectory(expand(s:plugin_dir . '/nerdtree'))
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
    " <C-R><C-W> gives the text under the cursor when on command line
    " <C-R>" outputs contents in register " when on command line
    nnoremap K :grep! "<C-R><C-W>"<CR>:cw<CR>
    vnoremap K y:grep! "<C-R>""<CR>:cw<CR>
    nnoremap <leader>k :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
    vnoremap <leader>k y:grep! "\b<C-R>"\b"<CR>:cw<CR>

    " Define new command to search for provided text and open 'quickfix'
    command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!

    " bind \ (backward slash) to grep shortcut
    nnoremap \ :Ag<SPACE>
" }


" syntastic - syntax checking {
    if isdirectory(expand(s:plugin_dir . '/syntastic'))
        let g:syntastic_check_on_open = 1 " Syntax check on buffer load and save

        let g:syntastic_aggregate_errors = 1 " Run all checkers for filetype

        " Always stick detected errors into location-list
        let g:syntastic_always_populate_loc_list = 1

        " Open location-list to display syntax errors
        nmap <leader>lo :lopen<CR>

        " Set javascript checker explicitly, not enabled by default
        let g:syntastic_javascript_checkers = ['gjslint']
    endif
" }


" tabular - auto-align text {
    if isdirectory(expand(s:plugin_dir . '/tabular'))
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
    if isdirectory(expand(s:plugin_dir . '/tagbar/'))
        nmap <F8> :TagbarToggle<CR>
    endif
" }


" ultisnips - expand key triggers into full snippets {
  if isdirectory(expand(s:plugin_dir . '/ultisnips'))
    " Allow ultisnips to work with YouCompleteMe.
    let g:UltiSnipsExpandTrigger='<C-j>'
    let g:UltiSnipsJumpForwardTrigger='<C-j>'
    let g:UltiSnipsJumpBackwardTrigger='<C-k>'

    " Allow ultisnips to list snippets.
    let g:UltiSnipsListSnippets='<C-l>'
  endif
" }


" vim-airline - pretty status line {
    if isdirectory(expand(s:plugin_dir . '/vim-airline'))
        let g:airline_powerline_fonts = 1
    endif
"}


" vim-colors-solarized - Solarized colorscheme {
    if isdirectory(expand(s:plugin_dir . '/vim-colors-solarized'))
      call togglebg#map("<F5>") " <F-5> to toggle between solarized light/dark

      " If using ssh, set terminal properties for better colors
      function! SolarizedSsh()
        if g:solarized_termtrans == 0
          let g:solarized_termtrans=1
          let g:solarized_termcolors=256
        else
          let g:solarized_termtrans=0
          let g:solarized_termcolors=16
        endif

        colorscheme solarized
        highlight clear SignColumn " solarized has bad sign column color

        " Removes gray background on symbols
        call gitgutter#highlight#define_highlights()
      endfunction

      nnoremap <leader>ssh :call SolarizedSsh()<CR>
    endif
"}


" vim-fugitive - Git wrapper {
    if isdirectory(expand(s:plugin_dir . '/vim-fugitive'))
      " Add current file to staging
      nnoremap <leader>ga :Git add %:p<CR><CR>

      " Mnemonic _i_nteractive
      nnoremap <leader>gi :Git add -p %<CR>

      nnoremap <leader>gb :Gblame<CR>

      " Commit using new tab and show diff
      nnoremap <leader>gc :Gcommit -v -q<CR>

      " Commit current file using new tab and show diff
      nnoremap <leader>gt :Gcommit -v -q %:p<CR>

      nnoremap <leader>go :Git checkout<SPACE>
      nnoremap <leader>gd :Gdiff<CR>
      nnoremap <leader>ge :Gedit<CR>
      nnoremap <leader>gl :Glog<CR>
      nnoremap <leader>gm :Gmove<SPACE>
      nnoremap <leader>gpl :Gpull<CR>
      nnoremap <leader>gps :Gpush<CR>
      nnoremap <leader>gr :Gread<CR>
      nnoremap <leader>gs :Gstatus<CR>
      nnoremap <leader>gw :Gwrite<CR>

      " Poor man's vim-rooter, git only, using fugitive
      " http://www.reddit.com/r/vim/comments/2zc8sy/poors_man_vimrooter_git_only_using_fugitive/
      autocmd BufLeave * let b:last_cwd = getcwd()
      autocmd BufEnter * if exists('b:last_cwd')
                      \|   execute 'lcd' b:last_cwd
                      \| else
                      \|   silent! Glcd
                      \| endif
    endif
" }


" vim-gitgutter - display git diff signs {
    if isdirectory(expand(s:plugin_dir . '/vim-gitgutter'))
        " Escape grep since we've aliased grep to ag
        let g:gitgutter_escape_grep = 1

        " Toggle gitgutter plugin
        nnoremap <silent> <leader>gg :GitGutterToggle<CR>
    endif
" }


" vim-multiple-cursors - Multiple selections and editing {
  if isdirectory(expand(s:plugin_dir . '/vim-multiple-cursors'))
    " Behave like g*, no word boundaries
    let g:multi_cursor_start_key='g<C-n>'

    " Behave like *, use word boundaries
    let g:multi_cursor_start_word_key='<C-n>'

    " Hitting ESC will go to Normal mode instead of quitting
    let g:multi_cursor_exit_from_visual_mode=0

    " Hitting ESC will go to Normal mode instead of quitting
    let g:multi_cursor_exit_from_insert_mode=0

  endif
" }


" vim-startify - start fancy fresh vim {
    if isdirectory(expand(s:plugin_dir . '/vim-startify'))
        " Don't change into directory of selected file so that ag searching
        " will work across subdirectories
        let g:startify_change_to_dir = 0
        let g:startify_files_number = 20 " Show more files
    endif
" }


" vim-tmuxify - bridge between vim and tmux {
    if isdirectory(expand(s:plugin_dir . '/vim-tmuxify'))
      " Custom tmux create command
      let g:tmuxify_custom_command = 'tmux split-window -d -p 25'
    endif
" }


" YouCompleteMe - autocomplete {
  if isdirectory(expand(s:plugin_dir . '/YouCompleteMe'))
    " Enable completion from tags.
    let g:ycm_collect_identifiers_from_tags_files = 1

    "let g:ycm_global_ycm_extra_conf =
        "\ s:plugin_dir . '/YouCompleteMe/.ycm_extra_conf.py'

    " Enable omni completion.
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
    autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
    autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

    " If not using YCM's clang semantic completer and want to use
    " Syntastic's gcc checker.
    let g:ycm_show_diagnostics_ui = 0

    " If not working in cpp, this makes YCM faster.
    let g:ycm_filetype_specific_completion_to_disable = {'cpp': 1, 'c': 1}
  endif
" }


