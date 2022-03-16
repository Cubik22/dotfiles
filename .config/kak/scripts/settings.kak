# settings

### editor settings

# default tab size and indentation of 4 spaces
set-option global tabstop 4
set-option global indentwidth 4

# number of lines, columns to keep visible around the cursor when scrolling
set-option global scrolloff 3,3

# use tabs for alignment command
# set-option global aligntab true

# display automatic information box in the enabled contexts
# set-option global autoinfo command|onkey|normal

# options that are forwarded to the user interface implementation NCurses UI
# set-option -add global ui_options terminal_set_title=true
# set-option -add global ui_options terminal_status_on_top=true
set-option -add global ui_options terminal_enable_mouse=false
# set-option -add global ui_options terminal_synchronized=true

# messages in the startup info box only from the version greater than the value
set-option global startup_info_version 20211028

# disable all default insert hooks
# set-option global disabled_hooks '.*-insert.*'
# disable all default indent hooks
# set-option global disabled_hooks '.*-indent.*'
# disable all default insert and indent hooks
set-option global disabled_hooks '.*-insert.*|.*-indent.*'

# use ripgrep for grepping
set-option global grepcmd 'rg --column'

# use foot as the terminal
set-option global windowing_modules 'wayland'

# trim trailing whitespaces on empty line when leaving insert mode
hook global ModeChange pop:insert:.* -group personalInsertIndent %{
    try %{ execute-keys -draft <a-x>s^\h+$<ret>d }
}

# preserve indent level and trim trailing whitespaces
hook global InsertChar \n -group personalInsertIndent %{
    # preserve indent level
    try %{ execute-keys -draft <semicolon>K<a-&> }

    # trim trailing whitespaces
    try %{ execute-keys -draft k<a-x>s\h+$<ret>d }
}

# run the formatcmd for the current filetype on write
# hook global BufWritePre .* %{
#     try %{ format-buffer }
# }

# load editorconfig for all buffers except special ones like *debug*
# hook global WinCreate ^[^*]+$ %{editorconfig-load}

# enable editor config
# hook global BufOpenFile .* %{ editorconfig-load }
# hook global BufNewFile  .* %{ editorconfig-load }

# show git diff
# hook global BufWritePost .* %{ git show-diff }
# hook global BufReload    .* %{ git show-diff }

## state save

define-command state-save-reg-load-important -docstring "load important registers from disk" %{
    state-save-reg-load colon
    state-save-reg-load pipe
    state-save-reg-load slash
}
define-command state-save-reg-save-important -docstring "save important registers on disk" %{
    state-save-reg-save colon
    state-save-reg-save pipe
    state-save-reg-save slash
}

hook global KakBegin .* %{
    state-save-reg-load-important
}
hook global KakEnd .* %{
    state-save-reg-save-important
}

# sync yank/paste buffer between kakoune session
# hook global FocusOut .* %{ state-save-reg-save dquote }
# hook global FocusIn  .* %{ state-save-reg-load dquote }

## auto-pairs.kak

# auto-pairing of characters with quotes
# set-option global auto_pairs ( ) { } [ ] '"' '"' "'" "'" ` ` “ ” ‘ ’ « » ‹ ›
# hook global WinSetOption filetype=(.*) %{
#     set-option global auto_pairs ( ) { } [ ] '"' '"' "'" "'"
# }
# hook global WinSetOption filetype=(octave) %{
#     set-option global auto_pairs ( ) { } [ ] '"' '"'
# }
# hook global WinSetOption filetype=(.*) %{
#     enable-auto-pairs
# }

# auto-pairing of characters without quotes
set-option global auto_pairs ( ) { } [ ]
# done in languages.kak
# enable-auto-pairs

## tiny.kak

# integration
make-directory-on-save

# synchronize-terminal-clipboard
# remove error scratch message
# remove-scratch-message

## number-toggle.kak

# require-module "number-toggle"

## crosshairs.kak

# set-face global crosshairs_line default,rgb:282828
# set-face global crosshairs_column default,rgb:282828
# cursorline
# crosshairs

### ui settings

# colorscheme gruvbox
colorscheme gruvbox-hard-dark

## change cursor color between normal mode and insert mode

# shades of blue/cyan for normal mode
# set-face global PrimarySelection          white,bright-blue+g
# set-face global SecondarySelection        black,bright-blue+g
# set-face global PrimaryCursor             black,bright-cyan+fg
# set-face global SecondaryCursor           black,bright-blue+fg
# set-face global PrimaryCursorEol          black,bright-cyan
# set-face global SecondaryCursorEol        black,bright-blue

# shades of green/yellow for insert mode
hook global ModeChange (push|pop):.*:insert %{
    set-face window PrimarySelection        white,bright-green+g
    set-face window SecondarySelection      black,bright-green+g
    set-face window PrimaryCursor           black,bright-yellow+fg
    set-face window SecondaryCursor         black,bright-green+fg
    set-face window PrimaryCursorEol        black,bright-yellow
    set-face window SecondaryCursorEol      black,bright-green
}

# undo colour changes when leaving insert mode
hook global ModeChange (push|pop):insert:.* %{
    unset-face window PrimarySelection
    unset-face window SecondarySelection
    unset-face window PrimaryCursor
    unset-face window SecondaryCursor
    unset-face window PrimaryCursorEol
    unset-face window SecondaryCursorEol
}
