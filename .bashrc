#
# /etc/bash.bashrc
#

# if not running interactively, don't do anything
[[ $- != *i* ]] && return

### sourcing

# source functions
# it is also sourced by zsh
[ -f "$HOME/.config/shell/functionrc" ] && . "$HOME/.config/shell/functionrc"

# source aliases and some small functions which work like aliases
# it is also sourced by zsh
[ -f "$HOME/.config/shell/aliasrc" ] && . "$HOME/.config/shell/aliasrc"

# source fzf completion and key-bindings
# export FZF_COMPLETION_TRIGGER='**'
[ -f "/usr/share/fzf/completion.bash" ] && . "/usr/share/fzf/completion.bash"
[ -f "/usr/share/fzf/key-bindings.bash" ] && . "/usr/share/fzf/key-bindings.bash"

# use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - the first argument to the function ($1) is the base path to start traversal
# - see the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" --color=always . "$1"
}

# use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type directory --hidden --follow --exclude ".git" --color=always . "$1"
}

# remap fzf <a-c> to <c-f>
bind -m emacs-standard '"\ec":'
bind -m vi-command '"\ec":'
bind -m vi-insert '"\ec":'
bind -m emacs-standard -x '"\C-f": __fzf_cd__'
bind -m vi-command -x '"\C-f": __fzf_cd__'
bind -m vi-insert -x '"\C-f": __fzf_cd__'

### <https://wiki.bash-hackers.org/internals/shell_options>

# prepend cd to directory names automatically
shopt -s autocd
# correct spelling errors in arguments supplied to cd
shopt -s cdspell
# check the window size after each command
shopt -s checkwinsize
# save multi-line commands as one command
shopt -s cmdhist
# variable expansion on tab complete
shopt -s direxpand
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

### bash history

# export HISTTIMEFORMAT='%f %t '
export HISTSIZE=
export HISTFILESIZE=
export HISTCONTROL="erasedups:ignoreboth"
export HISTIGNORE="pwd:exit:clear"
# export HISTIGNORE="cd:pwd:exit:q:c:e:ea:et::fe:clear:nnn:n3:xb*():curl"
# export HISTFILE="$HOME"/.cache/bash/bash_history

## sync command history across sessions

# this is faster since only new lines are read from the history file
# export PROMPT_COMMAND="${PROMPT_COMMAND}${PROMPT_COMMAND:+;}history -a;history -n"

# append to hist file, clear local hist then read hist file and add to local hist
# export PROMPT_COMMAND="history -a;history -c;history -r;$PROMPT_COMMAND"

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

# complete -o bashdefault -o default -o nospace -F __git_wrap__git_main gst
# complete -o bashdefault -o default -o nospace -F __git_wrap__git_main gad
# complete -o bashdefault -o default -o nospace -F __git_wrap__git_main gbr
# complete -o bashdefault -o default -o nospace -F __git_wrap__git_main gcm
# complete -o bashdefault -o default -o nospace -F __git_wrap__git_main gdf
# complete -o bashdefault -o default -o nospace -F __git_wrap__git_main gfe
# complete -o bashdefault -o default -o nospace -F __git_wrap__git_main glg
# complete -o bashdefault -o default -o nospace -F __git_wrap__git_main gco
# complete -o bashdefault -o default -o nospace -F __git_wrap__git_main gps
# complete -o bashdefault -o default -o nospace -F __git_wrap__git_main grb
# complete -o bashdefault -o default -o nospace -F __git_wrap__git_main gsa
# complete -o bashdefault -o default -o nospace -F __git_wrap__git_main gpl

complete -o bashdefault -o default -o nospace -F __git_wrap__git_main ucon
complete -o bashdefault -o default -o nospace -F __git_wrap__git_main rcon

# complete -o bashdefault -o default -o nospace -F __git_wrap__git_main ucs
# complete -o bashdefault -o default -o nospace -F __git_wrap__git_main uca
# complete -o bashdefault -o default -o nospace -F __git_wrap__git_main ucm
# complete -o bashdefault -o default -o nospace -F __git_wrap__git_main ucp
# complete -o bashdefault -o default -o nospace -F __git_wrap__git_main rcs
# complete -o bashdefault -o default -o nospace -F __git_wrap__git_main rca
# complete -o bashdefault -o default -o nospace -F __git_wrap__git_main rcm
# complete -o bashdefault -o default -o nospace -F __git_wrap__git_main rcp

# autocomplete xbps
complete -F _complete_alias xi
complete -F _complete_alias xr
complete -F _complete_alias xq

# fzf complete for kak
_fzf_setup_completion path kak
_fzf_setup_completion path ka

# root privileges
# so the root can link and use this bashrc
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

    # fzf complete for kak as root
    _fzf_setup_completion path dka
fi

### initalize zoxide

eval "$(zoxide init bash)"
# eval "$(zoxide init --cmd y bash)"
