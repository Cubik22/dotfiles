#!/bin/bash

#
# ~/.bash_profile
#

# shellcheck disable=SC1090

info_path="$HOME/.local/etc/info"

operating_system_file="$info_path/operating-system"
if [ -f "$operating_system_file" ]; then
    OPERATING_SYSTEM="$(cat "$operating_system_file")"
    export OPERATING_SYSTEM
fi
unset operating_system_file

os_type_file="$info_path/os-type"
if [ -f "$os_type_file" ]; then
    OS_TYPE="$(cat "$os_type_file")"
    export OS_TYPE
fi
unset os_type_file

unset info_path

if [ ! "$OPERATING_SYSTEM" = "void" ]; then
    bashrc_global="/etc/bash/bashrc"
    [ -f "$bashrc_global" ] && . "$bashrc_global"
    unset bashrc_global
fi

envrc="${XDG_CONFIG_HOME:-$HOME/.config}/shell/envrc"
[ -f "$envrc" ] && . "$envrc"
unset envrc

bashrc="$HOME/.bashrc"
[ -f "$bashrc" ] && . "$bashrc"
unset bashrc
