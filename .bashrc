#
# /etc/bash.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias d="doas"
alias sudo="doas"
alias ls="ls --color=auto --group-directories-first --format=horizontal --human-readable"
alias lsa="ls --color=auto --group-directories-first --format=horizontal --human-readable -a"
alias lsl="ls --color=auto --group-directories-first --format=horizontal --human-readable -l"
alias lsal="ls --color=auto --group-directories-first --format=horizontal --human-readable -a -l"
alias lsla="ls --color=auto --group-directories-first --format=horizontal --human-readable -l -a"
alias dir="dir --color=auto"
alias vdir="vdir --color=auto"
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"
alias diff="diff --color=auto"
alias ip="ip -color=auto"
alias mkdir="mkdir -pv"
alias cp="cp -r"
alias space="du -sh"
alias n3="nnn"
alias ..="cd .."
alias cd..="cd .."
alias trexa="exa --long --header --modified --git --tree --color --icons --all --group-directories-first"
alias nv="nvim"
alias xq="xbps-query"
#alias gpg="gpg2"
alias iwdscan="iwctl station wlan0 scan"
#alias chromium="ungoogled_chromium.sh"

# git related
alias gst="git status"
alias gad="git add"
alias gbr="git branch"
alias gcm="git commit"
alias gdf="git diff"
alias gfe="git fetch"
alias glg="git log"
alias gco="git checkout"
alias gps="git push"
alias grb="git rebase"
alias gsa="git stash"
alias gpl="git pull"

# root privileges
# so the root can link and use this bashrc
if [ "$LOGNAME" = "root" ] || [ "$(id -u)" -eq 0 ]; then
	PS1="\[\e[1;31m\]\w\[\e[m\] \[\e[1;31m\]>\[\e[m\]\[\e[1;33m\]>\[\e[m\]\[\e[1;36m\]>\[\e[m\] "
	#PS1='\[\e[1;31m\][\u@\h \W]\$\[\e[m\] '
	
	alias xi="xbps-install"
	alias xr="xbps-remove"
	
	# add autocompletions alias for xbps
	complete -F _complete_alias xi
	complete -F _complete_alias xr
else
	PS1="\[\e[1;32m\]\w\[\e[m\] \[\e[1;31m\]>\[\e[m\]\[\e[1;33m\]>\[\e[m\]\[\e[1;36m\]>\[\e[m\] "
	#PS1='\[\e[1;32m\][\u@\h \W]\$\[\e[m\] '
	
	alias dn3="doas nnn"
	alias dnv="doas nvim"
	
	alias xi="doas xbps-install"
	alias xr="doas xbps-remove"
	
	# add autocompletions alias for xbps
	complete -F _complete_alias xi
	complete -F _complete_alias xr
fi

# git bare repository dotfiles
function config {
	# when adding echo to remember to pull before commit
	if [ $1 = "add" ]; then
		echo "remember to pull before commit"
	elif [ $1 = "push" ]; then
		rbw unlock
	fi
	/usr/bin/git --git-dir="$HOME"/.dotfiles/ --work-tree="$HOME" "$@"
	# when pulling remove README from HOME and set git to not track in locale
	if [ $1 = "pull" ]; then
		rm -f "$HOME"/README.md
		/usr/bin/git --git-dir="$HOME"/.dotfiles/ --work-tree="$HOME" update-index --assume-unchanged "$HOME"/README.md
	fi
}

#alias config='/usr/bin/git --git-dir="$HOME"/.dotfiles/ --work-tree="$HOME"'

# autocomplete alias config (git bare repository)
# remember to sometimes check https://github.com/cykerway/complete-alias
#complete -F _complete_alias config

# in order to find how a command is completed run
#complete -p cmd

# move to directory without using cd
#shopt -s autocd

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

# void mirrors in order to quickly change when one si slow (R flag)
mirror1="https://alpha.de.repo.voidlinux.org/current/musl"
mirror2="https://mirrors.servercentral.com/voidlinux/current/musl"
mirror3="https://alpha.us.repo.voidlinux.org/current/musl"

HISTSIZE=
HISTFILESIZE=

HISTCONTROL=ignoredups

# PATHS
