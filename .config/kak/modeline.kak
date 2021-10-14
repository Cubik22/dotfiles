# Git branch
# REF: https://github.com/mawww/kakoune/wiki/Status-Line#git-branch-integration
declare-option -docstring "name of the git branch holding the current buffer" \
	str modeline_git_branch

hook global WinCreate .* %{
	hook window NormalIdle .* %{ evaluate-commands %sh{
		branch=$(cd "$(dirname "${kak_buffile}")" && git rev-parse --abbrev-ref HEAD 2>/dev/null)
		if [ -n "${branch}" ]
		then
			 printf 'set window modeline_git_branch %%{%s}' "${branch}"
		fi
	} }
}

hook global WinCreate .* %{ evaluate-commands %sh{
	is_work_tree=$(cd "$(dirname "${kak_buffile}")" && git rev-parse --is-inside-work-tree 2>/dev/null)
	if [ "${is_work_tree}" = 'true' ]
	then
		printf 'set-option window modelinefmt %%{%s}' "[%opt{modeline_git_branch}]${kak_opt_modelinefmt}"
	fi
}}

# Modeline
#set global modelinefmt '%val{bufname} (%val{cursor_line}:%val{cursor_char_column}) - {{context_info}}[{{mode_info}}/%val{client}@%val{session}]'

#set global modelinefmt '%val{bufname} [%val{cursor_line}:%val{cursor_char_column}]{{context_info}}[{{mode_info}}][%val{client}][%val{session}]'
set global modelinefmt '%val{bufname} {{context_info}}[{{mode_info}}][%val{cursor_line}:%val{cursor_char_column}]'
