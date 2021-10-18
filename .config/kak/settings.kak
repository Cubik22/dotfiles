# kakrc

# editor settings
# ==============================================================================

# default tab size and indentation of 4 spaces
set-option global tabstop 4
set-option global indentwidth 4

# disable all default indent and insert hooks
set-option global disabled_hooks '.*-indent'
set-option global disabled_hooks '.*-insert'

# preserve indent level
hook global InsertChar \n %{
    try %{ execute-keys -draft <semicolon> K <a-&> }
}

# trim trailing whitespace on the current line when leaving insert mode
hook global ModeChange pop:insert:.* %{
    try %{ execute-keys -draft '<a-x>s\h+$<ret>d' }
}

# run the formatcmd for the current filetype on write
hook global BufWritePre .* %{
    try %{ format-buffer }
}

# load editorconfig for all buffers except special ones like *debug*
# hook global WinCreate ^[^*]+$ %{editorconfig-load}

# Enable editor config
hook global BufOpenFile .* %{ editorconfig-load }
hook global BufNewFile  .* %{ editorconfig-load }

# Show git diff
hook global BufWritePost .* %{ git show-diff }
hook global BufReload    .* %{ git show-diff }

# state save
hook global KakBegin .* %{
    state-save-reg-load colon
    state-save-reg-load pipe
    state-save-reg-load slash
}
hook global KakEnd .* %{
    state-save-reg-save colon
    state-save-reg-save pipe
    state-save-reg-save slash
}

# Completion
hook global InsertCompletionShow .* %{ try %{
    execute-keys -draft 'h<a-K>\h<ret>'
    map window insert <tab> <c-n>
    map window insert <s-tab> <c-p>
    map window insert <c-g> <c-o>
}}

hook global InsertCompletionHide .* %{
    unmap window insert <tab> <c-n>
    unmap window insert <s-tab> <c-p>
    unmap window insert <c-g> <c-o>
}

## change cursor color between normal mode and insert mode

# Shades of blue/cyan for normal mode
set-face global PrimarySelection white,bright-blue+F
set-face global SecondarySelection black,bright-blue+F
set-face global PrimaryCursor black,bright-cyan+F
set-face global SecondaryCursor black,bright-blue+F
set-face global PrimaryCursorEol black,bright-cyan
set-face global SecondaryCursorEol black,bright-blue

# Shades of green/yellow for insert mode.
hook global ModeChange (push|pop):.*:insert %{
    set-face window PrimarySelection white,bright-green+F
    set-face window SecondarySelection black,bright-green+F
    set-face window PrimaryCursor black,bright-yellow+F
    set-face window SecondaryCursor black,bright-green+F
    set-face window PrimaryCursorEol black,bright-yellow
    set-face window SecondaryCursorEol black,bright-green
}

# Undo colour changes when we leave insert mode.
hook global ModeChange (push|pop):insert:.* %{
    unset-face window PrimarySelection
    unset-face window SecondarySelection
    unset-face window PrimaryCursor
    unset-face window SecondaryCursor
    unset-face window PrimaryCursorEol
    unset-face window SecondaryCursorEol
}

# use ripgrep for grepping
set-option global grepcmd 'rg --column'

# use foot as the terminal
set-option global windowing_modules 'wayland'

# ui settings
# ==============================================================================

#colorscheme gruvbox
colorscheme gruvbox-hard-dark

add-highlighter global/ number-lines -relative -hlcursor -separator ' '
add-highlighter global/ show-matching
add-highlighter global/ wrap -word -indent -marker '↪'
# add-highlighter global/ wrap -word -indent -marker ''

# Highlight TODO/FIXME/...
add-highlighter global/ regex \b(TODO|FIXME|XXX|NOTE|REF|USAGE|REQUIREMENTS|OPTIONALS)\b 0:default+r

# Highlight trailing whitespace
# add-highlighter global/ regex \h+$ 0:Error

# require-module kak
# add-highlighter shared/kakrc/code/if_else regex \b(if|when|unless)\b 0:keyword

# Highlighters
set-face global delimiter rgb:af3a03,default
set-face global operator rgb:5a947f,default

