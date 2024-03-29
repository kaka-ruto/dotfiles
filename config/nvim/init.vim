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
    set statusline+=%F " always show file full path
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
    set colorcolumn=120

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

    " Show old word when you type cw
    " set cpoptions=$

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
    Plug 'navarasu/onedark.nvim'

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
    " Or use ]p to paste whilst respecting indent level

    " Yank all lines in file
    map <leader>co :%y+<cr>
    " Highlight all file (like ctrl A)
    map <leader>vv ggVG
    " Ctrl A + paste
    map <leader>pp ggVGp
    " Copy current file path
    nnoremap <leader>cd :let @+=expand('%')<CR>
    " Copy current file name with extension
    nnoremap <leader>cf :let @+=expand('%:t')<CR>
    " Copy current file path with line number
    nnoremap <leader>cl :let @+=expand('%') . ':' . line('.')<CR>

    " Pastes the last yanked text instead of any recently deleted text
    nnoremap yp "0p<Esc>

    " When pasting over a visual selection replaced visual selection won't enter the register
    xnoremap vp "_dp

    " Deletes a visual selection without adding it to register
    xnoremap dv "_dd<Esc>

    " Deletes a line like dd but doesn't add to register
    nnoremap dl "_dd

    " Edit the vimrc/initvim
    nnoremap cv :edit $INITVIM <cr>

    " Automatically reload vimrc on edit
    if has ('autocmd') " Remain compatible with earlier versions
      augroup vimrc     " Source vim configuration upon save
        autocmd! BufWritePost $INITVIM source % | echom "Reloaded " . $INITVIM | redraw
        autocmd! BufWritePost $INITVIM if has('gui_running') | so % | echom "Reloaded " . $INITVIM | endif | redraw
      augroup END
      " Create non-existing directories when I write a new file with :e path/to/new_file.rb
      autocmd BufWritePre *
            \ if '<afile>' !~ '^scp:' && !isdirectory(expand('<afile>:h')) |
            \ call mkdir(expand('<afile>:h'), 'p') |
            \ endif
    endif " has autocmd

    " edit gitconfig
    map <leader>eg :e! ~/.gitconfig<cr>
    " Open a file in the same dir as the open buffer
    map ,e :e <C-R>=expand("%:h") . "/" <CR>
    " split open a file in the same dir as the open buffer
    map ,v :vs <C-R>=expand("%:h") . "/" <CR>

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

    nmap <leader>sl :set list!<cr>

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

    Plug 'tpope/vim-commentary'
    " comment a line or visual block
    nmap \\ gcc
    vmap \\ gcc
    " Comment paragraph
    nmap c\\ gcap
    " Uncomment a line or lines of comments
    nmap u\\ gcgc
    " Delete a line or lines of comments
    nmap d\\ dgc
    " Delete all lines(comments?) starting with #
    nmap <leader>dc :g/#/d <CR>

    " mappings which are simply short normal mode aliases for commonly used ex commands
    Plug 'tpope/vim-unimpaired'

    " endings for html, xml, etc. - ehances surround
    Plug 'tpope/vim-ragtag'

    " mappings to easily delete, change and add such surroundings in pairs, such as quotes, parens, etc.
    Plug 'tpope/vim-surround'

    Plug 'tpope/vim-dispatch'

    " Save vim/neovim sessions
    Plug 'tpope/vim-obsession'

    " Better Netrw
    Plug 'tpope/vim-vinegar'
    " Open netrw in the current working dir
    nnoremap <leader>fa :Lex %:p:h<CR>
    " Open netrw in the dir of the current file
    nnoremap <Leader>ff :Lex<CR>
    " Remap NetrwRefresh to use c-re instead of c-l
    nmap <c-re> <Plug>NetrwRefresh
    let g:netrw_liststyle = 3  " Use tree view
    let g:netrw_winsize = 10 " Smaller default window size
    " let g:netrw_keepdir = 0 " Keep current and browsing dir synced
    let g:netrw_browse_split = 4 "Open files in the prev window
    let g:netrw_preview   = 1   " Open previews vertically

    function! NetrwMapping()
      " Go back in history
      nmap <buffer> H u
      " Go up a dir
      nmap <buffer> h -^
      " Open a dir or file
      " nmap <buffer> l <CR>
      " Toggle dotfiles
      nmap <buffer> . gh
      " Close the preview window
      nmap <buffer> P <C-w>z
      " Open a file and close netrw
      nmap <buffer> L <CR>:Lex<CR>
      " Close netrw
      nmap <buffer> <Leader>ff :Lex<CR>
    endfunction
     
    " Read or write files with sudo
    Plug 'lambdalisue/suda.vim'
    let g:suda_smart_edit = 1

    " Insert or delete brackets, parens, quotes in pair
    Plug 'jiangmiao/auto-pairs'

    " {{{ Run your tests at the speed of thought
        Plug 'janko/vim-test'
        Plug 'preservim/vimux'
         Plug 'voldikss/vim-floaterm'

        nmap <silent> <C-n> :TestNearest <CR>
        nmap <silent> <C-\> :TestFile <CR>
        nmap <silent> <C-s> :TestSuite <CR>
        nmap <silent> <C-g> :TestLast <CR>
        " nmap <silent> <C-g> :TestVisit <CR>

        " Execute tests using dispatch
        let test#strategy = 'vimux'
    " }}}

    " enables repeating other supported plugins with the . command
    Plug 'tpope/vim-repeat'

    " .editorconfig support
    Plug 'editorconfig/editorconfig-vim'
    let g:EditorConfig_exclude_patterns = ['fugitive://.*']

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

    " Enable opening a file in a given line
    Plug 'bogado/file-line'

    Plug 'junegunn/vim-peekaboo'

    " FZF {{{
        " Plug 'junegunn/fzf.vim' | Plug '/usr/local/opt/fzf'
        " set rtp+=/usr/local/opt/fzf
        Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
        Plug 'junegunn/fzf.vim'
        Plug 'yuki-yano/fzf-preview.vim', { 'branch': 'release/rpc' }

        " FZF with floating previews
        noremap [fzf-p] <Nop>
        nmap <leader> [fzf-p]
        xmap <leader> [fzf-p]

        " fzf-preview with vim-script RPC
        nnoremap <silent> [fzf-p]p     :<C-u>FzfPreviewFromResourcesRpc git<CR>
        nnoremap          [fzf-p]d     :<C-u>FzfPreviewDirectoryFilesRpc<space>
        nnoremap <silent> [fzf-p]gss    :<C-u>FzfPreviewGitStatusRpc<CR>
        nnoremap <silent> [fzf-p]ga    :<C-u>FzfPreviewGitActionsRpc<CR>
        nnoremap <silent> [fzf-p]b     :<C-u>FzfPreviewBuffersRpc<CR>
        nnoremap <silent> [fzf-p]B     :<C-u>FzfPreviewAllBuffersRpc<CR>
        nnoremap <silent> [fzf-p]oo    :<C-u>FzfPreviewFromResourcesRpc buffer project_mru<CR>
        nnoremap <silent> [fzf-p]mm    :<C-u>FzfPreviewMruFilesRpc<CR>
        nnoremap <silent> [fzf-p]ww    :<C-u>FzfPreviewMrwFilesRpc<CR>
        nnoremap <silent> [fzf-p]<C-o> :<C-u>FzfPreviewJumpsRpc<CR>
        nnoremap <silent> [fzf-p]g;    :<C-u>FzfPreviewChangesRpc<CR>
        nnoremap <silent> [fzf-p]/     :<C-u>FzfPreviewLinesRpc --add-fzf-arg=--no-sort --add-fzf-arg=--query="'"<CR>
        nnoremap <silent> [fzf-p]*     :<C-u>FzfPreviewLinesRpc --add-fzf-arg=--no-sort --add-fzf-arg=--query="'<C-r>=expand('<cword>')<CR>"<CR>
        nnoremap          [fzf-p]gr    :<C-u>FzfPreviewProjectGrepRpc<Space>
        xnoremap          [fzf-p]gr    "sy:FzfPreviewProjectGrepRpc<Space>-F<Space>"<C-r>=substitute(substitute(@s, '\n', '', 'g'), '/', '\\/', 'g')<CR>"
        nnoremap <silent> [fzf-p]bt    :<C-u>FzfPreviewBufferTagsRpc<CR>
        nnoremap <silent> [fzf-p]tt    :<C-u>FzfPreviewCtagsRpc<CR>
        nnoremap <silent> [fzf-p]u     :<C-u>FzfPreviewQuickFixRpc<CR>
        nnoremap <silent> [fzf-p]ll    :<C-u>FzfPreviewLocationListRpc<CR>

        " fzf-preview with coc
        " nnoremap <silent> [fzf-p]p     :<C-u>CocCommand fzf-preview.FromResources git<CR>
        " nnoremap          [fzf-p]d     :<C-u>CocCommand fzf-preview.DirectoryFiles<space>
        " nnoremap <silent> [fzf-p]gss    :<C-u>CocCommand fzf-preview.GitStatus<CR>
        " nnoremap <silent> [fzf-p]ga    :<C-u>CocCommand fzf-preview.GitActions<CR>
        " nnoremap <silent> [fzf-p]b     :<C-u>CocCommand fzf-preview.Buffers<CR>
        " nnoremap <silent> [fzf-p]B     :<C-u>CocCommand fzf-preview.AllBuffers<CR>
        " nnoremap <silent> [fzf-p]oo    :<C-u>CocCommand fzf-preview.FromResources buffer project_mru<CR>
        " nnoremap <silent> [fzf-p]mm    :<C-u>CocCommand fzf-preview.MruFiles<CR>
        " nnoremap <silent> [fzf-p]ww    :<C-u>CocCommand fzf-preview.MrwFiles<CR>
        " nnoremap <silent> [fzf-p]<C-o> :<C-u>CocCommand fzf-preview.Jumps<CR>
        " nnoremap <silent> [fzf-p]g;    :<C-u>CocCommand fzf-preview.Changes<CR>
        " nnoremap <silent> [fzf-p]/     :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'"<CR>
        " nnoremap <silent> [fzf-p]*     :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'<C-r>=expand('<cword>')<CR>"<CR>
        " nnoremap          [fzf-p]gr    :<C-u>CocCommand fzf-preview.ProjectGrep<Space>
        " xnoremap          [fzf-p]gr    "sy:CocCommand   fzf-preview.ProjectGrep<Space>-F<Space>"<C-r>=substitute(substitute(@s, '\n', '', 'g'), '/', '\\/', 'g')<CR>"
        " nnoremap <silent> [fzf-p]go    :<C-u>CocCommand fzf-preview.CocOutline<CR>
        " nnoremap <silent> [fzf-p]gi    :<C-u>CocCommand fzf-preview.CocImplementations<CR>
        " nnoremap <silent> [fzf-p]gt    :<C-u>CocCommand fzf-preview.CocTypeDefinitions<CR>
        " nnoremap <silent> [fzf-p]gf    :<C-u>CocCommand fzf-preview.CocReferences<CR>
        " " Reuse last query
        " nnoremap <Leader>G :<C-u>CocCommand fzf-preview.ProjectGrep . --resume<Space>
        " nnoremap <silent> [fzf-p]tt     :<C-u>CocCommand fzf-preview.BufferTags<CR>
        " nnoremap <silent> [fzf-p]u     :<C-u>CocCommand fzf-preview.QuickFix<CR>
        " nnoremap <silent> [fzf-p]ll     :<C-u>CocCommand fzf-preview.LocationList<CR>

        " Use vim-devicons
        " let g:fzf_preview_use_dev_icons = 0
        " devicons character width
        " let g:fzf_preview_dev_icon_prefix_string_length = 3
        " let g:fzf_preview_command = 'bat --color=always --plain {-1}'
        " " Commands used for project grep
        " let g:fzf_preview_grep_cmd = 'rg --line-number --no-heading --hidden -g \!"* *"'
        
        "Use true color preview in Neovim 
        augroup fzf_preview
          autocmd!
          " autocmd User fzf_preview#rpc#initialized call s:fzf_preview_settings() 
          " autocmd User fzf_preview#coc#initialized call s:fzf_preview_settings() 
          autocmd User fzf_preview#remote#initialized call s:fzf_preview_settings() 
        augroup END

        function! s:fzf_preview_settings() abort
          let g:fzf_preview_command = 'COLORTERM=truecolor ' . g:fzf_preview_command
          let g:fzf_preview_grep_preview_cmd = 'COLORTERM=truecolor ' . g:fzf_preview_grep_preview_cmd
        endfunction
    " }}}

    " vim-fugitive {{{
        Plug 'tpope/vim-fugitive'
        nnoremap gap :Git add %:p<CR><CR>
        " Add current file
        nnoremap <leader>gs :0G<CR>
        nnoremap gaf :Git add %<CR><CR>
        nnoremap gaa :Git add . <CR><CR>
        nnoremap goo :Gcommit -v -q<CR>
        nnoremap gtt :Gcommit -v -q %:p<CR>
        nnoremap gdd :Gdiffsplit!<CR>
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
        nnoremap gpf :Dispatch! Git push --force-with-lease<CR>
        nnoremap gpl :Dispatch! Git pull<CR>
        nnoremap gbb :Gblame<CR>
        nnoremap g- :Silent Git stash<CR>:e<CR>
        nnoremap g+ :Silent Git stash pop<CR>:e<CR>
        " Merge conflicts
        nnoremap <leader>ll :diffget //3<CR>
        nnoremap <leader>hh :diffget //2<CR>
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
        " Hit tab to scroll dropdown of suggestions
        imap <Tab> <C-n>

        " Popular snippets
        Plug 'honza/vim-snippets'
    " }}}

    " Linting {{{
        Plug 'desmap/ale-sensible' | Plug 'dense-analysis/ale'

        let g:ale_linters_explicit = 1 " Run specific linters
        " let g:ale_disable_lsp = 1 " Don't provide LSP features already provided by coc.nvim
        " Set specific linters
        let g:ale_linters = {
              \   'javascript': ['eslint'],
              \   'javascriptreact': ['prettier'],
              \   'ruby': ['rubocop']
              \}
        let g:ale_fixers = {
              \   '*': ['remove_trailing_lines', 'trim_whitespace'],
              \   'javascript': ['prettier'],
              \   'javascriptreact': ['prettier'],
              \   'ruby': ['rubocop']
              \}
        let g:ale_set_highlights = 0      " Disable ALE auto highlights
        let g:ale_sign_column_always = 1  " Show the error sign always
        " let g:ale_fix_on_save = 1
        let g:ale_javascript_prettier_options = '--single-quote --trailing-comma all'
        let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
        let g:ale_sign_error = '✘'
        let g:ale_sign_warning = '⚠'
        let g:ale_lint_on_text_changed = 'never'

        nmap <leader>f :ALEFix <CR>
    " }}}

    " coc {{{
        Plug 'neoclide/coc.nvim', {'branch': 'release'}

        let g:coc_global_extensions = [
        \ 'coc-css',
        \ 'coc-json',
        \ 'coc-git',
        \ 'coc-pairs',
        \ 'coc-sh',
        \ 'coc-vimlsp',
        \ 'coc-emmet',
        \ 'coc-ultisnips',
        \ 'coc-solargraph',
        \ 'coc-tailwindcss',
        \ 'coc-vetur'
        \ ]

        autocmd CursorHold * silent call CocActionAsync('highlight')
        " autocmd FileType elixir let b:coc_root_patterns = ['mix.exs']

        " coc-prettier
        " command! -nargs=0 Prettier :CocCommand prettier.formatFile
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

      Plug 'luochen1990/rainbow'
      let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle

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
    " }}}

    " Regenerate tags and get the task out of my way
    Plug 'ludovicchabant/vim-gutentags'
    let g:gutentags_add_default_project_roots = 0
    let g:gutentags_project_root  = ['package.json', '.git', '.hg', '.svn']
    let g:gutentags_cache_dir = expand('~/.gutentags_cache')
    let g:gutentags_exclude_filetypes = ['gitcommit', 'gitconfig', 'gitrebase', 'gitsendemail', 'git']
    let g:gutentags_generate_on_new = 1
    let g:gutentags_generate_on_missing = 1
    let g:gutentags_generate_on_write = 1
    let g:gutentags_generate_on_empty_buffer = 0
    let g:gutentags_ctags_extra_args = ['--tag-relative=yes', '--fields=+ailmnS']
    let g:gutentags_ctags_exclude = [
    \  '*.git', '*.svn', '*.hg',
    \  'cache', 'build', 'dist', 'bin', 'node_modules', 'bower_components',
    \  '*-lock.json',  '*.lock',
    \  '*.min.*',
    \  '*.bak',
    \  '*.zip',
    \  '*.pyc',
    \  '*.class',
    \  '*.sln',
    \  '*.tmp',
    \  '*.cache',
    \  '*.pdb',
    \  '*.exe', '*.dll', '*.bin',
    \  '*.swp', '*.swo',
    \  '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png', '*.svg',
    \  '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2',
    \  '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx', '*.xls',
    \]
    Plug 'vim-scripts/taglist.vim'
    " Open first tag match on a horizontal split
    nnoremap <leader>] <Esc>:exe "ptag " . expand("<cword>")<Esc>
    " Split below
    set splitbelow
    " Next tag
    nnoremap <leader>m :ptnext <CR>
    " Prev tag
    nnoremap <leader>n :ptprevious <CR>
    " Close tag preview window
    nnoremap <leader>z <C-w>z

    " {{{ Ruby and RoR
        Plug 'vim-ruby/vim-ruby'
        " Configure vim-ruby to use the same indentation style as standardrb
        let g:ruby_indent_assignment_style = 'variable'
        Plug 'tpope/vim-rails'
        Plug 'tpope/vim-bundler'
        Plug 'tpope/vim-rake'

        vnoremap <leader>ex :Extract<space>

        " For projectionist.vim (comes with rake.vim)
        let g:rails_projections = {
              \  "app/controllers/*_controller.rb": {
              \      "test": [
              \        "spec/requests/{}_request_spec.rb",
              \        "spec/controllers/{}_controller_spec.rb",
              \        "test/controllers/{}_controller_test.rb"
              \      ],
              \      "alternate": [
              \        "spec/requests/{}_request_spec.rb",
              \        "spec/controllers/{}_controller_spec.rb",
              \        "test/controllers/{}_controller_test.rb"
              \      ],
              \   },
              \   "spec/requests/*_request_spec.rb": {
              \      "command": "request",
              \      "alternate": "app/controllers/{}_controller.rb",
              \      "template": "require 'rails_helper'\n\n" .
              \        "RSpec.describe '{}' do\nend",
              \   },
              \ }

        Plug 'vim-scripts/a.vim'
        Plug 'ecomba/vim-ruby-refactoring'

        " C-c, C-c to send code to a REPL
        " Plug 'jpalardy/vim-slime'
        " let g:slime_target = "tmux"

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
      
    " Elixir {{{
        " Plug 'elixir-editors/vim-elixir'
        " Plug 'elixir-lsp/coc-elixir', {'do': 'yarn install && yarn prepack'}
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
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-treesitter/nvim-treesitter-textobjects'
    Plug 'romgrk/nvim-treesitter-context'

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
  let g:ruby_host_prog = "/opt/homebrew/opt/asdf/shims/ruby"
  " let g:ruby_host_prog = '~/.asdf/shims/ruby'
  " let g:python_host_prog = '~/.asdf/shims/python2'
  " Disable python 2 support
  let g:loaded_python_provider = 0
  " let g:python3_host_prog = '~/.asdf/shims/python'
  let g:python3_host_prog = "/opt/homebrew/opt/asdf/shims/python"
  let g:node_host_prog = '~/.nvm/versions/node/v16.15.0/bin/neovim-node-host'
  let g:loaded_perl_provider = 0
  " let $PATH = '.nvm/versions/node/v16.15.0/bin:' . $PATH

" Colorscheme and final setup {{{
    " This call must happen after the plug#end() call to ensure
    " that the colorschemes have been loaded

    colorscheme onedark
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
    highlight Search guibg=DarkGray

    " Make vim transparent
    " highlight Normal guibg=NONE ctermbg=NONE
    " highlight NonText guibg=NONE ctermbg=NONE
    " highlight CursorLine guibg=NONE ctermbg=NONE
" }}}
