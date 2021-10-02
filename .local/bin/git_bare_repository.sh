#!/bin/sh

# first clone this repository normally in order to have scripts
# then run this script which will clone again this repository but bare

# set dotfiles folder name
git_dir="$HOME"/.dotfiles

email="lorenzo.bianco22@protonmail.com"

# clone repository
git clone --bare https://github.com/Cubik22/dotfiles.git "$git_dir"

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
mkdir "${HOME}"/.local/runtime
chmod 700 "${HOME}"/.local/runtime

# symlink stuff to root
doas rm -r /root/.bash_profile
doas rm -f /root/.bashrc
doas rm -f /root/.inputrc
doas rm -f /root/.dir_colors
doas rm -fr /root/.config/shell
doas rm -fr /root/.config/nvim
doas rm -fr /root/.config/git
doas rm -fr /root/.config/rbw

doas ln -s "$HOME"/.bash_profile /root/.bash_profile
doas ln -s "$HOME"/.bashrc /root/.bashrc
doas ln -s "$HOME"/.inputrc /root/.inputrc
doas ln -s "$HOME"/.dir_colors /root/.dir_colors

doas mkdir -p "/root/.config/shell"
doas mkdir -p "/root/.config/nvim"
doas mkdir -p "/root/.config/git"
doas mkdir -p "/root/.config/rbw"
doas ln -s "$HOME"/.config/shell/envrc /root/.config/shell/envrc
doas ln -s "$HOME"/.config/shell/aliasrc /root/.config/shell/aliasrc
doas ln -s "$HOME"/.config/nvim/init.vim /root/.config/nvim/init.vim
doas ln -s "$HOME"/.config/git/config /root/.config/git/config
doas ln -s "$HOME"/.config/rbw/config.json /root/.config/rbw/config.json

export CARGO_HOME="/usr/local"

# cargo packages already installed globally
doas cargo install rbw

# already set in config folder
#rbw config set email $email

# add local and cargo directories to path in order to run rbw, rbw-agent and git-credential-bitwarden
PATH="$PATH:$HOME/.local/bin:$HOME/.cargo/bin"

rbw unlock

# set to track upstram 
config push --set-upstream origin main

# set also root config to track upstream
doas /usr/bin/git --git-dir=/root/config/ --work-tree=/ push --set-upstream https://github.com/Cubik22/config main

# remove README from HOME and set git to not track in locale
rm -f "$HOME"/README.md
config update-index --assume-unchanged "$HOME"/README.md

# set git to remeber credentials (danger but with github token you can give small permission)
#git config --global credential.helper store

# import gpg key
echo "------------------------ type the number of your identity -------------------------"
gpg --search-keys $email

# trust key
echo "-------------------- type 'trust', '5', 'y', 'primary', 'save' --------------------"
gpg --edit-key $email

# clone, build and install river and waybar
clone_build install
