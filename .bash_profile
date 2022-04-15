#
# ~/.bash_profile
#

KERNEL="$(uname -s)"
export KERNEL

if [ ! "$KERNEL" = "Linux" ]; then
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
