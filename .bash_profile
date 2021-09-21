#
# ~/.bash_profile
#

[[ -f ${HOME}/.bashrc ]] && . ${HOME}/.bashrc

# USER ENVIROMENT VARIABLES

#export XDG_DOCUMENTS_DIR="${HOME}/documents"
#export XDG_DOWNLOAD_DIR="${HOME}/downloads"
export XDG_CONFIG_HOME="${HOME}/.config"
#export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export XDG_RUNTIME_DIR="${HOME}/.local/runtime"
export GTK2_RC_FILES="${XDG_CONFIG_HOME}/gtk-2.0/config"
export C_INCLUDE_PATH="${HOME}/.local/include"
export LD_LIBRARY_PATH="${HOME}/.local/lib"
export PKG_CONFIG_PATH="${HOME}/.local/lib/pkgconfig"
export PATH="${PATH}:${HOME}/.local/bin"

export BROWSER=firefox
#export BROWSER="${HOME}/.local/bin/ungoogled_chromium.sh"

if [ -z "${WAYLAND_DISPLAY}" ] && [ "$(tty)" = "/dev/tty1" ]; then
	exec river
fi
