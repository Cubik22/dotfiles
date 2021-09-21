#!/bin/sh

# first clone this repository normally in order to have scripts
# then run this script which will clone again this repository but bare

# set dotfiles folder name
folder="$HOME"/.dotfiles

# clone repository
git clone --bare https://github.com/Cubik22/dotfiles.git "$folder"

# create temporary alias
config () {
   /usr/bin/git --git-dir="$folder"/ --work-tree="$HOME" $@
}

# remove files if present
rm -f "${HOME}"/.bash_profile
rm -f "${HOME}"/.bashrc
rm -f "${HOME}"/.inputrc

# checkout and copy files in the appropiate places
config checkout

# set to not show untracked files
config config status.showUntrackedFiles no

# remove scripts from $HOME
rm "$HOME"/git_bare_repository.sh
rm "$HOME"/user_install.sh
