# enable kak-lsp for some filetypes
evaluate-commands %sh{
    kak-lsp --kakoune -s $kak_session
}

# information on current buffer filetype
# echo %opt{filetype}

# hook global WinSetOption filetype=(sh|c|cpp|rust|zig|go|lua|python|r|latex|html|css|json|javascript|typescript) %{
# 	add-highlighter window/delimiters		regex (\(|\)|\[|\]|\{|\}|\;|') 0:delimiter
# 	add-highlighter window/operators		regex (\+|-|\*|&|=|\\|\?|%|\|-|!|\||->|\.|,|<|>|:|\^|/|~) 0:operator
# 	# add-highlighter window/function 		regex ([a-zA-Z_0-9]+\(+)) 0:function
# 	# add-highlighter window/class			regex ([^a-z][A-Z][a-zA-Z_0-9]+) 0:class
# }

hook global WinSetOption filetype=(sh|c|cpp|rust|zig|go|lua|python|r|latex|html|css|json|javascript|typescript) %{
    # attention when a file has include if there is not a space between the # it interpret the file as a c/cpp

	expandtab
    lsp-enable-window
	# lsp-auto-hover-enable
}

# uncomment to enable debug logging for kak-lsp
# set-option global lsp_cmd "kak-lsp -s %val{session} -vvv --log /tmp/kak-lsp.log"

# shell settings
hook global BufCreate .*[.](inputrc|octaverc) %{
	set-option buffer filetype sh
}
hook global BufCreate .*(renviron|rprofile) %{
	set-option buffer filetype sh
}

# shell
hook global WinSetOption filetype=sh %{
    # indent also elif
	hook window InsertChar \n -group sh-indent %{
		evaluate-commands -draft -itersel %{
			# copy the indentation of the matching if, and then re-indent afterwards
			try %{ execute-keys -draft <space> k <a-x> <a-k> \belif$ <ret> gh [c\bif\b,\bfi\b <ret> <a-x> <a-S> 1<a-&> <space> j K <a-&> j <a-gt> }
		}
	}
	set-option window formatcmd "shfmt -fn -ci"
	set-option window lintcmd "shellcheck -f gcc -x -a"
}

# c/cpp
hook global WinSetOption filetype=(c|cpp) %{
	set-option buffer formatcmd 'clang-format -style="{IndentWidth: 4,TabWidth: 4}"'
	clang-enable-autocomplete
	clang-enable-diagnostics
	alias window lint clang-parse
	alias window lint-next-error clang-diagnostics-next
}

# inlay hints are a feature supported by rust-analyzer, which show inferred types,
# parameter names in function calls, and the types of chained calls inline in the code
hook global WinSetOption filetype=rust %{
    set-option buffer formatcmd 'rustfmt'

	hook window -group rust-inlay-hints BufReload .* rust-analyzer-inlay-hints
	hook window -group rust-inlay-hints NormalIdle .* rust-analyzer-inlay-hints
	hook window -group rust-inlay-hints InsertIdle .* rust-analyzer-inlay-hints
	hook -once -always window WinSetOption filetype=.* %{
		remove-hooks window rust-inlay-hints
	}
}

# custom zig settings, basic syntax highlighting is handled by the zig.kak shipped with kakoune
hook global WinSetOption filetype=zig %{
    set-option window formatcmd 'zig fmt --stdin'

    # enable lsp support with semantic highlighting
	set-option window lsp_insert_spaces true
	set-option global lsp_server_configuration zls.zig_lib_path="/usr/lib/zig"
	set-option -add global lsp_server_configuration zls.warn_style=true
	set-option -add global lsp_server_configuration zls.enable_semantic_tokens=true

    hook window -group semantic-tokens BufReload .* lsp-semantic-tokens
    hook window -group semantic-tokens NormalIdle .* lsp-semantic-tokens
    hook window -group semantic-tokens InsertIdle .* lsp-semantic-tokens
    hook -once -always window WinSetOption filetype=.* %{
        remove-hooks window semantic-tokens
    }
}

hook global WinSetOption filetype=python %{
	# python-language-server does not currently use initialization options
	# python-language-server#403, so you can not configure it via kak-lsp.toml.
	# instead, set the lsp_config option in your kakrc to send workspace/didChangeConfiguration
	# this requires settings_section = "_" in kak-lsp.toml
	set-option global lsp_config %{
	    [language.python.settings._]
	    "pyls.configurationSources" = ["flake8"]
	}
}

# markdown
# hook global WinSetOption filetype=markdown %{
# 	set-option window formatcmd "prettier --tab-width 4 --stdin-filepath='%val{buffile}'"
# }

# makefile
# hook global BufCreate .*\.mk$ %{
#    set-option buffer filetype makefile
# }

# assemply
hook global WinSetOption filetype=gas %{
    set-option window comment_line '#'
}

# ini
hook global WinSetOption filetype=ini %{
    set-option window comment_line '#'
}

# octave

# remove from /usr/share/kak/rc/filetype/c-family.kak
# hook global BufCreate .*\.m %{
#     set-option buffer filetype objc
# }

# remove from /usr/share/kak/rc/filetype/mercury.kak
# hook global BufCreate .*[.](m) %{
#     set-option buffer filetype mercury
# }
