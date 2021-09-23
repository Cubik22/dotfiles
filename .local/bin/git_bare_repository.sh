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

# source bash profile and bashrc
source "$HOME"/.bash_profile
source "$HOME"/.bashrc

# import gpg key
gpg2 --search-keys $email

# trust key
echo "-------------------- type 'trust', '5', 'y', 'primary', 'save' --------------------"
gpg2 --edit-key $email

cargo install rbw

# set to track upstram
config push --set-upstream origin main

# add runtime dir
mkdir "${HOME}"/.local/runtime
chmod 700 "${HOME}"/.local/runtime

# set git to remeber credentials (danger but with github token you can give small permission)
#git config --global credential.helper store
