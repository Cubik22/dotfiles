# functionality

# use ripgrep for grepping
set-option global grepcmd 'rg --column'

# use foot as the terminal
set-option global windowing_modules 'wayland'

# source-runtime for just one
define-command source-all-rc -docstring 'source all default settings' %{ evaluate-commands %sh{
    for file in "$(find /usr/share/kak/rc -type f)"; do
        printf "%s" "
            try %{
                source %{$file}
            } catch %{
                echo -debug %val{error}
            }
        "
    done
} }

# fzf
define-command -docstring 'open files with fzf' fuzzy-files %{
    try %sh{
        footclient --app-id 'float' sh -c "kak-fuzzy-files $kak_session $kak_client"
    }
}
map global user f ': fuzzy-files<ret>' -docstring 'fzf: open files'

# nnn
define-command -docstring 'open file with nnn' nnn %{
    try %sh{
        footclient --app-id 'float' sh -c "kak-nnn $kak_session $kak_client"
    }
}
map global user n ': nnn<ret>' -docstring 'nnn: open file'

# ripgrep
define-command -docstring 'search with ripgrep and fzf' fuzzy-grep %{
    try %sh{
        footclient --app-id 'float' -w 1840x1000 sh -c "kak-fuzzy-grep $kak_session $kak_client"
    }
}
map global user r ': fuzzy-grep<ret>' -docstring 'fzf: live grep'
