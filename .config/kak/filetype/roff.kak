## detection

hook global BufCreate .*\.(g?roff|ms|me|mm) %{
    set-option buffer filetype roff
}

## initialization

hook global WinSetOption filetype=roff %{
    require-module roff
}

hook -group roff-highlight global WinSetOption filetype=roff %{
    add-highlighter window/roff ref roff
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/roff }
}

provide-module roff %{

## highlighters

add-highlighter shared/roff group

add-highlighter shared/roff/ regex '(^\.)?\\".*?\n' 0:comment

add-highlighter shared/roff/ regex '\\f[A-Z]' 0:attribute
# add-highlighter shared/roff/ regex '\\fB(.+?)\\f[A-Z]' 1:+b
# add-highlighter shared/roff/ regex '\\fI(.+?)\\f[A-Z]' 1:+i

add-highlighter shared/roff/ regex '^\.[a-zA-Z]{1,2}\b' 0:meta
add-highlighter shared/roff/ regex '^\.\.$' 0:meta
add-highlighter shared/roff/ regex '^\.TH\s+[^\n]+' 0:title
add-highlighter shared/roff/ regex '^\.SH\s+[^\n]+' 0:header
# add-highlighter shared/roff/ regex '^\.IR\s+(\S+)' 1:+i
# add-highlighter shared/roff/ regex '^\.BR\s+(\S+)' 1:+b
# add-highlighter shared/roff/ regex '^\.I\s+([^\n]+)' 1:+i
# add-highlighter shared/roff/ regex '^\.B\s+([^\n]+)' 1:+b

}
