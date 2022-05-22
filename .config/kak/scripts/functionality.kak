# functionality

# close and reopen current file
define-command reload-buffer -docstring 'reload buffer' %{
    evaluate-commands %sh{
        file_name="$kak_buffile"
        line="$cursor_line"
        column="$cursor_char_column"

        # see plugin state-save
        if [ -n "$kak_opt_last_state_save_selection" ]; then
            state_file=$(printf "%s" "$kak_buffile" | sed -e 's|_|__|g' -e 's|/|_-|g')
            echo "$kak_opt_last_state_save_selection" > "$kak_opt_state_save_path/$state_file"
        fi

        printf "%s" "
            write $file_name
            delete-buffer $file_name
            edit $file_name $line $column
        "
    }
}

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

# find files
define-command -docstring 'grep find files' find -menu -params 1 -shell-script-candidates %{
    rg --files
} %{
    edit %arg{1}
}

# fzf
define-command -docstring 'open files with fzf' fuzzy-files %{
    try %sh{
        footclient --app-id 'float' -w "${FZF_RG_WIDTH}x${FZF_RG_HEIGHT}" sh -c "kak-fuzzy-files $kak_session $kak_client"
    }
}

# ripgrep
define-command -docstring 'search with ripgrep and fzf' fuzzy-grep %{
    try %sh{
        footclient --app-id 'float' -w "${FZF_RG_WIDTH}x${FZF_RG_HEIGHT}" sh -c "kak-fuzzy-grep $kak_session $kak_client"
    }
}

# nnn
define-command -docstring 'open file with nnn' nnn-open %{
    try %sh{
        footclient --app-id 'float' -w "${FZF_RG_WIDTH}x${FZF_RG_HEIGHT}" sh -c "kak-nnn $kak_session $kak_client"
    }
}
