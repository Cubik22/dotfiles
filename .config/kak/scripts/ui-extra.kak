# ui-extra.kak

## commands

# show line numbers
# requires number-toggle
define-command -override ui-line-numbers-toggle -docstring 'toggle line numbers' %{
    evaluate-commands %sh{
        if [ "$kak_opt_show_line_numbers" = "false" ]; then
            printf "%s" '
                set-option window show_line_numbers true
                echo -markup "{Information}line numbers enabled"
            '
        elif [ "$kak_opt_show_line_numbers" = "true" ]; then
            printf "%s" '
                set-option window show_line_numbers false
                echo -markup "{Information}line numbers disabled"
            '
        fi
    }
    number-toggle-refresh
    trigger-user-hook ui-hl-changed
}

# highlight tabs as error
define-command -override ui-tabs-toggle -docstring 'toggle tabs' %{
    try %{
        add-highlighter window/tabs regex \t 0:Error
        echo -markup "{Information}tabs enabled"
    } catch %{
        remove-highlighter window/tabs
        echo -markup "{Information}tabs disabled"
    }
    trigger-user-hook ui-hl-changed
}

## highlight delimiters and operators
## have to reload all buffer otherwise it also highlights comments

# to be called at the start because there is no need to reload buffer
define-command -override ui-delimiters-highlight -docstring 'highlight delimiters' %{
    try %{ add-highlighter window/delimiters_common regex (\(|\)|\[|\]|\{|\}|\;) 0:delimiter }
    set-option window delimiters_highlight true
}
declare-option -docstring 'highlight delimiter' bool delimiters_highlight "false"
define-command -override ui-delimiters-toggle -docstring 'toggle delimiters' %{
    evaluate-commands %sh{
        if [ "$kak_opt_delimiters_highlight" = "false" ]; then
            printf "%s" "
                reload-buffer
                ui-delimiters-highlight
                echo -markup '{Information}delimiters enabled'
            "
        elif [ "$kak_opt_delimiters_highlight" = "true" ]; then
            printf "%s" "
                remove-highlighter window/delimiters_common
                set-option window delimiters_highlight false
                echo -markup '{Information}delimiters disabled'
            "
        fi
        if [ "$kak_opt_operators_highlight" = "true" ]; then
            printf "%s" "
                ui-operators-highlight
            "
        fi
    }
    trigger-user-hook ui-hl-changed
}

# to be called at the start because there is no need to reload buffer
define-command -override ui-operators-highlight -docstring 'highlight operators' %{
    # (\s\+|\+\s|\s-|-\s)
    try %{ add-highlighter window/operators_common regex (\+|-|\*|/|\\|=|\?|!|&|%|\$|\||<|>|:|\^|~) 0:operator }
    set-option window operators_highlight true
}
declare-option -docstring 'highlight operators' bool operators_highlight "false"
define-command -override ui-operators-toggle -docstring 'toggle operators' %{
    evaluate-commands %sh{
        if [ "$kak_opt_operators_highlight" = "false" ]; then
            printf "%s" "
                reload-buffer
                ui-operators-highlight
                echo -markup '{Information}operators enabled'
            "
        elif [ "$kak_opt_operators_highlight" = "true" ]; then
            printf "%s" "
                remove-highlighter window/operators_common
                set-option window operators_highlight false
                echo -markup '{Information}operators disabled'
            "
        fi
        if [ "$kak_opt_delimiters_highlight" = "true" ]; then
            printf "%s" "
                ui-delimiters-highlight
            "
        fi
    }
    trigger-user-hook ui-hl-changed
}

# allow one trailing space only in diff output
define-command -override ui-diff-one-trailing-space-toggle -docstring 'toggle one trailing space in diff files' %{
    try %{
        add-highlighter buffer/diff-allow-one-trailing-space regex '^ ' 0:Default
        echo -markup "{Information}one trailing space diff files enabled"
    } catch %{
        remove-highlighter buffer/diff-allow-one-trailing-space
        echo -markup "{Information}one trailing space diff files disabled"
    }
    trigger-user-hook ui-hl-changed
}

# highlight word under cursor
declare-option -docstring 'add line highlighter' bool word_under_cursor "false"
define-command -override ui-word-under-cursor-toggle -docstring 'toggle highlight word under cursor' %{
    evaluate-commands %sh{
        if [ "$kak_opt_word_under_cursor" = "false" ]; then
            printf "%s" '
                hook -group word-under-cursor window NormalIdle .* %{
                    evaluate-commands -draft %{ try %{
                        execute-keys <space><a-i>w <a-k>\A\w+\z<ret>
                        add-highlighter -override window/curword regex "\b\Q%val{selection}\E\b" 0:CurWord
                    } catch %{
                        add-highlighter -override window/curword group
                    } }
                }
                set-option window word_under_cursor true
                echo -markup "{Information}highlight word under cursor enabled"
            '
        elif [ "$kak_opt_word_under_cursor" = "true" ]; then
            printf "%s" '
                remove-hooks window word-under-cursor
                remove-highlighter window/curword
                set-option window word_under_cursor false
                echo -markup "{Information}highlight word under cursor disabled"
            '
        fi
    }
    trigger-user-hook ui-hl-changed
}

