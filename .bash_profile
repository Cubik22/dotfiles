#
# ~/.bash_profile
#

envrc="${XDG_CONFIG_HOME:-$HOME/.config}/shell/envrc"
[ -f "$envrc" ] && . "$envrc"
unset envrc

bashrc="$HOME/.bashrc"
[ -f "$bashrc" ] && . "$bashrc"
unset bashrc
