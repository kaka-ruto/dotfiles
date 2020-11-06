" .vimrc / init.vim
" The following vim/neovim configuration works for both Vim and NeoVim
"
" ensure vim-plug is installed and then load it
call functions#PlugLoad()
call plug#begin('~/.config/nvim/plugged')

" General {{{
    set autoread " detect when a file is changed

    set history=1000 " change history to 1000
    set textwidth=120

    set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
    set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

    if (has('nvim'))
        " show results of substition as they're happening
        " but don't open a split
        set inccommand=nosplit
    endif

    set backspace=indent,eol,start " make backspace behave in a sane manner
    set clipboard=unnamed

    if has('mouse')
        " Disable every mouse interaction
        set mouse=
    endif

    "{{{ Searching
        Plug 'google/vim-searchindex' " Display number of matches and index of current match
        set ignorecase " case insensitive searching
        set smartcase " case-sensitive if expresson contains a capital letter
        set hlsearch " highlight search results
        set incsearch " set incremental search, like modern browsers
    " }}}

    set nolazyredraw " don't redraw while executing macros
    set magic " Set magic on, for regex

    " error bells
    set noerrorbells
    set visualbell
    set t_vb=
    set tm=500

    " Make Vim faster
    " Lazy load the man plugin
    silent! command -nargs=* Man
      \ delcommand Man |
      \ runtime ftplugin/man.vim |
      \ Man <args>
" }}}

" Appearance {{{
    set number relativenumber " show relative line numbers

    " Automatically switch between number modes
    augroup numbertoggle
      autocmd!
      autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
      autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
    augroup END

    set wrap " turn on line wrapping
    set wrapmargin=8 " wrap lines when coming within n characters from side
    set linebreak " set soft wrapping
    set showbreak=… " show ellipsis at breaking
    set formatoptions-=t " Turn line autowrapping off in insert mode, formatoptions+=t to turn on
    set autoindent " automatically set indent of new line
    set ttyfast " faster redrawing
    set diffopt+=vertical,iwhite,internal,algorithm:patience,hiddenoff
    set laststatus=2 " show the status line all the time
    set so=7 " set 7 lines to the cursors - when moving vertical
    set wildmenu " enhanced command line completion
    set hidden " current buffer can be put into background
    set showcmd " show incomplete commands
    set noshowmode " don't show which mode disabled for PowerLine
    set wildmode=list:longest " complete files like a shell
    set shell=$SHELL
    set cmdheight=1 " command bar height
    set title " set terminal title
    set showmatch " show matching braces
    set mat=2 " how many tenths of a second to blink
    set updatetime=300
    set signcolumn=yes
    set shortmess+=c
    set splitright " Open new split panes to the right
    set fillchars+=vert:\!

    " Set fefault tabs ans spaces control (file specific configurations in config/nvim/ftplugin/)
    setlocal tabstop=2 " the visible width of tabs
    setlocal softtabstop=2 " edit as if the tabs are 2 characters wide
    setlocal shiftwidth=2 " number of spaces to use for indent and unindent
    setlocal expandtab

    " Upon opening a file of type xyz, source the file ~/.vim/ftplugin/xyz.vim
    filetype plugin indent on

    " code folding settings
    set foldmethod=syntax " fold based on indent
    set foldlevelstart=99
    set foldnestmax=10 " deepest fold is 10 levels
    set nofoldenable " don't fold by default
    set foldlevel=1
    set foldcolumn=1

    " toggle invisible characters
    set list
    set listchars=tab:\|\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
    set showbreak=↪

    set t_Co=256 " Explicitly tell vim that the terminal supports 256 colors
    " switch cursor to line when in insert mode, and block when not
    set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
    \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
    \,sm:block-blinkwait175-blinkoff150-blinkon175

    if &term =~ '256color'
        " disable background color erase
        set t_ut=
    endif

    " enable 24 bit color support if supported
    if (has("termguicolors"))
        if (!(has("nvim")))
            let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
            let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
        endif
        set termguicolors
    endif

    " highlight conflicts
    match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

    " Load colorschemes
    Plug 'chriskempson/base16-vim'
    Plug 'lifepillar/vim-solarized8'

    " LightLine {{{
        Plug 'itchyny/lightline.vim'
        Plug 'nicknisi/vim-base16-lightline'
        let g:lightline = {
            \   'colorscheme': 'base16',
            \   'active': {
            \       'left': [ [ 'mode', 'paste' ],
            \               [ 'gitbranch' ],
            \               [ 'readonly', 'filetype', 'filename' ]],
            \       'right': [ [ 'percent' ], [ 'lineinfo' ],
            \               [ 'fileformat', 'fileencoding' ],
            \               [ 'gitblame', 'currentfunction',  'cocstatus', 'linter_errors', 'linter_warnings' ]]
            \   },
            \   'component_expand': {
            \   },
            \   'component_type': {
            \       'readonly': 'error',
            \       'linter_warnings': 'warning',
            \       'linter_errors': 'error'
            \   },
            \   'component_function': {
            \       'fileencoding': 'helpers#lightline#fileEncoding',
            \       'filename': 'helpers#lightline#fileName',
            \       'fileformat': 'helpers#lightline#fileFormat',
            \       'filetype': 'helpers#lightline#fileType',
            \       'gitbranch': 'FugitiveHead',
            \       'cocstatus': 'coc#status',
            \       'currentfunction': 'helpers#lightline#currentFunction',
            \       'gitblame': 'helpers#lightline#gitBlame'
            \   },
            \   'tabline': {
            \       'left': [ [ 'tabs' ] ],
            \       'right': [ [ 'close' ] ]
            \   },
            \   'tab': {
            \       'active': [ 'filename', 'modified' ],
            \       'inactive': [ 'filename', 'modified' ],
            \   },
            \   'separator': { 'left': '', 'right': '' },
            \   'subseparator': { 'left': '', 'right': '' }
        \ }
    " }}}
