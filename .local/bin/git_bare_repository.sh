#!/bin/sh

# first clone this repository normally in order to have scripts
# then run this script which will clone again this repository but bare

# set dotfiles folder name
git_dir="$HOME/.dotfiles"

email="lorenzo.bianco22@protonmail.com"

# when changing user name change
# HOME/.config/mpv/mvp.conf (screenshot)
# HOME/.config/mpv/script-opts/mpv_crop_script.conf (crop screenshot)
# HOME/.rtorrent.rc

# clone repository
git clone --bare https://github.com/lbia/dotfiles.git "$git_dir"

# create temporary alias
config () {
   /usr/bin/git --git-dir="$git_dir"/ --work-tree="$HOME" "$@"
}

# remove files if present
rm -f "${HOME}/.bash_profile"
rm -f "${HOME}/.bashrc"
rm -f "${HOME}/.inputrc"

# checkout and copy files in the appropiate places
config checkout

# set to not show untracked files
config config status.showUntrackedFiles no

# add runtime dir
# mkdir "${HOME}"/.local/runtime
# chmod 700 "${HOME}"/.local/runtime
runtime_dir="/run/user/$(id -u)"
doas mkdir -p "$runtime_dir"
doas chown "$USER:$USER" "$runtime_dir"
doas chmod 700 "$runtime_dir"

# make gnupg directory secure
chmod 700 .config/gnupg

# directories
mkdir -p "$HOME/.local"
mkdir -p "$HOME/.local/share"
mkdir -p "$HOME/.local/lib"

mkdir -p "$HOME/.local/share/bash"
mkdir -p "$HOME/.local/share/kak"
mkdir -p "$HOME/.local/share/nvim"

mkdir -p "$HOME/.local/lib/zig"

link-config-root

# crontab
crontab "${XDG_CONFIG_HOME:-$HOME/.config}/crontab/file"

# R
# make sure directories are created otherwise there may be problems
mkdir -p "$HOME/.local/share/R"
mkdir -p "$HOME/.local/lib/R"

# rustup cargo env
export RUSTUP_HOME="/usr/local/lib/rustup"
export CARGO_HOME="/usr/local/lib/cargo"

# go path
export GOPATH="/usr/local/lib/go"

# add npm go and cargo to path in order to install packages in the right places
export PATH="/usr/local/lib/npm/bin:${GOPATH}/bin:${CARGO_HOME}/bin:${PATH}"

# set bitwarden mail for normal user
rbw config set email "$email"
# set bitwarden mail for root user
doas rbw config set email "$email"

# set rbw api key user
rbw register

rbw unlock

# set to track upstram
config push --set-upstream origin main

# remove README from HOME and set git to not track in locale
rm -f "$HOME/README.md"
config update-index --assume-unchanged "$HOME/README.md"

# local rust
export RUSTUP_HOME="${XDG_LIB_HOME:-$HOME/.local/lib}/rustup"
export CARGO_HOME="${XDG_LIB_HOME:-$HOME/.local/lib}/cargo"
rustup-init

# firefox
doas mkdir -p /usr/lib/firefox/distribution
doas ln -s "$HOME/.config/firefox/policies.json" /usr/lib/firefox/distribution/
# when creating profile remember to
# userChrome.css > [profile]/chrome/
# firefox-update-search-engines

# clone packer for neovim
# git clone --depth 1 https://github.com/wbthomason/packer.nvim "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"

# firefox
# ln -s "$HOME/.config/firefox/user-overrides.js" "$HOME/.mozilla/firefox/{profile}/"

# wireguard
# cp {...}.conf /etc/wireguard/
# rm /etc/sv/wireguard/down
# reboot

# octave packages
# pkg install -forge io
# pkg install -forge statistics
# pkg install -forge struct
# pkg install -forge optim

# rtorrent
# cat /usr/share/examples/rtorrent/rtorrent.rc \
#     | sed -re "s:/home/USERNAME:$HOME:" > "$HOME/.rtorrent.rc"
# curl -Ls "https://raw.githubusercontent.com/wiki/rakshasa/rtorrent/CONFIG-Template.md" \
#     | sed -ne "/^######/,/^### END/p" \
#     | sed -re "s:/home/USERNAME:$HOME:" > "$HOME/.rtorrent.rc"
# mkdir -p "$HOME/rtorrent/"

# surfraw
# doas cp surfraw-bash-completion.IN /usr/share/bash-completion/completions/surfraw

# moonscript
doas luarocks install moonscript

# pip
doas pip install xmpppy

# pip local
pip install pywayland

# npm
doas npm install --global web-ext
doas npm install --global lerna

### languge servers

# check for outdated, incorrect, and unused dependencies
doas npm install -g npm-check

# to update npm
# doas npm -g update
# to list packages
# doas npm -g ls

## bash
doas npm install -g bash-language-server

## c/cpp
# packages: clangclang clang-analyzer clang-tools-extra

## rust
doas rustup component add rls rust-analysis rust-src

## zig
# built from source in build-packages zls
# zls_dir="$HOME/dev/zig/zls"
# mkdir -p "$zls_dir"
# zls_location=$(curl -s https://api.github.com/repos/zigtools/zls/releases/latest | grep browser_download_url | grep x86_64-linux.tar.xz | awk '{ print $2 }' | sed 's/,$//' | sed 's/"//g')
# curl -L "$zls_location" | tar -x --strip-components=1 -C "$zls_dir"
# doas ln -s "$zls_dir/zls" /usr/local/bin/

## go
doas go install golang.org/x/tools/gopls@latest

## lua
# built from source in build-packages lua-language-server

## python
# package: python3-language-server

## R
# to update: update.packages()
rinstall=$(cat << EOF
# set CRAN mirror
local({
  r <- getOption("repos")
  r["CRAN"] <- "https://cloud.r-project.org/"
  options(repos = r)
})

# install packages
install.packages("languageserver")
EOF
)
Rscript -e "$rinstall"

## html css json
doas npm install -g vscode-html-languageserver-bin
doas npm install -g vscode-css-languageserver-bin
doas npm install -g vscode-json-languageserver-bin

## javascript typescript
doas npm install -g typescript
doas npm install -g typescript-language-server
# doas npm install -g javascript-typescript-langserver

## building

# clone plugins
update-extra plugins

# clone, build and install packages
build-packages zls
build-packages lua-language-server
build-packages htop
build-packages river
build-packages waybar
build-packages fuzzel
build-packages foot
build-packages libinput-gestures
build-packages mozlz4
