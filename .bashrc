#
# /etc/bash.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias config='/usr/bin/git --git-dir="$HOME"/.dotfiles/ --work-tree="$HOME"'
alias sudo="doas"
alias ls='ls --color=auto --group-directories-first --format=horizontal --human-readable'
alias lsa='ls -a --color=auto --group-directories-first --format=horizontal --human-readable'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias ip='ip -color=auto'
alias mkdir='mkdir -pv'
alias space="du -sh"
alias n3="nnn"
alias sn3="doas nnn"
alias ..='cd ..'
alias cd..='cd ..'
alias trexa="exa --long --header --modified --git --tree --color --icons --all --group-directories-first"
alias nv='nvim'
alias snv='doas nvim'
alias wifiscan='iwctl station wlan0 scan'
#alias chromium="ungoogled_chromium.sh"

# void mirrors in order to quickly change when one si slow (R flag)
mirror1="https://alpha.de.repo.voidlinux.org/current/musl"
mirror2="https://mirrors.servercentral.com/voidlinux/current/musl"
mirror3="https://alpha.us.repo.voidlinux.org/current/musl"

# move to directory without using cd
#shopt -s autocd

PS1="\[\e[1;32m\]\w\[\e[m\] \[\e[1;31m\]>\[\e[m\]\[\e[1;33m\]>\[\e[m\]\[\e[1;36m\]>\[\e[m\] "
#PS1='\[\e[1;32m\][\u@\h \W]\$\[\e[m\] '

HISTSIZE=
HISTFILESIZE=

HISTCONTROL=ignoredups

# PATHS
