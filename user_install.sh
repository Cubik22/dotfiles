#!/bin/sh

# get the current directory
dotfiles=$(pwd)

# remove files if present
rm -f "${HOME}"/.bash_profile
rm -f "${HOME}"/.bashrc
rm -f "${HOME}"/.inputrc

# link .bash_profile .bashrc and .inputrc
ln -s "${dotfiles}"/.bash_profile "${HOME}"/.bash_profile
ln -s "${dotfiles}"/.bashrc "${HOME}"/.bashrc
ln -s "${dotfiles}"/.inputrc "${HOME}"/.inputrc

# create "${HOME}"/.config and "${HOME}"/.local if they don't exist
mkdir -p "${HOME}"/.config
mkdir -p "${HOME}"/.local/bin

# symlink everything in .config
for file in "${dotfiles}"/.config/*; do
	ln -s "${file}" "${HOME}"/.config/
done

# symlink everything in .local/bin
for file in "${dotfiles}"/.local/bin/*; do
	ln -s "${file}" "${HOME}"/.local/bin/
done

# symlink everything in .local/sv
for file in "${dotfiles}"/.local/sv/*; do
	ln -s "${file}" "${HOME}"/.local/sv/
done

