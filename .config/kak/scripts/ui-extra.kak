# ui-extra.kak

# show line numbers
# requires number-toggle
define-command -override ui-line-numbers-toggle -docstring 'toggle line numbers' %{
    reg p %opt{show_line_numbers}
    evaluate-commands %sh{
        if [ "$kak_main_reg_p" = "false" ]; then
            printf "%s" '
                set-option window show_line_numbers true
                echo -markup "{Information}line numbers enabled"
            '
        elif [ "$kak_main_reg_p" = "true" ]; then
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

# highlight delimiters and operators
# not working overrides comment highlights

# define-command -override ui-delimiters-toggle -docstring 'toggle delimiters' %{
#     try %{
#         add-highlighter window/delimiters regex (\(|\)|\[|\]|\{|\}|\;|') 0:delimiter
#         echo -markup "{Information}delimiters enabled"
#     } catch %{
#         remove-highlighter window/delimiters
#         echo -markup "{Information}delimiters disabled"
#     }
#     trigger-user-hook ui-hl-changed
# }

# define-command -override ui-operators-toggle -docstring 'toggle operators' %{
#     try %{
#         add-highlighter window/operators regex (\+|-|\*|&|=|\\|\?|%|\|-|!|\||->|\.|,|<|>|:|\^|/|~) 0:operator
#         echo -markup "{Information}operators enabled"
#     } catch %{
#         remove-highlighter window/operators
#         echo -markup "{Information}operators disabled"
#     }
#     trigger-user-hook ui-hl-changed
# }

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
    reg p %opt{word_under_cursor}
    evaluate-commands %sh{
        if [ "$kak_main_reg_p" = "false" ]; then
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
        elif [ "$kak_main_reg_p" = "true" ]; then
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
