## detection

hook global BufCreate .*\.(g?roff|ms|me|mm|man) %{
    set-option buffer filetype roff
}

## initialization

hook global WinSetOption filetype=roff %{
    require-module roff

    # insert on new line hook
    hook window InsertChar \n -group roff roff-insert-on-new-line

    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window roff.+ }
}

hook -group roff-highlight global WinSetOption filetype=roff %{
    add-highlighter window/roff ref roff
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/roff }
}

hook global BufSetOption filetype=roff %{
    set-option buffer comment_line '\#'
    # set-option buffer comment_line '.\"'
}

provide-module roff %§

## highlighters

add-highlighter shared/roff regions
add-highlighter shared/roff/code default-region group

# https://www.gnu.org/software/groff/manual/html_node/Comments.html
add-highlighter shared/roff/comment region '\\#' '$' fill comment
add-highlighter shared/roff/old_comment region '\.?\\"' '$' fill comment

# add-highlighter shared/roff/comment regex '(^\.)?\\".*?\n' 0:comment

add-highlighter shared/roff/code/ regex '\\f[A-Z]' 0:attribute
# add-highlighter shared/roff/code/ regex '\\fB(.+?)\\f[A-Z]' 1:+b
# add-highlighter shared/roff/code/ regex '\\fI(.+?)\\f[A-Z]' 1:+i

add-highlighter shared/roff/code/ regex '^\.[a-zA-Z]{1,2}\b' 0:meta
add-highlighter shared/roff/code/ regex '^\.\.$' 0:meta

# select until \n\. bug when there is a comment
# add-highlighter shared/roff/code/ regex '^\.TL(.*?\n)*?(.*?)(?=\n\.)' 0:title
# add-highlighter shared/roff/code/ regex '^\.[NS]H(.*?\n)*?(.*?)(?=\n\.)' 0:header

# add-highlighter shared/roff/code/ regex '^\.IR\s+(\S+)' 1:+i
# add-highlighter shared/roff/code/ regex '^\.BR\s+(\S+)' 1:+b
# add-highlighter shared/roff/code/ regex '^\.I\s+([^\n]+)' 1:+i
# add-highlighter shared/roff/code/ regex '^\.B\s+([^\n]+)' 1:+b

define-command -hidden roff-insert-on-new-line %(
    evaluate-commands -no-hooks -draft -itersel %(
        evaluate-commands %(
            # EQ EN
            # try %(
            #     # check if previous line start with "\.EQ"
            #     execute-keys -draft k<a-x><a-k>^\.EQ[\s\t\n]<ret>
            #     # auto insert "\.EN"
            #     execute-keys -draft o.EN<esc>
            # )
            try %(
                # check if previous line start with "\.?[eE][qQ][\s\t\n]"
                execute-keys -draft k<a-x><a-k>^\.?[eE][qQ][\s\t\n]<ret>
                # change "\.?[eE][qQ][\s\t\n]" to "\.EQ"
                execute-keys -draft kEc.EQ<esc>
            )
            try %(
                # check if previous line start with "\.?[eE][nN][\s\t\n]"
                execute-keys -draft k<a-x><a-k>^\.?[eE][nN][\s\t\n]<ret>
                # change "\.?[eE][nN][\s\t\n]" to "\.EN"
                execute-keys -draft kEc.EN<esc>
            )
            try %(
                # check if previous line start with "\.?[eE]?[qQ][eE]?[nN][\s\t\n]"
                execute-keys -draft k<a-x><a-k>^\.?[eE]?[qQ][eE]?[nN][\s\t\n]<ret>
                # remove "\.?[eE]?[qQ][eE]?[nN][\s\t\n]" and insert "\.EQ ...\n\.EN"
                execute-keys -draft kEc.EQ<esc>jo.EN<esc>
            )
            try %(
                # check if previous line start with "\.?[eE]?[nN][eE]?[qQ][\s\t\n]"
                execute-keys -draft k<a-x><a-k>^\.?[eE]?[nN][eE]?[qQ][\s\t\n]<ret>
                # remove "\.?[eE]?[nN][eE]?[qQ][\s\t\n]" and insert "\.EN\n\.EQ ..."
                execute-keys -draft kEc.EN<ret>.EQ<esc>
            )
            # RS RE
            try %(
                # check if previous line start with "\.?[rR][sS][\s\t\n]"
                execute-keys -draft k<a-x><a-k>^\.?[rR][sS][\s\t\n]<ret>
                # change "\.?[rR][sS][\s\t\n]" to "\.RS"
                execute-keys -draft kEc.RS<esc>
            )
            try %(
                # check if previous line start with "\.?[rR][eE][\s\t\n]"
                execute-keys -draft k<a-x><a-k>^\.?[rR][eE][\s\t\n]<ret>
                # change "\.?[rR][eE][\s\t\n]" to "\.RE"
                execute-keys -draft kEc.RE<esc>
            )
            try %(
                # check if previous line start with "\.?[rR]?[sS][rR]?[eE][\s\t\n]"
                execute-keys -draft k<a-x><a-k>^\.?[rR]?[sS][rR]?[eE][\s\t\n]<ret>
                # remove "\.?[rR]?[sS][rR]?[eE][\s\t\n]" and insert "\.RS ...\n\.RE"
                execute-keys -draft kEc.RS<esc>jo.RE<esc>
            )
            try %(
                # check if previous line start with "\.?[rR]?[eE][rR]?[sS][\s\t\n]"
                execute-keys -draft k<a-x><a-k>^\.?[rR]?[eE][rR]?[sS][\s\t\n]<ret>
                # remove "\.?[rR]?[eE][rR]?[sS][\s\t\n]" and insert "\.RE\n\.RS ..."
                execute-keys -draft kEc.RE<ret>.RS<esc>
            )
        )
    )
)

§
