#
# /etc/bash.bashrc
#

# if not running interactively, don't do anything
[[ $- != *i* ]] && return

### sourcing

shell_dir="$HOME/.config/shell"

# source aliases
alias_dir="$shell_dir/aliasrc"
[ -f "$alias_dir" ] && . "$alias_dir"

# source functions
function_dir="$shell_dir/functionrc"
[ -f "$function_dir" ] && . "$function_dir"

# source completions
completion_dir="$shell_dir/completionrc"
[ -f "$completion_dir" ] && . "$completion_dir"

# source fzf completions bindings and settings
fzf_dir="$shell_dir/fzfrc"
[ -f "$fzf_dir" ] && . "$fzf_dir"

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

### gnupg
GPG_TTY="$(tty)"
export GPG_TTY

# root privileges
# so root user can link and use this bashrc
# black: 30 red: 31 green: 32 yellow: 33 blue: 34 purple: 35 cyan: 36 white: 37
if [ "$LOGNAME" = "root" ] || [ "$(id -u)" -eq 0 ]; then
    dir_color=31

    # PS1="\[\e[1;31m\]\w\[\e[m\]\[\e[1;34m\]#\[\e[m\] "
    # PS1="\[\e[1;31m\]\w\[\e[m\] \[\e[1;32m\]>\[\e[m\]\[\e[1;33m\]>\[\e[m\]\[\e[1;36m\]>\[\e[m\] "
    # PS1='\[\e[1;31m\][\u@\h \W]\$\[\e[m\] '

    # PS2=""
else
    dir_color=32

    # PS1="\[\e[1;32m\]\w\[\e[m\]\[\e[1;34m\]$\[\e[m\] "
    # PS1="\[\e[1;32m\]\w\[\e[m\] \[\e[1;31m\]>\[\e[m\]\[\e[1;33m\]>\[\e[m\]\[\e[1;36m\]>\[\e[m\] "
    # PS1='\[\e[1;32m\][\u@\h \W]\$\[\e[m\] '

    # PS2=""
fi
# add host to PS1 just when using SSH
host_color=34
if [ -n "$SSH_TTY" ]; then
    host_ps1="\[\e[1;${host_color}m\]\h\[\e[m\]@"
fi
PS1="${host_ps1}\[\e[1;${dir_color}m\]\w\[\e[m\] "

### initalize zoxide

eval "$(zoxide init bash)"
# eval "$(zoxide init --cmd y bash)"
