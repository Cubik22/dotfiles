#!/bin/bash

#
# ~/.bashrc
#

# if not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

### sourcing

shell_dir="$HOME/.config/shell"

# source aliases
alias_dir="$shell_dir/aliasrc"
# shellcheck disable=SC1090
[ -f "$alias_dir" ] && . "$alias_dir"
unset alias_dir

# source functions
function_dir="$shell_dir/functionrc"
# shellcheck disable=SC1090
[ -f "$function_dir" ] && . "$function_dir"
unset function_dir

# source completions
completion_dir="$shell_dir/completionrc"
# shellcheck disable=SC1090
[ -f "$completion_dir" ] && . "$completion_dir"
unset completion_dir

# source fzf completions bindings and settings
fzf_dir="$shell_dir/fzfrc"
# shellcheck disable=SC1090
[ -f "$fzf_dir" ] && . "$fzf_dir"
unset fzf_dir

unset shell_dir

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
# \u username \h computer name \H hostname \w current working dir \W last part of cwd
if [ "$LOGNAME" = "root" ] || [ "$(id -u)" -eq 0 ]; then
    ps1_dir_color=31
    ps1_char="#"

    # PS1="\[\e[1;31m\]\w\[\e[m\]\[\e[1;34m\]#\[\e[m\] "
    # PS1="\[\e[1;31m\]\w\[\e[m\] \[\e[1;32m\]>\[\e[m\]\[\e[1;33m\]>\[\e[m\]\[\e[1;36m\]>\[\e[m\] "
    # PS1='\[\e[1;31m\][\u@\h \W]\$\[\e[m\] '

    # PS2=""
else
    ps1_dir_color=32
    ps1_char="$"

    # PS1="\[\e[1;32m\]\w\[\e[m\]\[\e[1;34m\]$\[\e[m\] "
    # PS1="\[\e[1;32m\]\w\[\e[m\] \[\e[1;31m\]>\[\e[m\]\[\e[1;33m\]>\[\e[m\]\[\e[1;36m\]>\[\e[m\] "
    # PS1='\[\e[1;32m\][\u@\h \W]\$\[\e[m\] '

    # PS2=""
fi
# add username and host to PS1 just when using SSH
ps1_username_color=33
ps1_host_color=34
if [ -n "$SSH_TTY" ]; then
    ps1_host="\[\e[1;${ps1_username_color}m\]\u\[\e[m\]@\[\e[1;${ps1_host_color}m\]\h\[\e[m\]"
fi
PS1="${ps1_host}\[\e[1;${ps1_dir_color}m\]\w\[\e[m\]${ps1_char} "
unset ps1_dir_color
unset ps1_char
unset ps1_username_color
unset ps1_host_color
unset ps1_host

# make less more friendly for non-text input files
if command -v lesspipe >/dev/null 2>&1; then
    eval "$(SHELL=/bin/sh lesspipe)"
fi

### OSC-7 escape sequence for foot

osc7_cwd() {
    local strlen="${#PWD}"
    local encoded=""
    local pos c o
    for (( pos=0; pos<strlen; pos++ )); do
        c="${PWD:$pos:1}"
        case "$c" in
            [-/:_.!\'\(\)~[:alnum:]] )
                o="${c}"
            ;;
            * )
                printf -v o '%%%02X' "'${c}"
            ;;
        esac
        encoded+="${o}"
    done
    # shellcheck disable=SC1003
    printf '\e]7;file://%s%s\e\\' "${HOSTNAME}" "${encoded}"
}
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }osc7_cwd"

### initalize zoxide

if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init bash)"
    # eval "$(zoxide init --cmd y bash)"
fi

# set tab to 4 instead of 8
tabs 4
