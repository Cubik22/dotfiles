# information on current buffer filetype
# echo %opt{filetype}

# enable kak-lsp for some filetypes
declare-option -docstring 'lsp available' bool lsp_available "false"
evaluate-commands %sh{
    if command -v kak-lsp >/dev/null 2>&1; then
        kak-lsp --kakoune -s "$kak_session"
        printf "%s" "
            set-option global lsp_available true
            hook global KakEnd .* lsp-exit
        "
    fi
}

define-command -hidden set-language-options %{
    # expand tabs
    expandtab

    # highlight trailing spaces
    ui-trailing-spaces-toggle

    # highlight tabs as errors
    # ui-tabs-toggle

    # strange indentation bug on new line
    # set-option global auto_pairs ( ) { } [ ]
    # enable-auto-pairs
}

define-command -hidden enable-lsp-options %{
    # completion trigger
    # set-option global lsp_completion_trigger "execute-keys 'h<a-h><a-k>\S[^\h\n,=;*(){}\[\]]\z<ret>'"

    # enable debug logging for kak-lsp
    # set-option global lsp_cmd "kak-lsp -s %val{session} -vvv --log /tmp/kak-lsp.log"

    # exclude diagnostics
    # set-option global lsp_show_hover_format 'printf %s "${lsp_info}"'

    # show hover anchored to hovered position
    set-option global lsp_hover_anchor true
    # indent lsp with spaces rather than tabs
    set-option global lsp_insert_spaces true

    # enable lsp in this window
    lsp-enable-window

    # automatically show hover when you move around
    # lsp-auto-hover-enable

    # execute lsp-highlight-references every time the user pauses in normal mode
    # set-option global lsp_auto_highlight_references true
    # execute lsp-code-actions every time the user pauses in normal mode
    # set-option global lsp_auto_show_code_actions true

    # show inferred types, parameter names in function calls, and the types
    # of chained calls inline in the code
    lsp-inlay-hints-enable global
    # currently rust-analyzer needs a different request
    # evaluate-commands %sh{
    #     if [ ! "$kak_opt_filetype" = "rust" ]; then
    #         printf "%s" "
    #             lsp-inlay-hints-enable global
    #         "
    #     else
    #         printf "%s" "
    #             lsp-experimental-inlay-hints-enable global
    #         "
    #     fi
    # }

    # showing diagnostics inline after their respective line (somewhat buggy)
    # lsp-inlay-diagnostics-enable global
}

# bash language server disconnects-reconnects
# when changing comment out set-language-options below in sh
# hook global WinSetOption filetype=(sh|c|cpp|rust|zig|go|lua|python|r|latex|html|css|json|javascript|typescript) %{

hook global WinSetOption filetype=(c|cpp|rust|zig|go|lua|python|r|latex|html|css|json|javascript|typescript) %{
    # enable language options
    set-language-options

    evaluate-commands %sh{
        if [ "$kak_opt_lsp_available" = "true" ]; then
            printf "%s" "
                enable-lsp-options
            "
        fi
    }
}

hook global WinSetOption filetype=kak %{
    # enable language options
    set-language-options
}

# files in which to enable language options
declare-option -hidden bool language_options false
hook global BufCreate .*newsboat/urls.* %{
    set-option buffer language_options true
}
hook global WinSetOption language_options=true %{
    # enable language options
    set-language-options
}

# shell settings
hook global BufCreate .*[.](octaverc) %{
    set-option buffer filetype sh
}
hook global BufCreate .*(renviron|rprofile) %{
    set-option buffer filetype sh
}

hook global WinSetOption filetype=roff %{
    # disable all personal insertion and indentation hooks
    set-option window disabled_hooks personalInsertIndent

    # enable language options
    set-language-options
}

# json
hook global BufSetOption filetype=json %{
    set-option buffer comment_line '//'
}
require-module json
add-highlighter shared/json/line_comment region '//' '$' fill comment

# waybar
hook global BufCreate .*waybar/config %{
    set-option buffer filetype json
}

# set filetype to sh when file start with #!/usr/bin/{sh,dash}
# for #!/usr/bin/{bash,zsh} is already working
define-command -hidden sh-additional-file-detection %{ evaluate-commands %sh{
    if [ -z "$kak_opt_filetype" ]; then
        first_line="$(head -n 1 "$kak_buffile")"
        if [ "$first_line" = "#!/usr/bin/sh" ] || \
            [ "$first_line" = "#!/usr/bin/dash" ]; then
            printf "set-option buffer filetype sh\n"
        fi
    fi
} }
hook global BufOpenFile .* sh-additional-file-detection
hook global BufWritePost .* sh-additional-file-detection

# shell
hook global WinSetOption filetype=sh %{
    set-option buffer extra_word_chars '_' '-' '+'

    # if not enabling language-server
    set-language-options

    # indent also elif
    hook window InsertChar \n -group sh-indent %{
        evaluate-commands -draft -itersel %{
            # copy the indentation of the matching if, and then re-indent afterwards
            try %{ execute-keys -draft <space> k <a-x> <a-k> \belif\b <ret> gh [c\bif\b,\bfi\b <ret> <a-x> <a-S> 1<a-&> <space> j K <a-&> j <a-gt> }
        }
    }
    set-option window formatcmd "shfmt -fn -ci"
    # done by shellcheck.kak
    # set-option window lintcmd "shellcheck -f gcc -x -a"
}

# c/cpp
hook global WinSetOption filetype=(c|cpp) %{
    # attention when a file has include if there is not a space between the # it interpret the file as a c/cpp

    # clang
    set-option window formatcmd 'clang-format -style="{IndentWidth: 4,TabWidth: 4}"'
    # clang-enable-autocomplete
    # clang-enable-diagnostics
    alias window lint clang-parse
    alias window lint-next-error clang-diagnostics-next

    # enable lsp support with semantic highlighting
    # ui-lsp-highlighting-toggle
}

# inlay hints are a feature supported by rust-analyzer, which show inferred types,
# parameter names in function calls, and the types of chained calls inline in the code
hook global WinSetOption filetype=rust %{
    set-option window formatcmd 'rustfmt'

    hook window -group rust-inlay-hints BufReload .* rust-analyzer-inlay-hints
    hook window -group rust-inlay-hints NormalIdle .* rust-analyzer-inlay-hints
    hook window -group rust-inlay-hints InsertIdle .* rust-analyzer-inlay-hints
    hook -once -always window WinSetOption filetype=.* %{
        remove-hooks window rust-inlay-hints
    }

    # enable lsp support with semantic highlighting
    # ui-lsp-highlighting-toggle
}

# custom zig settings, basic syntax highlighting is handled by the zig.kak shipped with kakoune
hook global WinSetOption filetype=zig %{
    set-option window formatcmd 'zig fmt --stdin'

    # set lsp server options
    set-option -add global lsp_server_configuration zls.zig_lib_path="/usr/lib/zig"
    set-option -add global lsp_server_configuration zls.warn_style=true
    set-option -add global lsp_server_configuration zls.enable_semantic_tokens=true

    # enable lsp support with semantic highlighting
    # ui-lsp-highlighting-toggle
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
#     set-option window formatcmd "prettier --tab-width 4 --stdin-filepath='%val{buffile}'"
# }

# makefile
# hook global BufCreate .*\.mk$ %{
#    set-option buffer filetype makefile
# }

# assemply
hook global WinSetOption filetype=gas %{
    set-option buffer comment_line '#'
}

# ini
hook global WinSetOption filetype=ini %{
    set-option buffer comment_line '#'
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
