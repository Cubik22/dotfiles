# kakrc

### editor settings

# default tab size and indentation of 4 spaces
set-option global tabstop 4
set-option global indentwidth 4
# set-option global aligntab true

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

# enable editor config
hook global BufOpenFile .* %{ editorconfig-load }
hook global BufNewFile  .* %{ editorconfig-load }

# show git diff
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

# completion
# <c-n> <c-p> <c-o>
# hook global InsertCompletionShow .* %{ try %{
#     execute-keys -draft 'h<a-K>\h<ret>'
#     map window insert <tab> <c-n>
#     map window insert <s-tab> <c-p>
#     map window insert <c-g> <c-o>
# } }

# hook global InsertCompletionHide .* %{
#     unmap window insert <tab> <c-n>
#     unmap window insert <s-tab> <c-p>
#     unmap window insert <c-g> <c-o>
# }

### ui settings

## change cursor color between normal mode and insert mode

# shades of blue/cyan for normal mode
set-face global PrimarySelection 	white,bright-blue+g
set-face global SecondarySelection 	black,bright-blue+g
set-face global PrimaryCursor 		black,bright-cyan+fg
set-face global SecondaryCursor 	black,bright-blue+fg
set-face global PrimaryCursorEol 	black,bright-cyan
set-face global SecondaryCursorEol 	black,bright-blue

# shades of green/yellow for insert mode.
hook global ModeChange (push|pop):.*:insert %{
    set-face window PrimarySelection 	white,bright-green+g
    set-face window SecondarySelection 	black,bright-green+g
    set-face window PrimaryCursor 		black,bright-yellow+fg
    set-face window SecondaryCursor 	black,bright-green+fg
    set-face window PrimaryCursorEol 	black,bright-yellow
    set-face window SecondaryCursorEol 	black,bright-green
}

# undo colour changes when we leave insert mode.
hook global ModeChange (push|pop):insert:.* %{
    unset-face window PrimarySelection
    unset-face window SecondarySelection
    unset-face window PrimaryCursor
    unset-face window SecondaryCursor
    unset-face window PrimaryCursorEol
    unset-face window SecondaryCursorEol
}

set-option global scrolloff 3,3

# set-option -add global ui_options terminal_set_title=true
# set-option -add global ui_options terminal_status_on_top=true
# set-option -add global ui_options terminal_assistant=cat
set-option -add global ui_options terminal_assistant=dilbert
# set-option -add global ui_options terminal_assistant=none
# set-option -add global ui_options terminal_enable_mouse=false
# set-option -add global ui_options terminal_synchronized=true

set-option global startup_info_version 20211028

# tiny.kak
remove-scratch-message

# auto-pairing of characters
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

# integration
synchronize-terminal-clipboard
make-directory-on-save

# colorscheme gruvbox
colorscheme gruvbox-hard-dark

add-highlighter global/ number-lines -relative -hlcursor -separator ' '
add-highlighter global/ show-matching
add-highlighter global/ wrap -word -indent -marker '↪'
# add-highlighter global/ wrap -word -indent -marker ''

# highlight TODO/FIXME/...
add-highlighter global/ regex \b(TODO|FIXME|XXX|NOTE|REF|USAGE|REQUIREMENTS|OPTIONALS)\b 0:default+r

# highlight trailing whitespace
# add-highlighter global/ regex \h+$ 0:Error

# require-module kak
# add-highlighter shared/kakrc/code/if_else regex \b(if|when|unless)\b 0:keyword

# highlighters
# moved to colors
# delimiter red
# set-face global delimiter rgb:af3a03,default
# operator blue
# set-face global operator rgb:5a947f,default
# function yellow
# set-face global function rgb:ffba19,default
# # set-face global function rgb:d79921,default
# # set-face global function rgb:fabd2f,default
# builtin orange
# set-face global builtin rgb:f49008,default

# move to languge-server.kak in order to just highlight lsp files
hook global WinCreate .* %{
	add-highlighter window/delimiters		regex (\(|\)|\[|\]|\{|\}|\;|') 0:delimiter
	add-highlighter window/operators		regex (\+|-|\*|&|=|\\|\?|%|\|-|!|\||->|\.|,|<|>|:|\^|/|~) 0:operator
	# add-highlighter window/function 		regex ([a-zA-Z_0-9]+\(+)) 0:function
	# add-highlighter window/class			regex ([^a-z][A-Z][a-zA-Z_0-9]+) 0:class
}

# highlight all occurences of word under the cursor
set-face global CurWord default,rgb:3c3836
hook global NormalIdle .* %{
	eval -draft %{ try %{
		exec <space><a-i>w <a-k>\A\w+\z<ret>
		add-highlighter -override global/curword regex "\b\Q%val{selection}\E\b" 0:CurWord
	} catch %{
		add-highlighter -override global/curword group
	} }
}