" }}}

" General Mappings {{{
    " set a map leader for more key combos, space
    let mapleader = "\<Space>"

    " Autosave every time something has been changed in normal mode and when the user leaves insert mode
    Plug '907th/vim-auto-save'
    let g:auto_save = 1  " enable AutoSave on Vim startup
    let g:auto_save_in_insert_mode = 0  " do not save while in insert mode
    let g:auto_save_no_updatetime = 1  " do not change the 'updatetime' option
    let g:auto_save_silent = 1  " do not display the auto-save notification

    " Shortcut to save file in normal insert, or visual modes
    " :update only saves when there are new changes, unlike :write
    " Normal mode
    " nnoremap <leader>s :update <cr>
    " Insert mode: escape to normal mode and update
    " inoremap <leader>s <ESC> :update <cr>
    " Visual mode
    " vnoremap <leader>s :update <cr>

    " Add blank lines in normal mode using Enter and Shift-Enter(below and above resp.)
    map <Enter> o <ESC>
    map <S-Enter> O <ESC>

    " Source init.vim
    nmap <leader>so :source $INITVIM <cr>

    " Exit vim
    nmap <leader>q :q <cr>

    " set paste toggle
    set pastetoggle=<leader>v

    " Paste the lasy yanked text
    nnoremap p "0p
    xnoremap p "0p

    " Edit the vimrc/initvim
    nnoremap cv :edit $INITVIM <cr>

    " Aytomatically reload vimrc on edit
    if has ('autocmd') " Remain compatible with earlier versions
      augroup vimrc     " Source vim configuration upon save
        autocmd! BufWritePost $INITVIM source % | echom "Reloaded " . $INITVIM | redraw
        autocmd! BufWritePost $INITVIM if has('gui_running') | so % | echom "Reloaded " . $INITVIM | endif | redraw
      augroup END
    endif " has autocmd

    " edit gitconfig
    map <leader>eg :e! ~/.gitconfig<cr>

    " clear highlighted search
    noremap <silent> <Esc> <Esc>:let @/ =""<cr>

    " activate spell-checking alternatives
    nmap ;s :set invspell spelllang=en<cr>

    " markdown to html
    nmap <leader>md :%!markdown --html4tags <cr>

    " remove extra whitespace
    " nmap <leader><space> :%s/\s\+$<cr>
    " nmap <leader><space><space> :%s/\n\{2,}/\r\r/g<cr>

    inoremap <expr> <C-j> pumvisible() ? "\<C-N>" : "\<C-j>"
    inoremap <expr> <C-k> pumvisible() ? "\<C-P>" : "\<C-k>"

    nmap <leader>l :set list!<cr>

    " keep visual selection when indenting/outdenting
    vmap < <gv
    vmap > >gv

    " switch between current and last buffer
    nmap <leader>. <c-^>

    " enable . command in visual mode
    vnoremap . :normal .<cr>

		" Use Ctrl-<direction> to navigate vim splits or tmux panes
		if exists('$TMUX')
			function! TmuxOrSplitSwitch(wincmd, tmuxdir)
				let previous_winnr = winnr()
				silent! execute "wincmd " . a:wincmd
				if previous_winnr == winnr()
					call system("tmux select-pane -" . a:tmuxdir)
					redraw!
				endif
			endfunction

			let previous_title = substitute(system("tmux display-message -p '#{pane_title}'"), '\n', '', '')
			let &t_ti = "\<Esc]>2;vim\<Esc>\\" . &t_ti
			let &t_te = "\Esc><]2;>". previous_title . "\<Esc>\\" . &t_te

			nnoremap <silent> <C-h> :call TmuxOrSplitSwitch('h', 'L')<cr>
			nnoremap <silent> <C-j> :call TmuxOrSplitSwitch('j', 'D')<cr>
			nnoremap <silent> <C-k> :call TmuxOrSplitSwitch('k', 'U')<cr>
			nnoremap <silent> <C-l> :call TmuxOrSplitSwitch('l', 'R')<cr>
		else
			map <C-h> <C-w>h
      map <C-j> <C-w>j
      map <C-k> <C-w>k
      map <C-l> <C-w>l
		endif

    nmap <leader>z <Plug>Zoom

    map <leader>wc :wincmd q<cr>

    " move line mappings
    " ∆ is <A-j> on macOS
    " ˚ is <A-k> on macOS
    nnoremap ∆ :m .+1<cr>==
    nnoremap ˚ :m .-2<cr>==
    inoremap ∆ <Esc>:m .+1<cr>==gi
    inoremap ˚ <Esc>:m .-2<cr>==gi
    vnoremap ∆ :m '>+1<cr>gv=gv
    vnoremap ˚ :m '<-2<cr>gv=gv

    vnoremap $( <esc>`>a)<esc>`<i(<esc>
    vnoremap $[ <esc>`>a]<esc>`<i[<esc>
    vnoremap ${ <esc>`>a}<esc>`<i{<esc>
    vnoremap $" <esc>`>a"<esc>`<i"<esc>
    vnoremap $' <esc>`>a'<esc>`<i'<esc>
    vnoremap $\ <esc>`>o*/<esc>`<O/*<esc>
    vnoremap $< <esc>`>a><esc>`<i<<esc>

    set cursorline
    " toggle cursor line
    nnoremap <leader>i :set cursorline!<cr>

    " scroll the viewport faster
    nnoremap <C-e> 3<C-e>
    nnoremap <C-y> 3<C-y>

    " moving up and down work as you would expect
    nnoremap <silent> j gj
    nnoremap <silent> k gk
    nnoremap <silent> ^ g^
    nnoremap <silent> $ g$

    " Insert char at cursor position in normal mode
    " nnoremap <C-r> i <ESC>r
    " Append char after cursor position in normal mode
    nnoremap <C-a> a <ESC>r

    " helpers for dealing with other people's code
    nmap \t :set ts=4 sts=4 sw=4 noet<cr>
    nmap \s :set ts=4 sts=4 sw=4 et<cr>

    nnoremap <silent> <leader>u :call functions#HtmlUnEscape()<cr>

    command! Rm call functions#Delete()
    command! RM call functions#Delete() <Bar> q!

    " Custom text objects

    " inner-line
    xnoremap <silent> il :<c-u>normal! g_v^<cr>
    onoremap <silent> il :<c-u>normal! g_v^<cr>

    " around line
    vnoremap <silent> al :<c-u>normal! $v0<cr>
    onoremap <silent> al :<c-u>normal! $v0<cr>

    " CTRL-U in insert mode deletes a lot. Put an undo-point before it.
    inoremap <C-u> <C-g>u<C-u>

    " Interesting word mappings
    nmap <leader>0 <Plug>ClearInterestingWord
    nmap <leader>1 <Plug>HiInterestingWord1
    nmap <leader>2 <Plug>HiInterestingWord2
    nmap <leader>3 <Plug>HiInterestingWord3
    nmap <leader>4 <Plug>HiInterestingWord4
    nmap <leader>5 <Plug>HiInterestingWord5
    nmap <leader>6 <Plug>HiInterestingWord6

    " Stop repeating jjjj... Stop repeating kkkk...
    Plug 'takac/vim-hardtime'
    " let g:hardtime_default_on = 1
    " Get off my lawn
    nnoremap <Left> :echoe "Use h"<CR>
    nnoremap <Right> :echoe "Use l"<CR>
    nnoremap <Up> :echoe "Use k"<CR>
    nnoremap <Down> :echoe "Use j"<CR>
" }}}

" AutoGroups {{{
    " file type specific settings
    augroup configgroup
        autocmd!

        " automatically resize panes on resize
        autocmd VimResized * exe 'normal! \<c-w>='
        autocmd BufWritePost .vimrc,.vimrc.local,init.vim source %
        autocmd BufWritePost .vimrc.local source %
        " save all files on focus lost, ignoring warnings about untitled buffers
        autocmd FocusLost * silent! wa

        " make quickfix windows take all the lower section of the screen
        " when there are multiple windows open
        autocmd FileType qf wincmd J
        autocmd FileType qf nmap <buffer> q :q<cr>
    augroup END

    augroup templates
      " Insert skeleton code to new Ruby files, eg frozen string literal comments
      autocmd BufNewFile *.rb 0r ~/.dotfiles/config/nvim/templates/skeleton.rb
    augroup END
" }}}

" General Functionality {{{
    " better terminal integration
    " substitute, search, and abbreviate multiple variants of a word
    Plug 'tpope/vim-abolish'

    " easy commenting motions
    Plug 'tpope/vim-commentary'
    nmap \\ gcc
    vmap \\ gcc
    nmap <leader>dc :g/#/d <CR>

    " mappings which are simply short normal mode aliases for commonly used ex commands
    Plug 'tpope/vim-unimpaired'

    " endings for html, xml, etc. - ehances surround
    Plug 'tpope/vim-ragtag'

    " mappings to easily delete, change and add such surroundings in pairs, such as quotes, parens, etc.
    Plug 'tpope/vim-surround'

    Plug 'tpope/vim-dispatch'

    " Insert or delete brackets, parens, quotes in pair
    Plug 'jiangmiao/auto-pairs'

    " {{{ Run your tests at the speed of thought
        Plug 'janko/vim-test'

        nmap <silent> <C-n> :TestNearest <CR>
        nmap <silent> <C-t> :TestFile <CR>
        nmap <silent> <C-s> :TestSuite <CR>
        nmap <silent> <C-g> :TestLast <CR>
        " nmap <silent> <C-g> :TestVisit <CR>

        " Execute tests using dispatch
        let test#strategy = 'dispatch'
    " }}}

    " enables repeating other supported plugins with the . command
    Plug 'tpope/vim-repeat'

    " .editorconfig support
    Plug 'editorconfig/editorconfig-vim'

    " single/multi line code handler: gS - split one line into multiple, gJ - combine multiple lines into one
    Plug 'AndrewRadev/splitjoin.vim'
    nmap gj :SplitjoinSplit <CR>
    nmap gk :SplitjoinJoin <CR>

    " add end, endif, etc. automatically
    Plug 'tpope/vim-endwise'

    " detect indent style (tabs vs. spaces)
    Plug 'tpope/vim-sleuth'

    " Indentation text objects, useful for navigating blocks of code in the same level of indent
    Plug 'michaeljsmith/vim-indent-object'

    " Vim sugar for the UNIX shell commands that need it the most, eg rename file
    Plug 'tpope/vim-eunuch'

    " Startify: Fancy startup screen for vim {{{
        Plug 'mhinz/vim-startify'

        " Don't change to directory when selecting a file
        let g:startify_files_number = 5
        let g:startify_change_to_dir = 0
        let g:startify_custom_header = [ ]
        let g:startify_relative_path = 1
        let g:startify_use_env = 1

        " Custom startup list, only show MRU from current directory/project
        let g:startify_lists = [
        \  { 'type': 'dir',       'header': [ 'Files '. getcwd() ] },
        \  { 'type': function('helpers#startify#listcommits'), 'header': [ 'Recent Commits' ] },
        \  { 'type': 'sessions',  'header': [ 'Sessions' ]       },
        \  { 'type': 'bookmarks', 'header': [ 'Bookmarks' ]      },
        \  { 'type': 'commands',  'header': [ 'Commands' ]       },
        \ ]

        let g:startify_commands = [
        \   { 'up': [ 'Update Plugins', ':PlugUpdate' ] },
        \   { 'ug': [ 'Upgrade Plugin Manager', ':PlugUpgrade' ] },
        \ ]

        let g:startify_bookmarks = [
            \ { 'c': '~/.config/nvim/init.vim' },
            \ { 'g': '~/.gitconfig' },
            \ { 'z': '~/.zshrc' }
        \ ]

        autocmd User Startified setlocal cursorline
        nmap <leader>st :Startify<cr>
    " }}}

    " Profiling (neo)vim's startuptime
    Plug 'dstein64/vim-startuptime'

    " Close buffers but keep splits
    Plug 'moll/vim-bbye'
    nmap <leader>bb :Bdelete<cr>

    " context-aware pasting
    Plug 'sickill/vim-pasta'

    " Highlight copied text
    Plug 'machakann/vim-highlightedyank'

    " Animate pane resizing
    Plug 'camspiers/animate.vim'
    Plug 'camspiers/lens.vim'

    " File type icons
    Plug 'ryanoasis/vim-devicons'
    let g:WebDevIconsOS = 'Darwin'
    let g:WebDevIconsUnicodeDecorateFolderNodes = 1
    let g:DevIconsEnableFoldersOpenClose = 1
    let g:DevIconsEnableFolderExtensionPatternMatching = 1

    " Ranger {{{
        " Use ranger for file exploration (install with 'brew install ranger')
        let g:ranger_replace_netrw = 1
    " }}}

    " Enable opening a file in a given line
    Plug 'bogado/file-line'

    Plug 'junegunn/vim-peekaboo'

    " FZF {{{
        Plug 'junegunn/fzf.vim' | Plug '/usr/local/opt/fzf'

        " FZF with floating previews through coc-fzf-preview
        noremap [fzf-p] <Nop>
        nmap <leader> [fzf-p]
        xmap <leader> [fzf-p]

        nnoremap <silent> [fzf-p]p     :<C-u>CocCommand fzf-preview.FromResources project_mru git<CR>
        nnoremap <silent> [fzf-p]gs    :<C-u>CocCommand fzf-preview.GitStatus<CR>
        nnoremap <silent> [fzf-p]ga    :<C-u>CocCommand fzf-preview.GitActions<CR>
        nnoremap <silent> [fzf-p]b     :<C-u>CocCommand fzf-preview.Buffers<CR>
        nnoremap <silent> [fzf-p]B     :<C-u>CocCommand fzf-preview.AllBuffers<CR>
        nnoremap <silent> [fzf-p]o     :<C-u>CocCommand fzf-preview.FromResources buffer project_mru<CR>
        nnoremap <silent> [fzf-p]<C-o> :<C-u>CocCommand fzf-preview.Jumps<CR>
        nnoremap <silent> [fzf-p]g;    :<C-u>CocCommand fzf-preview.Changes<CR>
        nnoremap <silent> [fzf-p]/     :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'"<CR>
        nnoremap <silent> [fzf-p]*     :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'<C-r>=expand('<cword>')<CR>"<CR>
        nnoremap          [fzf-p]gr    :<C-u>CocCommand fzf-preview.ProjectGrep<Space>
        xnoremap          [fzf-p]gr    "sy:CocCommand   fzf-preview.ProjectGrep<Space>-F<Space>"<C-r>=substitute(substitute(@s, '\n', '', 'g'), '/', '\\/', 'g')<CR>"
        nnoremap <silent> [fzf-p]t     :<C-u>CocCommand fzf-preview.BufferTags<CR>
        nnoremap <silent> [fzf-p]q     :<C-u>CocCommand fzf-preview.QuickFix<CR>
        nnoremap <silent> [fzf-p]l     :<C-u>CocCommand fzf-preview.LocationList<CR>

        " Use vim-devicons
        let g:fzf_preview_use_dev_icons = 1

        " devicons character width
        let g:fzf_preview_dev_icon_prefix_string_length = 3
    " }}}

    " vim-fugitive {{{
        Plug 'tpope/vim-fugitive'
        nnoremap gap :Git add %:p<CR><CR>
        nnoremap gaa :Git add . <CR><CR>
        nnoremap gss :Gstatus<CR>
        nnoremap goo :Gcommit -v -q<CR>
        nnoremap gtt :Gcommit -v -q %:p<CR>
        nnoremap gdd :Gdiff<CR>
        nnoremap gee :Gedit<CR>
        nnoremap grr :Gread<CR>
        nnoremap gww :Gwrite<CR><CR>
        nnoremap gll :silent! Glog<CR>:bot copen<CR>
        nnoremap ggg :Ggrep<Space>
        nnoremap gmm :Gmove<Space>
        nnoremap gre :Grename<Space>
        nnoremap gbb :Git branch<Space>
        nnoremap gco :Git checkout<Space>
        nnoremap gpp :Dispatch! Git push<CR>
        nnoremap gpl :Dispatch! Git pull<CR>
        nnoremap gbb :Gblame<CR>
        nnoremap g- :Silent Git stash<CR>:e<CR>
        nnoremap g+ :Silent Git stash pop<CR>:e<CR>
        " Auto-clean fugitive buffers
        autocmd BufReadPost fugitive://* set bufhidden=delete

        Plug 'tpope/vim-rhubarb' " hub extension for fugitive
        Plug 'junegunn/gv.vim'
        Plug 'sodapopcan/vim-twiggy'
    " }}}

    " UltiSnips, snippets in Vim {{{
        Plug 'SirVer/ultisnips'
        let g:UltiSnipsExpandTrigger = '\'
        let g:UltiSnipsJumpForwardTrigger = '\'

        " Popular snippets
        Plug 'honza/vim-snippets'

        " Hit tab to scroll dropdown of suggestions
        imap <Tab> <C-n>
    " }}}

    " Linting {{{
        Plug 'desmap/ale-sensible' | Plug 'dense-analysis/ale'

        let g:ale_linters_explicit = 1 " Run specific linters
        " Set specific linters
        let g:ale_linters = {
              \   'javascript': ['eslint'],
              \   'ruby': ['rubocop', 'solargraph'],
              \}
        let g:ale_fixers = {
              \   '*': ['remove_trailing_lines', 'trim_whitespace'],
              \   'javascript': ['eslint'],
              \   'ruby': ['rubocop']
              \}
        let g:ale_set_highlights = 0      " Disable ALE auto highlights
        let g:ale_sign_column_always = 1  " Show the error sign always
        let g:ale_fix_on_save = 1
        let g:ale_javascript_prettier_options = '--single-quote'

        " nmap <leader>f :ALEFix <CR>
    " }}}

    " coc {{{
        Plug 'neoclide/coc.nvim', {'branch': 'release'}

        let g:coc_global_extensions = [
        \ 'coc-css',
        \ 'coc-json',
        \ 'coc-tsserver',
        \ 'coc-git',
        \ 'coc-eslint',
        \ 'coc-tslint-plugin',
        \ 'coc-pairs',
        \ 'coc-sh',
        \ 'coc-vimlsp',
        \ 'coc-emmet',
        \ 'coc-prettier',
        \ 'coc-ultisnips',
        \ 'coc-solargraph',
        \ 'coc-tailwindcss',
        \ 'coc-vetur',
        \ 'coc-fzf-preview'
        \ ]

        autocmd CursorHold * silent call CocActionAsync('highlight')

        " coc-prettier
        command! -nargs=0 Prettier :CocCommand prettier.formatFile
        " nmap <leader>f :CocCommand prettier.formatFile<cr>

        " coc-git
        " nmap [g <Plug>(coc-git-prevchunk)
        " nmap ]g <Plug>(coc-git-nextchunk)
        " nmap gs <Plug>(coc-git-chunkinfo)
        " nmap gu :CocCommand git.chunkUndo<cr>

        "remap keys for gotos
        nmap <silent> gd <Plug>(coc-definition)
        nmap <silent> gy <Plug>(coc-type-definition)
        nmap <silent> gi <Plug>(coc-implementation)
        nmap <silent> gr <Plug>(coc-references)
        nmap <silent> gh <Plug>(coc-doHover)

        " diagnostics navigation
        nmap <silent> [c <Plug>(coc-diagnostic-prev)
        nmap <silent> ]c <Plug>(coc-diagnostic-next)

        " rename current word
        nmap <silent> <leader>rn <Plug>(coc-rename)

        " Remap for format selected region
        " xmap <leader>f  <Plug>(coc-format-selected)
        " nmap <leader>f  <Plug>(coc-format-selected)

        " organize imports
        command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')

        " Use K to show documentation in preview window
        nnoremap <silent> K :call <SID>show_documentation()<CR>

        function! s:show_documentation()
            if (index(['vim','help'], &filetype) >= 0)
                execute 'h '.expand('<cword>')
            else
                call CocAction('doHover')
            endif
        endfunction

        "tab completion
        inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ coc#refresh()
        inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

        function! s:check_back_space() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
        endfunction
    " }}}

    " Motions on steroids
    Plug 'justinmk/vim-sneak'
    let g:sneak#s_next = 1
    map m <Plug>Sneak_s
    " map S <Plug>Sneak_S
     " Plug 'easymotion/vim-easymotion'

     " Default leader is <leader><leader>

     " <Leader>f{char} to move to {char}
     " map  <Leader>f <Plug>(easymotion-bd-f)
     " nmap <Leader>f <Plug>(easymotion-overwin-f)

     " s{char}{char} to move to {char}{char}
     " nmap s <Plug>(easymotion-s2)
     " nmap t <Plug>(easymotion-t2)

     " Move to line
     " map <Leader>l <Plug>(easymotion-bd-jk)

     " Move to word
     " map  <Leader>w <Plug>(easymotion-bd-w)
     " nmap <Leader>w <Plug>(easymotion-overwin-w)

     " let g:EasyMotion_smartcase = 1

     " n-char search motion
      " map  // <Plug>(easymotion-sn)
      " omap // <Plug>(easymotion-tn)

    " Switch true for false and vice versa (plus other common swiches too)
      Plug 'AndrewRadev/switch.vim'
      let g:switch_mapping = '\'

      " Productivity - how much time do I spend on each project?
      Plug 'wakatime/vim-wakatime'
" }}}

" Language-Specific Configuration {{{
    " html / templates {{{
        " emmet support for vim - easily create markdup wth CSS-like syntax
        Plug 'mattn/emmet-vim'

        " match tags in html, similar to paren support
        Plug 'gregsexton/MatchTag', { 'for': 'html' }

        " html5 support
        Plug 'othree/html5.vim', { 'for': 'html' }

        " mustache support
        " Plug 'mustache/vim-mustache-handlebars'

        " pug / jade support
        " Plug 'digitaltoad/vim-pug', { 'for': ['jade', 'pug'] }

        " nunjucks support
        " Plug 'niftylettuce/vim-jinja', { 'for': 'njk' }

        " Slim templating syntax highlighting
        " Plug 'slim-template/vim-slim'
    " }}}

    " Regenerate tags and get the task out of my way
    Plug 'ludovicchabant/vim-gutentags'

    " {{{ Ruby and RoR
        Plug 'vim-ruby/vim-ruby'
        Plug 'tpope/vim-rails'
        Plug 'tpope/vim-bundler'
        Plug 'tpope/vim-rake'

        " For projectionist.vim (comes with rake.vim)
        let g:rails_projections = {
              \  "app/controllers/*_controller.rb": {
              \      "test": [
              \        "spec/requests/{}_spec.rb",
              \        "spec/controllers/{}_controller_spec.rb",
              \        "test/controllers/{}_controller_test.rb"
              \      ],
              \      "alternate": [
              \        "spec/requests/{}_spec.rb",
              \        "spec/controllers/{}_controller_spec.rb",
              \        "test/controllers/{}_controller_test.rb"
              \      ],
              \   },
              \   "spec/requests/*_spec.rb": {
              \      "command": "request",
              \      "alternate": "app/controllers/{}_controller.rb",
              \      "template": "require 'rails_helper'\n\n" .
              \        "RSpec.describe '{}' do\nend",
              \   },
              \ }

        Plug 'ecomba/vim-ruby-refactoring'

        " Rapid navigation to factory definition
        Plug 'christoomey/vim-rfactory'
        nmap rf :Rfactory <CR>

        " Selecting Ruby blocks using ar and ir
        Plug 'kana/vim-textobj-user'
        Plug 'rhysd/vim-textobj-ruby'
        " Plug 'nelstrom/vim-textobj-rubyblock'
          " Requires enabling the matchit plugin
        " runtime macros/matchit.vim
    " }}}

    " JavaScript {{{
        " Plug 'othree/yajs.vim', { 'for': [ 'javascript', 'javascript.jsx', 'html' ] }
        Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'javascript.jsx', 'html'] }
        " Plug 'moll/vim-node', { 'for': 'javascript' }
        " Plug 'ternjs/tern_for_vim', { 'for': ['javascript', 'javascript.jsx'], 'do': 'npm install' }
        " Plug 'MaxMEllon/vim-jsx-pretty'
        " let g:vim_jsx_pretty_highlight_close_tag = 1
    " }}}

    " TypeScript {{{
        " Plug 'leafgarland/typescript-vim', { 'for': ['typescript', 'typescript.tsx'] }
        " Plug 'Shougo/vimproc.vim', { 'do': 'make' } TODO what still needs this?
    " }}}

    " Styles {{{
        Plug 'wavded/vim-stylus', { 'for': ['stylus', 'markdown'] }
        " Plug 'groenewege/vim-less', { 'for': 'less' }
        " Plug 'hail2u/vim-css3-syntax', { 'for': 'css' }
        " Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }
        " Plug 'stephenway/postcss.vim', { 'for': 'css' }
    " }}}

    " markdown {{{
        Plug 'tpope/vim-markdown', { 'for': 'markdown' }
        " let g:markdown_fenced_languages = [ 'tsx=typescript.tsx' ]

        " Open markdown files in Marked.app - mapped to <leader>m
        " Plug 'itspriddle/vim-marked', { 'for': 'markdown', 'on': 'MarkedOpen' }
        " nmap <leader>m :MarkedOpen!<cr>
        " nmap <leader>mq :MarkedQuit<cr>
        " nmap <leader>* *<c-o>:%s///gn<cr>
    " }}}

    " JSON {{{
        Plug 'elzr/vim-json', { 'for': 'json' }
        let g:vim_json_syntax_conceal = 0
    " }}}

    " Plug 'fatih/vim-go', { 'for': 'go' }
    Plug 'ekalinin/Dockerfile.vim'

    " Like context.vim but lightweight. install after Neovim 0.5.0 is realeased
    " Plug 'nvim-treesitter/nvim-treesitter'
    " Plug 'romgrk/nvim-treesitter-context'

    " VueJS {{{
        Plug 'posva/vim-vue'

        " Detect the pre-processors used in a file on enter, for speed
        let g:vue_pre_processors = 'detect_on_enter'
    " }}}
" }}}

" {{{ Yaml
    autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
" }}}
  " Show indentation lines {{{
    Plug 'Yggdroot/indentLine'
  " }}}

call plug#end()

" Example of how to set the ruby host to a particualr Ruby version using asdf
" let g:ruby_host_prog = '~/.asdf/shims/neovim-ruby-host'

" Colorscheme and final setup {{{
    " This call must happen after the plug#end() call to ensure
    " that the colorschemes have been loaded
    colorscheme solarized8_flat
    syntax on

    " make the highlighting of tabs and other non-text less annoying
    highlight SpecialKey ctermfg=19 guifg=#333333
    highlight NonText ctermfg=19 guifg=#333333

    " make comments and HTML attributes italic
    highlight Comment cterm=italic term=italic gui=italic
    highlight htmlArg cterm=italic term=italic gui=italic
    highlight xmlAttrib cterm=italic term=italic gui=italic
    " highlight Type cterm=italic term=italic gui=italic
    highlight Normal ctermbg=none

    " Make vim transparent
    " highlight Normal guibg=NONE ctermbg=NONE
    " highlight NonText guibg=NONE ctermbg=NONE
    " highlight CursorLine guibg=NONE ctermbg=NONE
" }}}
