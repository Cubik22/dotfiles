#!/bin/sh

# first clone this repository normally in order to have scripts
# then run this script which will clone again this repository but bare

# set dotfiles folder name
git_dir="$HOME"/.dotfiles

username="lbia"

email="lorenzo.bianco22@protonmail.com"

# when changing user name change
# HOME/.config/mpv/mvp.conf (screenshot)
# HOME/.config/mpv/script-opts/mpv_crop_script.conf (crop screenshot)

# clone repository
git clone --bare https://github.com/"$username"/dotfiles.git "$git_dir"

# create temporary alias
config () {
   /usr/bin/git --git-dir="$git_dir"/ --work-tree="$HOME" "$@"
}

# remove files if present
rm -f "${HOME}"/.bash_profile
rm -f "${HOME}"/.bashrc
rm -f "${HOME}"/.inputrc

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

# directories
mkdir -p "$HOME/.local"
mkdir -p "$HOME/.local/share"
mkdir -p "$HOME/.local/lib"
# kak nvim
mkdir -p "$HOME"/.local/share/kak
mkdir -p "$HOME"/.local/share/nvim
# zig
mkdir -p "$HOME/.local/lib/zig"

# symlink stuff to root
doas rm -f /root/.bash_profile
doas rm -f /root/.bashrc
doas rm -f /root/.inputrc
doas rm -f /root/.dir_colors
doas rm -fr /root/.config/git
# doas rm -fr /root/.config/rbw
doas rm -fr /root/.config/waylock
doas rm -fr /root/.config/shell
doas rm -fr /root/.config/nvim
doas rm -fr /root/.local/share/nvim
doas rm -fr /root/.config/kak
doas rm -fr /root/.config/kak-lsp
doas rm -fr /root/.local/share/kak

doas ln -s "$HOME"/.bash_profile /root/.bash_profile
doas ln -s "$HOME"/.bashrc /root/.bashrc
doas ln -s "$HOME"/.inputrc /root/.inputrc
doas ln -s "$HOME"/.dir_colors /root/.dir_colors

doas mkdir -p "/root/.config"
doas mkdir -p "/root/.config/git"
# doas mkdir -p "/root/.config/rbw"
doas mkdir -p "/root/.config/waylock"

doas mkdir -p "/root/.local/share"

doas ln -s "$HOME"/.config/git/config /root/.config/git/
# doas ln -s "$HOME"/.config/rbw/config.json /root/.config/rbw/
doas ln -s "$HOME"/.config/waylock/waylock.toml /root/.config/waylock/
doas ln -s "$HOME"/.config/shell /root/.config/
doas ln -s "$HOME"/.config/nvim /root/.config/
doas ln -s "$HOME"/.local/share/nvim /root/.local/share/
doas ln -s "$HOME"/.config/kak /root/.config/
doas ln -s "$HOME"/.config/kak-lsp /root/.config/
doas ln -s "$HOME"/.local/share/kak /root/.local/share/

# wob
mkdir -p "$HOME/.local/share/state"
echo "5" > "$HOME/.local/share/state/brightness_level"
echo "off" > "$HOME/.local/share/state/audio_status"

# R
# make sure directories are created otherwise there may be problems
mkdir -p "$HOME/.local/share/R"
mkdir -p "$HOME/.local/lib/R"

# rustup cargo env
RUSTUP_HOME="/usr/local/lib/rustup"
CARGO_HOME="/usr/local/lib/cargo"

# go path
GOPATH="/usr/local/lib/go"

# add npm go and cargo to path in order to install packages in the right places
PATH="/usr/local/lib/npm/bin:${GOPATH}/bin:${CARGO_HOME}/bin:${PATH}"

# cargo packages already installed globally
# --all-features activate all available features
# --locked require Cargo.lock is up to date
# --frozen require Cargo.lock and cache are up to date
# doas cargo install --all-features --locked --frozen
doas cargo install cargo-update rbw

# link rbw rbw-agent for doas
doas ln -s /usr/local/lib/cargo/bin/rbw /usr/local/bin/
doas ln -s /usr/local/lib/cargo/bin/rbw-agent /usr/local/bin/

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
rm -f "$HOME"/README.md
config update-index --assume-unchanged "$HOME"/README.md

# set git to remeber credentials (danger but with github token you can give small permission)
# git config --global credential.helper store

# set rbw api key root
# doas rbw register

# doas rbw unlock

# set also root config to track upstream
# doas /usr/bin/git --git-dir=/root/config/ --work-tree=/ push --set-upstream https://github.com/"$username"/config main

# import gpg key
# echo "------------------------ type the number of your identity -------------------------"
# gpg --search-keys $email

# trust key
# echo "-------------------- type 'trust', '5', 'y', 'primary', 'save' --------------------"
# gpg --edit-key $email

# clone packer for neovim
# git clone --depth 1 https://github.com/wbthomason/packer.nvim "$HOME"/.local/share/nvim/site/pack/packer/start/packer.nvim

# java (for octave)
# doas ln -s /usr/lib/jvm/openjdk11/lib/server/libjvm.so /usr/lib/jvm/openjdk11/lib/
# doas ln -s /usr/lib/jvm/java-1.8-openjdk/jre/lib/amd64/server/libjvm.so /usr/lib/jvm/java-1.8-openjdk/jre/lib

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

# clone, build and install packages
build-packages river
build-packages waybar