# lsp color highlighting
# https://github.com/kak-lsp/kak-lsp/blob/master/rc/lsp.kak
declare-option -docstring 'add lsp highlighting' bool lsp_highlighting "false"
define-command -override ui-lsp-highlighting-toggle -docstring 'toggle lsp color highlighting' %{
    evaluate-commands %sh{
        if [ "$kak_opt_lsp_highlighting" = "false" ]; then
            printf "%s" '
                try %{ add-highlighter window/lsp_semantic_tokens ranges lsp_semantic_tokens }
                hook window -group semantic-tokens BufReload .* lsp-semantic-tokens
                hook window -group semantic-tokens NormalIdle .* lsp-semantic-tokens
                hook window -group semantic-tokens InsertIdle .* lsp-semantic-tokens
                hook -once -always window WinSetOption filetype=.* %{
                    remove-hooks window semantic-tokens
                }
                set-option window lsp_highlighting true
                echo -markup "{Information}lsp color highlighting enabled"
            '
        elif [ "$kak_opt_lsp_highlighting" = "true" ]; then
            printf "%s" '
                remove-hooks window semantic-tokens
                remove-highlighter window/lsp_semantic_tokens
                set-option window lsp_highlighting false
                echo -markup "{Information}lsp color highlighting disabled"
            '
        fi
    }
    trigger-user-hook ui-hl-changed
}

declare-option -docstring 'current terminal assistant' str current_terminal_assistant "dilbert"
define-command -override ui-terminal-assistant-reload -docstring 'reload terminal assistant' %{
    evaluate-commands %sh{
        printf "%s" "
            set-option -add global ui_options terminal_assistant=$kak_opt_current_terminal_assistant
        "
    }
}
define-command -override ui-terminal-assistant-toggle -docstring 'toggle terminal assistant' %{
    evaluate-commands %sh{
        if [ "$kak_opt_current_terminal_assistant" = "none" ]; then
            new_terminal_assistant="clippy"
        elif [ "$kak_opt_current_terminal_assistant" = "clippy" ]; then
            new_terminal_assistant="cat"
        elif [ "$kak_opt_current_terminal_assistant" = "cat" ]; then
            new_terminal_assistant="dilbert"
        elif [ "$kak_opt_current_terminal_assistant" = "dilbert" ]; then
            new_terminal_assistant="none"
        fi
        printf "%s" "
            set-option global current_terminal_assistant $new_terminal_assistant
        "
    }
    ui-terminal-assistant-reload
    trigger-user-hook ui-hl-changed
}

## ui

# done in number-toggle.kak
# add-highlighter global/ number-lines -relative -hlcursor -separator ' '

# highlight info keywords
set-face global TodoComment +r@default
set-option global ui_todo_keywords_regex "\b(TODO|FIXME|XXX|NOTE|REF|USAGE|REQUIREMENTS|OPTIONALS)\b"
# add-highlighter global/ regex \b(TODO|FIXME|XXX|NOTE|REF|USAGE|REQUIREMENTS|OPTIONALS)\b 0:default+r

# soft wrap
set-option global ui_wrap_flags -word -indent -marker '↪'
# add-highlighter global/ wrap -word -indent -marker '↪'
# add-highlighter global/ wrap -word -indent -marker ''

# set cursor line color
set-face global CursorLine default,rgb:282828
set-face global CursorColumn default,rgb:282828

# highlight trailing whitespace as errors
# add-highlighter global/trailing-whitespace regex \h+$ 0:Error

# move to languge-server.kak in order to just highlight lsp files
# hook global WinCreate .* %{
    # add-highlighter window/delimiters           regex (\(|\)|\[|\]|\{|\}|\;) 0:delimiter
    # add-highlighter window/operators            regex (\+|-|\*|&|=|\\|\?|%|\|-|!|\||->|\.|,|<|>|:|\^|/|~) 0:operator
    # add-highlighter window/function             regex ([a-zA-Z_0-9]+\(+)) 0:function
    # add-highlighter window/class                regex ([^a-z][A-Z][a-zA-Z_0-9]+) 0:class
# }

# highlight matching char of the character under the selections' cursor
# add-highlighter global/ show-matching

# highlight when search
set-face global Search @MatchingChar

# hook global WinSetOption filetype=(diff) %{
#     add-highlighter buffer/diff-allow-one-trailing-space regex '^ ' 0:Default
# }

# highlight all occurences of word under the cursor
set-face global CurWord default,rgb:3c3836

# toggle highlights at start
hook global WinCreate .* %{
    ui-line-numbers-toggle
    ui-todos-toggle
    ui-wrap-toggle
    ui-cursorline-toggle
    ui-word-under-cursor-toggle
    # ui-git-diff-toggle
    # ui-diff-one-trailing-space-toggle
    # ui-matching-toggle
    # ui-search-toggle
    ui-terminal-assistant-reload
}

hook global WinSetOption filetype=.*(?!man).* %{
    ui-trailing-spaces-toggle
}

## highlight operators and delimiters in known filetypes

# in this way it override comments highlight
# hook global WinSetOption filetype=.+ %{
#     ui-delimiters-highlight
#     ui-operators-highlight
# }

hook global WinCreate .* %{
    evaluate-commands %sh{
        if [ -n "$kak_opt_filetype" ]; then
            printf "%s" "
                ui-delimiters-highlight
                ui-operators-highlight
            "
        fi
    }
}