# moded to languge-server.kak
hook global WinCreate .* %{
	add-highlighter window/delimiters		regex (\(|\)|\[|\]|\{|\}|\;|') 0:delimiter
	add-highlighter window/operators		regex (\+|-|\*|&|=|\\|\?|%|\|-|!|\||->|\.|,|<|>|:|\^|/|~) 0:operator
	# add-highlighter window/function 		regex ([a-zA-Z_0-9]+\(+)) 0:function
	# add-highlighter window/class			regex ([^a-z][A-Z][a-zA-Z_0-9]+) 0:class
}

# Highlight all occurences of word under the cursor
# set-face global CurWord default,rgba:e0e0e16e
# hook global NormalIdle .* %{
# 	eval -draft %{ try %{
# 		exec <space><a-i>w <a-k>\A\w+\z<ret>
# 		add-highlighter -override global/curword regex "\b\Q%val{selection}\E\b" 0:CurWord
# 	} catch %{
# 		add-highlighter -override global/curword group
# 	} }
# }

set-option global scrolloff 3,3
# set-option global ui_options ncurses_enable_mouse=true
# set-option global ui_options ncurses_assistant=none

#set-option global startup_info_version 20210828

# key bindings
# ==============================================================================

# space is the best leader
map global normal <space> , -docstring 'leader'

# use backspace to do what space used to do
map global normal <backspace> <space> -docstring 'remove all sels except main'
map global normal <a-backspace> <a-space> -docstring 'remove main sel'

map global normal '#' :comment-line<ret>      -docstring 'comment line'
map global normal '<a-#>' :comment-block<ret> -docstring 'comment block'

map global normal = '|fmt -w $kak_opt_autowrap_column<ret>' -docstring 'wrap lines'

# wrap to 80 characters
# map global user f '|fmt -w 80<ret>' -docstring 'wrap to 80'

# wrap to 80 with comments and shit
# map global user F '<a-x>Z<a-;>;Wyzs^<c-r>"<ret>dz|fmt -w 77<ret><a-s>ghP<space>' -docstring 'wrap to 80 and shit'

# Case-insensitive search
map global normal /     '/(?i)'
map global normal ?     '?(?i)'
map global normal <a-/> '<a-/>(?i)'
map global normal <a-?> '<a-?>(?i)'

# insert mode
map global insert <c-a> <home>
map global insert <c-e> <end>

# map global insert <c-p> <a-semicolon>P

# Custom text objects
# map global user W 'c\s,\s<ret>' -docstring "select between whitespace"

# general utility
map global user w ': w<ret>' -docstring 'write'
map global user z ': q<ret>' -docstring 'quit'
map global user g ': grep ' -docstring 'grep'
map global user t ': ctags-search<ret>' -docstring 'ctag def'
map global user d ': db<ret>' -docstring 'close buffer'
map global user m ': make<ret>' -docstring 'make'

# Git
declare-user-mode git
map global user g  ': enter-user-mode git<ret>' -docstring 'mode git'
map global git l   ': git log<ret>'             -docstring 'Log'
map global git s   ': git status<ret>'          -docstring 'Status'
map global git d   ': git diff<ret>'            -docstring 'Diff'
map global git b   ': git blame<ret>'           -docstring 'Blame'
map global git B   ': git hide-blame<ret>'      -docstring 'Hide blame'
map global git p   ': git prev-hunk<ret>'       -docstring 'Prev hunk'
map global git n   ': git next-hunk<ret>'       -docstring 'Next hunk'

# System clipboard
hook global RegisterModified '"' %{ nop %sh{
	printf %s "$kak_main_reg_dquote" | wl-copy-env > /dev/null 2>&1 &
}}
map global user p '!wl-paste-env -n<ret>'     -docstring 'paste System (before)'
map global user P '<a-!>wl-paste-env -n<ret>' -docstring 'paste System (after)'
map global user y '<a-|>wl-copy-env<ret>'     -docstring 'copy System'

# system clipboard
# map global user c '<a-|>wl-copy<ret>' -docstring 'wl-copy'
# map global user v '!wl-paste -n<ret>' -docstring 'wl-paste'

# lsp mode
map global user l ': enter-user-mode lsp<ret>' -docstring 'lsp mode'

# spell checking
declare-user-mode spell
map global spell s ': spell<ret>' -docstring 'spell'
map global spell c ': spell-clear<ret>' -docstring 'clear'
map global spell n ': spell-next<ret>' -docstring 'next'
map global spell r ': spell-replace<ret>' -docstring 'replace'
map global user s ': enter-user-mode spell<ret>' -docstring 'spell mode'

# gdb
# set-option global gdb_location_symbol ▶

#declare-user-mode gdb
#map global gdb n ': gdb-next<ret>' -docstring 'next'
#map global gdb s ': gdb-step<ret>' -docstring 'step'
#map global gdb c ': gdb-continue<ret>' -docstring 'continue'
#map global gdb f ': gdb-finish<ret>' -docstring 'finish function'
#map global gdb b ': gdb-toggle-breakpoint<ret>' -docstring 'break'
#map global gdb g ': gdb-jump-to-location<ret>' -docstring 'goto current location'
#map global gdb p ': gdb-print<ret>' -docstring 'print selection'
#map global gdb t ': gdb-backtrace<ret>' -docstring 'print backtrace'
#define-command gdb -params 0 'enter-user-mode -lock gdb' -docstring 'gdb mode'

# extra functionality
# ==============================================================================

# Fzf
define-command -docstring 'Open files with fzf' fuzzy-files %{
	try %sh{
		footclient --app-id 'float' sh -c "kak-fuzzy-files $kak_session $kak_client"
	}
}
map global user o ': fuzzy-files<ret>' -docstring '[FZF] Open Files'

# Nnn
define-command -docstring 'Open file with nnn' nnn %{
	try %sh{
		footclient --app-id 'float' sh -c "kak-nnn $kak_session $kak_client"
	}
}
map global user n ': nnn<ret>' -docstring '[NNN] Open file'

# Ripgrep
define-command -docstring 'Search with ripgrep and fzf' fuzzy-grep %{
	try %sh{
		footclient --app-id 'float' -w 1840x1000 sh -c "kak-fuzzy-grep $kak_session $kak_client"
	}
}
map global user r ': fuzzy-grep<ret>' -docstring '[FZF] Live grep'
