#
# /etc/bash.bashrc
#

# if not running interactively, don't do anything
[[ $- != *i* ]] && return

### sourcing

# source functions
[ -f "$HOME/.config/shell/functionrc" ] && . "$HOME/.config/shell/functionrc"

# source aliases and some small functions which work like aliases
[ -f "$HOME/.config/shell/aliasrc" ] && . "$HOME/.config/shell/aliasrc"

# source fzf completions bindings and settings
[ -f "$HOME/.config/shell/fzfrc" ] && . "$HOME/.config/shell/fzfrc"

### options

# https://wiki.bash-hackers.org/internals/shell_options

# prepend cd to directory names automatically
shopt -s autocd
# correct spelling errors in arguments supplied to cd
# shopt -s cdspell
# check the window size after each command
shopt -s checkwinsize
# save multi-line commands as one command
shopt -s cmdhist
# directories expansion on tab complete
# shopt -s direxpand
# correct spelling errors during tab-completion
shopt -s dirspell
# expand aliases
shopt -s expand_aliases
# turn on recursive globbing
shopt -s globstar
# append to the history file, don't overwrite it
shopt -s histappend
# case-insensitive globbing
shopt -s nocaseglob

### completion

# alias config='/usr/bin/git --git-dir="$HOME"/.dotfiles/ --work-tree="$HOME"'

# autocomplete alias config (git bare repository)
# remember to sometimes check https://github.com/cykerway/complete-alias
# complete -F _complete_alias config

# in order to find how a command is completed run
# complete -p cmd

## autocomplete doas as sudo

# has to be loaded here or in /etc/bash/bashrc.d/bash_completion.sh
_completion_loader sudo

complete -F _sudo doas
complete -F _sudo d

## autocomplete config as git

# has to be loaded here or in /etc/bash/bashrc.d/bash_completion.sh
_completion_loader git

complete -o bashdefault -o default -o nospace -F __git_wrap__git_main ucon
complete -o bashdefault -o default -o nospace -F __git_wrap__git_main rcon

# autocomplete xbps
complete -F _complete_alias xi
complete -F _complete_alias xr
complete -F _complete_alias xq

# root privileges
# so root user can link and use this bashrc
# black: 30 red: 31 green: 32 yellow: 33 blue: 34 purple: 35 cyan: 36 white: 37
if [ "$LOGNAME" = "root" ] || [ "$(id -u)" -eq 0 ]; then
    PS1="\[\e[1;31m\]\w\[\e[m\] "
    # PS1="\[\e[1;31m\]\w\[\e[m\]\[\e[1;34m\]#\[\e[m\] "
    # PS1="\[\e[1;31m\]\w\[\e[m\] \[\e[1;32m\]>\[\e[m\]\[\e[1;33m\]>\[\e[m\]\[\e[1;36m\]>\[\e[m\] "
    # PS1='\[\e[1;31m\][\u@\h \W]\$\[\e[m\] '

    # PS2=""
else
    PS1="\[\e[1;32m\]\w\[\e[m\] "
    # PS1="\[\e[1;32m\]\w\[\e[m\]\[\e[1;34m\]$\[\e[m\] "
    # PS1="\[\e[1;32m\]\w\[\e[m\] \[\e[1;31m\]>\[\e[m\]\[\e[1;33m\]>\[\e[m\]\[\e[1;36m\]>\[\e[m\] "
    # PS1='\[\e[1;32m\][\u@\h \W]\$\[\e[m\] '

    # PS2=""
fi

### initalize zoxide

eval "$(zoxide init bash)"
# eval "$(zoxide init --cmd y bash)"
