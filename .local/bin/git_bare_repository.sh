#!/bin/sh

# first clone this repository normally in order to have scripts
# then run this script which will clone again this repository but bare

# set dotfiles folder name
folder="$HOME"/.dotfiles

email="lorenzo.bianco22@protonmail.com"

# clone repository
git clone --bare https://github.com/Cubik22/dotfiles.git "$folder"

# create temporary alias
config () {
   /usr/bin/git --git-dir="$folder"/ --work-tree="$HOME" "$@"
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

# import gpg key
echo "------------------------ type the number of your identity -------------------------"
gpg --search-keys $email

# trust key
echo "-------------------- type 'trust', '5', 'y', 'primary', 'save' --------------------"
gpg --edit-key $email

# cargo packages already installed globally
#cargo install rbw

# already set in config folder
#rbw config set email $email

# add local and cargo directories to path in order to run rbw, rbw-agent and git-credential-bitwarden
#PATH="$PATH:$HOME/.local/bin:$HOME/.cargo/bin"

rbw unlock

# set to track upstram 
config push --set-upstream origin main

# remove README from HOME and set git to not track in locale
rm -f "$HOME"/README.md
/usr/bin/git --git-dir="$HOME"/.dotfiles/ --work-tree="$HOME" update-index --assume-unchanged "$HOME"/README.md

# set git to remeber credentials (danger but with github token you can give small permission)
#git config --global credential.helper store

# symlink stuff to root
doas rm -f /root/.bashrc
doas rm -f /root/.inputrc
doas rm -f /root/.dir_colors
doas rm -f /root/.config/nvim/init.vim

doas ln -s "$HOME"/.bashrc /root/.bashrc
doas ln -s "$HOME"/.inputrc /root/.inputrc
doas ln -s "$HOME"/.dir_colors /root/.dir_colors

doas mkdir -p "/root/.config/nvim"
doas ln -s "$HOME"/.config/nvim/init.vim /root/.config/nvim/init.vim

# clone, build and install river and waybar
clone_build install
