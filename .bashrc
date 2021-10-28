#
# /etc/bash.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# use vim/kak mode
# PS0="\e[2 q\2"
set -o vi
# typing <alt>+letter send <esc>+letter
# <alt>+o normal mode before cursor
# <alt>+l normal mode after cursor
# <alt>+b normal mode beginning of line
# <alt>+e normal mode end of line

# bind control l
bind -x '"\C-l":"clear -x"'

# source aliases and some functions which work like aliases
# it is also sourced by zsh
[ -f "$HOME/.config/shell/aliasrc" ] && source "$HOME/.config/shell/aliasrc"

# source fzf completion and key-bindings
# export FZF_COMPLETION_TRIGGER='**'
[ -f "/usr/share/doc/fzf/completion.bash" ] && source "/usr/share/doc/fzf/completion.bash"
[ -f "/usr/share/doc/fzf/key-bindings.bash" ] && source "/usr/share/doc/fzf/key-bindings.bash"

## <https://wiki.bash-hackers.org/internals/shell_options>

# variable expansion on tab complete
shopt -s direxpand
# prepend cd to directory names automatically
shopt -s autocd 2>/dev/null
# correct spelling errors in arguments supplied to cd
shopt -s cdspell 2>/dev/null
# check the window size after each command
shopt -s checkwinsize
# save multi-line commands as one command
shopt -s cmdhist
# correct spelling errors during tab-completion
shopt -s dirspell 2>/dev/null
# turn on recursive globbing
shopt -s globstar 2>/dev/null
# append to the history file, don't overwrite it
shopt -s histappend
# case-insensitive globbing
shopt -s nocaseglob
# expand aliases
# shopt -s expand_aliases

bind 'tab:menu-complete'

## bash history

# export HISTTIMEFORMAT='%f %t '
export HISTSIZE=
export HISTFILESIZE=
export HISTCONTROL="erasedups:ignoreboth"
export HISTIGNORE="pwd:exit:clear"
# export HISTIGNORE="cd:pwd:exit:q:c:e:ea:et::fe:clear:nnn:n3:xb*():curl"
# export HISTFILE="$HOME"/.cache/bash/bash_history

# root privileges
# so the root can link and use this bashrc
# black: 30 red: 31 green: 32 yellow: 33 blue: 34 purple: 35 cyan: 36 white: 37
if [ "$LOGNAME" = "root" ] || [ "$(id -u)" -eq 0 ]; then
	PS1="\[\e[1;31m\]\w\[\e[m\] "
	#PS1="\[\e[1;31m\]\w\[\e[m\]\[\e[1;34m\]#\[\e[m\] "
	#PS1="\[\e[1;31m\]\w\[\e[m\] \[\e[1;32m\]>\[\e[m\]\[\e[1;33m\]>\[\e[m\]\[\e[1;36m\]>\[\e[m\] "
	#PS1='\[\e[1;31m\][\u@\h \W]\$\[\e[m\] '
	
	# add autocompletions alias for xbps
	complete -F _complete_alias xi
	complete -F _complete_alias xr
else
	PS1="\[\e[1;32m\]\w\[\e[m\] "
	#PS1="\[\e[1;32m\]\w\[\e[m\]\[\e[1;34m\]$\[\e[m\] "
	#PS1="\[\e[1;32m\]\w\[\e[m\] \[\e[1;31m\]>\[\e[m\]\[\e[1;33m\]>\[\e[m\]\[\e[1;36m\]>\[\e[m\] "
	#PS1='\[\e[1;32m\][\u@\h \W]\$\[\e[m\] '
	
	# add autocompletions alias for xbps
	complete -F _complete_alias xi
	complete -F _complete_alias xr
fi

#alias config='/usr/bin/git --git-dir="$HOME"/.dotfiles/ --work-tree="$HOME"'

# autocomplete alias config (git bare repository)
# remember to sometimes check https://github.com/cykerway/complete-alias
#complete -F _complete_alias config

# in order to find how a command is completed run
#complete -p cmd

# autocomplete doas as sudo
# has to be loaded here or sourced in bash_completion.sh
_completion_loader sudo
complete -F _sudo doas
complete -F _sudo d

# autocomplete xbps
complete -F _complete_alias xi
complete -F _complete_alias xr
complete -F _complete_alias xq

# autocomplete config as git
# has to be loaded here has to be sourced in bash_completion.sh
_completion_loader git
complete -o bashdefault -o default -o nospace -F __git_wrap__git_main ucon
complete -o bashdefault -o default -o nospace -F __git_wrap__git_main rcon

# fzf complete for kak
_fzf_setup_completion path kak
_fzf_setup_completion path ka

# initalize zoxide
eval "$(zoxide init bash)"
#eval "$(zoxide init --cmd y bash)"
