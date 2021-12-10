# key bindings

# space is the best leader
map global normal <space> , -docstring 'leader'

# use backspace to do what space used to do
map global normal <backspace> <space> -docstring 'remove all sels except main'
map global normal <a-backspace> <a-space> -docstring 'remove main sel'

# comments
map global normal '#' :comment-line<ret> -docstring 'comment line'
map global normal '<c-3>' :comment-block<ret> -docstring 'comment block'

# map control i to jump forward
map global normal <c-i> <tab> -docstring 'jump forward'

map global normal = '|fmt -w $kak_opt_autowrap_column<ret>' -docstring 'wrap lines'

# remap a to enter insert mode without also selecting a character
map global normal a li -docstring 'enter insert mode after cursor'

# wrap to 80 characters
# map global user f '|fmt -w 80<ret>' -docstring 'wrap to 80'

# wrap to 80 with comments and shit
# map global user F '<a-x>Z<a-;>;Wyzs^<c-r>"<ret>dz|fmt -w 77<ret><a-s>ghP<space>' -docstring 'wrap to 80 and shit'

# case-insensitive search
map global normal /     '/(?i)'
map global normal ?     '?(?i)'
map global normal <a-/> '<a-/>(?i)'
map global normal <a-?> '<a-?>(?i)'

# insert mode go to start/end line
map global insert <c-a> <home>
map global insert <c-e> <end>

# insert mode enter normal mode start/end line
map global insert <a-a> <home><esc>
map global insert <a-e> <end><esc>

# map global insert <c-p> <a-semicolon>P

# custom text objects
# map global user W 'c\s,\s<ret>' -docstring "select between whitespace"

# general utility
map global user w ': w<ret>' -docstring 'write'
map global user z ': q<ret>' -docstring 'quit'
map global user g ': grep ' -docstring 'grep'
map global user t ': ctags-search<ret>' -docstring 'ctag def'
map global user d ': db<ret>' -docstring 'close buffer'
map global user m ': make<ret>' -docstring 'make'

# git
declare-user-mode git
map global user g  ': enter-user-mode git<ret>' -docstring 'mode git'
map global git l   ': git log<ret>'             -docstring 'Log'
map global git s   ': git status<ret>'          -docstring 'Status'
map global git d   ': git diff<ret>'            -docstring 'Diff'
map global git b   ': git blame<ret>'           -docstring 'Blame'
map global git B   ': git hide-blame<ret>'      -docstring 'Hide blame'
map global git p   ': git prev-hunk<ret>'       -docstring 'Prev hunk'
map global git n   ': git next-hunk<ret>'       -docstring 'Next hunk'

# system clipboard
hook global RegisterModified '"' %{ nop %sh{
	printf %s "$kak_main_reg_dquote" | wl-copy-env > /dev/null 2>&1 &
} }
map global user P '!wl-paste-env -n<ret>'     -docstring 'paste system (before)'
map global user p '<a-!>wl-paste-env -n<ret>' -docstring 'paste system (after)'
map global user y '<a-|>wl-copy-env<ret>'     -docstring 'copy system'

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

# declare-user-mode gdb
# map global gdb n ': gdb-next<ret>' -docstring 'next'
# map global gdb s ': gdb-step<ret>' -docstring 'step'
# map global gdb c ': gdb-continue<ret>' -docstring 'continue'
# map global gdb f ': gdb-finish<ret>' -docstring 'finish function'
# map global gdb b ': gdb-toggle-breakpoint<ret>' -docstring 'break'
# map global gdb g ': gdb-jump-to-location<ret>' -docstring 'goto current location'
# map global gdb p ': gdb-print<ret>' -docstring 'print selection'
# map global gdb t ': gdb-backtrace<ret>' -docstring 'print backtrace'
# define-command gdb -params 0 'enter-user-mode -lock gdb' -docstring 'gdb mode'
