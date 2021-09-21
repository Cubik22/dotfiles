#!/bin/sh

# set dotfiles folder name
folder="$HOME"/.dotfiles

# clone repository
git clone --bare https://github.com/Cubik22/dotfiles.git $folder

# create temporary alias
function config {
   /usr/bin/git --git-dir="$folder"/ --work-tree=$HOME $@
}

# remove files if present
rm -f "${HOME}"/.bash_profile
rm -f "${HOME}"/.bashrc
rm -f "${HOME}"/.inputrc

# checkout and copy files in the appropiate places
config checkout

# set to not show untracked files
config config status.showUntrackedFiles no
