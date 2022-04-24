# key bindings

# use space as leader
map global normal <space> , -docstring 'leader'

# use backspace to do what space used to do
map global normal <backspace> <space> -docstring 'remove all sels except main'
map global normal <a-backspace> <a-space> -docstring 'remove main sel'

# remap 'i' and 'a' to enter insert mode without keeping selection
map global normal i hli -docstring 'enter insert mode before cursor'
map global normal a li -docstring 'enter insert mode after cursor'

# switch r and R
map global normal r R -docstring 'replace all'
map global normal R r -docstring 'replace char'

# remap x to extend selection one line down
# remap X to extend selection one line up
define-command -params 1 extend-line-down %{
  execute-keys "<a-:>%arg{1}X"
}
define-command -params 1 extend-line-up %{
  execute-keys "<a-:><a-;>%arg{1}K<a-;>"
  try %{
    execute-keys -draft ';<a-K>\n<ret>'
    execute-keys X
  }
  execute-keys '<a-;><a-X>'
}
map global normal x ':extend-line-down %val{count}<ret>'
map global normal X ':extend-line-up %val{count}<ret>'

# map control+i to jump forward
map global normal <c-i> <tab> -docstring 'jump forward'

# vim
map global normal D '<a-l>d' -docstring 'delete to end of line'
map global normal Y '<a-l>y' -docstring 'copy to end of line'

# comments
map global normal '#' :comment-line<ret> -docstring 'comment line'
map global normal '<a-#>' :comment-block<ret> -docstring 'comment block'

# wrap
set-option global autowrap_column 76
map global normal = '|fmt -w $kak_opt_autowrap_column<ret>' -docstring 'wrap lines'

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
map global insert <c-a> <home>      -docstring "goto start of line"
map global insert <c-e> <end>       -docstring "goto end of line"

# insert mode enter normal mode start/end line
map global insert <a-a> <home><esc> -docstring "enter normal mode start of line"
map global insert <a-e> <end><esc>  -docstring "enter normal mode end of line"
# map global insert <c-p> <a-semicolon>P

# repeat last command
map global normal . <a-.>
map global normal <a-.> .

# select paragraphs
map global normal \' ]p
map global normal <a-'> [p

# build
define-command build -docstring 'build in current directory' %{ nop %sh{
    if [ -f "Makefile" ]; then
        make
    elif [ -f "build.zig" ]; then
        zig build
    fi
} }
map global normal <c-m> ": w <ret>: build<ret>" -docstring "build background"

# make
# map global normal <c-m> ": w <ret>: make<ret>ga" -docstring "make background"

# custom text objects
# map global user W 'c\s,\s<ret>' -docstring "select between whitespace"

# clear highlight
map global normal <c-s-c> ': clear-ansi<ret>'                   -docstring 'clear highlight'

# lint
map global normal <c-l> ': ui-lint-toggle<ret>'                 -docstring 'toggle lint'
map global normal <c-s-l> ': lint<ret>'                         -docstring 'lint'
map global normal <c-j> ': lint-next-message<ret>'              -docstring 'lint next message'
map global normal <c-k> ': lint-previous-message<ret>'          -docstring 'lint previous message'

# selectors
# , is no longer leader key
map global normal , ': enter-user-mode selectors<ret>'          -docstring 'selectors mode'
map global selectors v ': vertical-selection-down<ret>'         -docstring 'vertical selection down'
map global selectors <a-v> ': vertical-selection-up<ret>'       -docstring 'vertical selection up'
map global selectors V ': vertical-selection-up-and-down<ret>'  -docstring 'vertical selection up and down'
# map global selectors s s                                      -docstring 'sub-selection'

# lsp mode
map global user l ': enter-user-mode lsp<ret>'                  -docstring 'lsp mode'

# man (defined in tools/man.kak)
map global user m ': enter-user-mode man<ret>'                  -docstring 'man mode'

# surround
map global user s ': enter-user-mode surround<ret>'             -docstring 'surround mode'
declare-surrounding-pair 'dollar sign' d $ $

# ui
define-command -override ui -docstring 'enter ui mode' %{
    enter-user-mode ui
}
unmap global ui
map global user u ': enter-user-mode ui<ret>'                   -docstring 'ui mode'
map global ui n ': ui-line-numbers-toggle<ret>'                 -docstring 'line numbers'
map global ui s ': ui-trailing-spaces-toggle<ret>'              -docstring 'trailing spaces'
map global ui t ': ui-tabs-toggle<ret>'                         -docstring 'tabs'
map global ui w ': ui-whitespaces-toggle<ret>'                  -docstring 'whitespaces'
map global ui x ': ui-todos-toggle<ret>'                        -docstring 'todo comments'
map global ui u ': ui-word-under-cursor-toggle<ret>'            -docstring 'word under cursor'
map global ui d ': ui-delimiters-toggle<ret>'                   -docstring 'delimiters'
map global ui o ': ui-operators-toggle<ret>'                    -docstring 'operators'
map global ui / ': ui-search-toggle<ret>'                       -docstring 'search'
map global ui m ': ui-matching-toggle<ret>'                     -docstring 'matching'
map global ui r ': ui-wrap-toggle<ret>'                         -docstring 'wrap'
map global ui l ': ui-lint-toggle<ret>'                         -docstring 'lint diagnostics'
map global ui c ': ui-cursorline-toggle<ret>'                   -docstring 'cursor line'
map global ui C ': ui-cursorcolumn-toggle<ret>'                 -docstring 'cursor column'
map global ui f ': ui-git-diff-toggle<ret>'                     -docstring 'git diff'
map global ui F ': ui-diff-one-trailing-space-toggle<ret>'      -docstring 'diff files'
map global ui a ': ui-terminal-assistant-toggle<ret>'           -docstring 'terminal assistant'
map global ui h ': ui-lsp-highlighting-toggle<ret>'             -docstring 'lsp color highlight'

