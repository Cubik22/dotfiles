#!/bin/sh

git clone https://github.com/ifreund/river "$HOME"

cd "$HOME"/river

git submodule update --init

# -Dxwayland for xwayland support
zig build -Drelease-safe -Dman-pages --prefix "$HOME"/.local install

git clone https://github.com/Alexays/Waybar

cd "$HOME"/Waybar

meson build

ninja -C build install
