# gitignore

## detection

hook global BufCreate .*\.gitignore %{
    set-option buffer filetype gitignore
}

## initialization

hook global WinSetOption filetype=gitignore %{
    require-module gitignore

    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window gitignore-.+ }
}

hook -group gitignore-highlight global WinSetOption filetype=gitignore %{
    add-highlighter window/gitignore ref gitignore
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/gitignore }
}

hook global BufSetOption filetype=gitignore %{
    set-option buffer comment_line '#'
}

provide-module gitignore {

## highlighters

add-highlighter shared/gitignore regions
add-highlighter shared/gitignore/comment region '#' '$' fill comment

}
