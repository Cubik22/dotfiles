#
# ~/.bash_profile
#

info_path="$HOME/.local/etc/info"

OPERATING_SYSTEM="$(cat "$info_path/operating-system")"
export OPERATING_SYSTEM

OS_TYPE="$(cat "$info_path/os-type")"
export OS_TYPE

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
