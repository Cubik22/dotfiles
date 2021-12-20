#
# ~/.bash_profile
#

envrc="${HOME}/.config/shell/envrc"
[ -f "$envrc" ] && . "$envrc"

bashrc="${HOME}/.bashrc"
[ -f "$bashrc" ] && . "$bashrc"
