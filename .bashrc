#
# /etc/bash.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

HISTSIZE=
HISTFILESIZE=

HISTCONTROL=ignoredups

# source aliases and some functions which work like aliases
# it is also sourced by zsh
[ -f "$ZDOTDIR/aliasrc" ] && source "$ZDOTDIR/aliasrc"

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

# move to directory without using cd
shopt -s autocd

# variable expansion on tab complete
shopt -s direxpand

# autocomplete doas as sudo
# has to be loaded here or sourced in bash_completion.sh
_completion_loader sudo
complete -F _sudo doas
complete -F _sudo d

# autocomplete config as git
# has to be loaded here has to be sourced in bash_completion.sh
_completion_loader git
complete -o bashdefault -o default -o nospace -F __git_wrap__git_main config

# initalize zoxide
eval "$(zoxide init bash)"
#eval "$(zoxide init --cmd y bash)"
