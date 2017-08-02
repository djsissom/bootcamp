" All system-wide defaults are set in $VIMRUNTIME/debian.vim (usually just
" /usr/share/vim/vimcurrent/debian.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
" do it in this file (/etc/vim/vimrc), since debian.vim will be overwritten
" everytime an upgrade of the vim packages is performed.  It is recommended to
" make changes after sourcing debian.vim since it alters the value of the
" 'compatible' option.

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible

" Vim5 and later versions support syntax highlighting. Uncommenting the
" following enables syntax highlighting by default.
if has("syntax")
	set t_Co=256
	syntax on
	" Uncomment the following 'let' lines if using xter16 color scheme
	" Select colormap: 'soft', 'softlight', 'standard', or 'allblue'
	let xterm16_colormap = 'allblue'
	" Select brightness: 'low', 'med', 'high', 'default', or custom levels
	let xterm16_brightness = 'high'
	"Other override options:
	let xterm16fg_Cursor = '555'
	let xterm16bg_Normal = 'none'
	"Set color scheme
	colorscheme xterm16
endif

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
	au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
	filetype plugin indent on
endif

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set showcmd             " Show (partial) command in status line.
set showmatch           " Show matching brackets.
set ignorecase          " Do case insensitive matching
set smartcase           " Do smart case matching
"set incsearch          " Incremental search
"set autowrite          " Automatically save before commands like :next and :make
"set hidden             " Hide buffers when they are abandoned
set mouse=a             " Enable mouse usage (all modes)
set nohlsearch          " Turn off search highlighting
"set expandtab           " Turn tabs to spaces
set shiftwidth=4        " Auto-indent amount when using cindent, <<, >>, etc.
set softtabstop=4       " How many spaces represent a tab
set tabstop=4           " Real tab size
set autoindent    " Indent level of new line set by previous line
"set smartindent   " Attempt to intelligently guess level of indent for new line
set cindent   " Attempt to intelligently guess level of indent for new line
set nf=octal,hex,alpha	" additional ctrl-a increments
set spell spelllang=en_us
set backspace=indent,eol,start

noremap n nzz
noremap N Nzz
noremap * *zz
noremap # #zz
noremap g* g*zz
noremap g# g#zz


au BufNewFile,BufRead *.cu set filetype=c

aug python
	" to override ftype/python.vim
	au FileType python setlocal ts=4 sts=4 sw=4 noexpandtab
aug end

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
	source /etc/vim/vimrc.local
endif

syntax spell toplevel
