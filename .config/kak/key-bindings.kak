# key bindings

# space is the best leader
map global normal <space> , -docstring 'leader'

# use backspace to do what space used to do
map global normal <backspace> <space> -docstring 'remove all sels except main'
map global normal <a-backspace> <a-space> -docstring 'remove main sel'

# comments
map global normal '#' :comment-line<ret> -docstring 'comment line'
map global normal '<a-#>' :comment-block<ret> -docstring 'comment block'

# map control i to jump forward
map global normal <c-i> <tab> -docstring 'jump forward'

map global normal = '|fmt -w $kak_opt_autowrap_column<ret>' -docstring 'wrap lines'

# remap 'i' and 'a' to enter insert mode without keeping selection
map global normal i lhi -docstring 'enter insert mode before cursor'
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

# selectors
map global normal s ': enter-user-mode selectors<ret>'			-docstring 'selectors mode'
map global selectors v ': vertical-selection-down<ret>'			-docstring 'vertical selection down'
map global selectors <a-v> ': vertical-selection-up<ret>'		-docstring 'vertical selection up'
map global selectors V ': vertical-selection-up-and-down<ret>'	-docstring 'vertical selection up and down'
map global selectors s s										-docstring 'sub-selection'

# lsp mode
map global user l ': enter-user-mode lsp<ret>' -docstring 'lsp mode'

# man (defined in tools/man.kak)
map global user m ': enter-user-mode man<ret>' -docstring 'man mode'

# surround
map global user s ': enter-user-mode surround<ret>' -docstring 'surround mode'

# utility
declare-user-mode util
map global user u ': enter-user-mode util<ret>' -docstring 'utility mode'
map global util g ': grep ' 					-docstring 'grep'
map global util t ': ctags-search<ret>' 		-docstring 'ctag def'
map global util d ': db<ret>' 					-docstring 'close buffer'
map global util m ': make<ret>' 				-docstring 'make'

# git
declare-user-mode git
map global user g ': enter-user-mode git<ret>' 	-docstring 'git mode'
map global git l ': git log<ret>' 				-docstring 'log'
map global git s ': git status<ret>'          	-docstring 'status'
map global git d ': git diff<ret>'            	-docstring 'diff'
map global git b ': git blame<ret>'           	-docstring 'blame'
map global git B ': git hide-blame<ret>'      	-docstring 'hide blame'
map global git p ': git prev-hunk<ret>'       	-docstring 'prev hunk'
map global git n ': git next-hunk<ret>'       	-docstring 'next hunk'

# spell checking
declare-user-mode spell
map global user c ': enter-user-mode spell<ret>' 	-docstring 'spell checking mode'
map global spell s ': spell<ret>' 					-docstring 'spell'
map global spell c ': spell-clear<ret>' 			-docstring 'clear'
map global spell n ': spell-next<ret>' 				-docstring 'next'
map global spell r ': spell-replace<ret>' 			-docstring 'replace'

# gdb
# set-option global gdb_location_symbol ▶
# declare-user-mode gdb
# define-command gdb -params 0 'enter-user-mode -lock gdb' 	-docstring 'gdb mode'
# map global gdb n ': gdb-next<ret>' 						-docstring 'next'
# map global gdb s ': gdb-step<ret>' 						-docstring 'step'
# map global gdb c ': gdb-continue<ret>' 					-docstring 'continue'
# map global gdb f ': gdb-finish<ret>' 						-docstring 'finish function'
# map global gdb b ': gdb-toggle-breakpoint<ret>' 			-docstring 'break'
# map global gdb g ': gdb-jump-to-location<ret>' 			-docstring 'goto current location'
# map global gdb p ': gdb-print<ret>' 						-docstring 'print selection'
# map global gdb t ': gdb-backtrace<ret>' 					-docstring 'print backtrace'

# write and quit
map global user q ': q<ret>' 	-docstring 'quit'
map global user w ': w<ret>' 	-docstring 'write'
map global user z ': wq<ret>' 	-docstring 'write and quit'

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
