# Enable kak-lsp for some filetypes
evaluate-commands %sh{kak-lsp --kakoune -s $kak_session}
hook global WinSetOption filetype=(sh|c|cpp|rust|zig|python|html|css|json) %{
    lsp-enable-window
}

#hook global WinSetOption filetype=(sh|c|cpp|rust|zig|python|html|css|json) expandtab

# uncomment to enable debug logging for kak-lsp
#set-option global lsp_cmd "kak-lsp -s %val{session} -vvv --log /tmp/kak-lsp.log"

# Shell
hook global WinSetOption filetype=sh %{
	set-option window formatcmd "shfmt -fn -ci"
	set-option window lintcmd "shellcheck -f gcc -x -a"
}

# C/Cpp
hook global WinSetOption filetype=(c|cpp) %{
    set-option buffer formatcmd 'clang-format'
}

# Inlay hints are a feature supported by rust-analyzer, which show inferred types,
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

    # Enable lsp support with semantic highlighting
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

# python-language-server does not currently use initialization options
# python-language-server#403, so you can not configure it via kak-lsp.toml.
# Instead, set the lsp_config option in your kakrc to send workspace/didChangeConfiguration
# This requires settings_section = "_" in kak-lsp.toml
set-option global lsp_config %{
    [language.python.settings._]
    "pyls.configurationSources" = ["flake8"]
}

# Markdown
#hook global WinSetOption filetype=markdown %{
#	set-option window formatcmd "prettier --tab-width 4 --stdin-filepath='%val{buffile}'"
#}

# Makefile
#hook global BufCreate .*\.mk$ %{
#    set-option buffer filetype makefile
#}

# Assemply
hook global WinSetOption filetype=gas %{
    set-option window comment_line '#'
}
