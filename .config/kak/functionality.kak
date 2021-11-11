# extra functionality
# ==============================================================================

# use ripgrep for grepping
set-option global grepcmd 'rg --column'

# use foot as the terminal
set-option global windowing_modules 'wayland'

# Fzf
define-command -docstring 'Open files with fzf' fuzzy-files %{
	try %sh{
		footclient --app-id 'float' sh -c "kak-fuzzy-files $kak_session $kak_client"
	}
}
map global user o ': fuzzy-files<ret>' -docstring '[FZF] Open Files'

# Nnn
define-command -docstring 'Open file with nnn' nnn %{
	try %sh{
		footclient --app-id 'float' sh -c "kak-nnn $kak_session $kak_client"
	}
}
map global user n ': nnn<ret>' -docstring '[NNN] Open file'

# Ripgrep
define-command -docstring 'Search with ripgrep and fzf' fuzzy-grep %{
	try %sh{
		footclient --app-id 'float' -w 1840x1000 sh -c "kak-fuzzy-grep $kak_session $kak_client"
	}
}
map global user r ': fuzzy-grep<ret>' -docstring '[FZF] Live grep'
