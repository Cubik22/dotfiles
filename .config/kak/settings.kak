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

# ui settings
# ==============================================================================

## change cursor color between normal mode and insert mode

# Shades of blue/cyan for normal mode
# set-face global PrimarySelection white,bright-blue+F
# set-face global SecondarySelection black,bright-blue+F
# set-face global PrimaryCursor black,bright-cyan+F
# set-face global SecondaryCursor black,bright-blue+F
# set-face global PrimaryCursorEol black,bright-cyan
# set-face global SecondaryCursorEol black,bright-blue

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

set-option global scrolloff 3,3
# set-option global ui_options ncurses_enable_mouse=true
# set-option global ui_options ncurses_assistant=none

# set-option global startup_info_version 20210828

# tiny.kak
remove-scratch-message

# Auto-pairing of characters
# set-option global auto_pairs ( ) { } [ ] '"' '"' "'" "'" ` ` “ ” ‘ ’ « » ‹ ›
hook global WinSetOption filetype=(.*) %{
	set-option global auto_pairs ( ) { } [ ] '"' '"' "'" "'"
}
hook global WinSetOption filetype=(octave) %{
	set-option global auto_pairs ( ) { } [ ] '"' '"'
}
hook global WinSetOption filetype=(.*) %{
	enable-auto-pairs
}

# Integration
synchronize-terminal-clipboard
make-directory-on-save

# colorscheme gruvbox
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
# done in colors
# delimiter red
# set-face global delimiter rgb:af3a03,default
# operator blue
# set-face global operator rgb:5a947f,default
# function yellow
# set-face global function rgb:ffba19,default
# set-face global function rgb:d79921,default
# set-face global function rgb:fabd2f,default
# builtin orange
# set-face global builtin rgb:f49008,default

# move to languge-server.kak in order to just highlight lsp files
hook global WinCreate .* %{
	add-highlighter window/delimiters		regex (\(|\)|\[|\]|\{|\}|\;|') 0:delimiter
	add-highlighter window/operators		regex (\+|-|\*|&|=|\\|\?|%|\|-|!|\||->|\.|,|<|>|:|\^|/|~) 0:operator
	# add-highlighter window/function 		regex ([a-zA-Z_0-9]+\(+)) 0:function
	# add-highlighter window/class			regex ([^a-z][A-Z][a-zA-Z_0-9]+) 0:class
}

# Highlight all occurences of word under the cursor
set-face global CurWord default,rgb:3c3836
hook global NormalIdle .* %{
	eval -draft %{ try %{
		exec <space><a-i>w <a-k>\A\w+\z<ret>
		add-highlighter -override global/curword regex "\b\Q%val{selection}\E\b" 0:CurWord
	} catch %{
		add-highlighter -override global/curword group
	} }
}