# utility
declare-user-mode util
map global user t ': enter-user-mode util<ret>'                 -docstring 'utility mode'
map global util m ': make<ret>'                                 -docstring 'make'
map global util b ': build<ret>'                                -docstring 'build'
map global util l ': state-save-reg-load dquote<ret>'           -docstring 'load clipboard'
map global util s ': state-save-reg-save dquote<ret>'           -docstring 'save clipboard'
map global util t ': ctags-search<ret>'                         -docstring 'ctag def'
map global util d ': db<ret>'                                   -docstring 'close buffer'
map global util c ': palette-status<ret>'                       -docstring 'show color'
map global util p ': palette-gutter<ret>'                       -docstring 'show palette'

# git
declare-user-mode git
map global user G ': enter-user-mode git<ret>'                  -docstring 'git mode'
map global git l ': git log<ret>'                               -docstring 'log'
map global git s ': git status<ret>'                            -docstring 'status'
map global git d ': git diff<ret>'                              -docstring 'diff'
map global git b ': git blame<ret>'                             -docstring 'blame'
map global git B ': git hide-blame<ret>'                        -docstring 'hide blame'
map global git p ': git prev-hunk<ret>'                         -docstring 'prev hunk'
map global git n ': git next-hunk<ret>'                         -docstring 'next hunk'

# spell checking
declare-user-mode spell
map global user C ': enter-user-mode spell<ret>'                -docstring 'spell checking mode'
map global spell s ': spell<ret>'                               -docstring 'spell'
map global spell c ': spell-clear<ret>'                         -docstring 'clear'
map global spell n ': spell-next<ret>'                          -docstring 'next'
map global spell r ': spell-replace<ret>'                       -docstring 'replace'

# gdb
# set-option global gdb_location_symbol ▶
# declare-user-mode gdb
# define-command gdb -params 0 'enter-user-mode -lock gdb'      -docstring 'gdb mode'
# map global gdb n ': gdb-next<ret>'                            -docstring 'next'
# map global gdb s ': gdb-step<ret>'                            -docstring 'step'
# map global gdb c ': gdb-continue<ret>'                        -docstring 'continue'
# map global gdb f ': gdb-finish<ret>'                          -docstring 'finish function'
# map global gdb b ': gdb-toggle-breakpoint<ret>'               -docstring 'break'
# map global gdb g ': gdb-jump-to-location<ret>'                -docstring 'goto current location'
# map global gdb p ': gdb-print<ret>'                           -docstring 'print selection'
# map global gdb t ': gdb-backtrace<ret>'                       -docstring 'print backtrace'

# write and quit
map global user q ': q<ret>'                                    -docstring 'quit'
map global user w ': w<ret>'                                    -docstring 'write'
map global user z ': wq<ret>'                                   -docstring 'write and quit'

# select all occurrences of the main selection
map global user a '*%s<ret>'                                    -docstring 'select all'

## goto

# matching char
map global goto m '<esc>m;' -docstring 'matching char'

# buffer *debug*
map global goto d '<esc>: buffer *debug*<ret>' -docstring 'buffer *debug*'

evaluate-commands %sh{
    if [ "$KERNEL" = "Linux" ]; then
        copy_program="wl-copy-env"
        paste_program="wl-paste-env -n"
        info_program="wl-clipboard"
    else
        copy_program="clipboard-tty-copy"
        paste_program="clipboard-tty-paste"
        info_program="clipboard-tty"
    fi
    printf "%s" "
        map global user y '<a-|>$copy_program<ret>'                     -docstring 'copy to $info_program'
        map global user Y '<a-l><a-|>$copy_program<ret>'                -docstring 'copy to end of line to $info_program'
        map global user d '<a-|>$copy_program<ret><a-d>'                -docstring 'delete and copy to $info_program'
        map global user D '<a-l><a-|>$copy_program<ret><a-d>'           -docstring 'delete to end of line and copy to $info_program'
        map global user c '<a-|>$copy_program<ret><a-c>'                -docstring 'change and copy to $info_program'
        map global user p '<a-!>$paste_program<ret>'                    -docstring 'paste from $info_program (after)'
        map global user P '!$paste_program<ret>'                        -docstring 'paste from $info_program (before)'
        map global user <a-p> '<a-o>j !$paste_program<ret>'             -docstring 'paste from $info_program (below)'
        map global user <a-P> '<a-O>k !$paste_program<ret>'             -docstring 'paste from $info_program (above)'
        map global user r '!$paste_program<ret>d'                       -docstring 'replace from $info_program'
    "
    # system clipboard (tiny.kak)
    # hook global RegisterModified '"' %{ nop %sh{
    #     printf %s "$kak_main_reg_dquote" | "$copy_program" > /dev/null 2>&1 &
    # } }
}

# functionality
map global user f ': fuzzy-files<ret>'                          -docstring 'fzf files'
map global user g ': fuzzy-grep<ret>'                           -docstring 'fzf grep'
map global user n ': nnn-open<ret>'                             -docstring 'nnn open'
