#!/bin/sh

git clone https://github.com/ifreund/river "$HOME"

cd "$HOME"/river

git submodule update --init

# -Dxwayland for xwayland support
zig build -Drelease-safe -Dman-pages --prefix "$HOME"/.local install

git clone https://github.com/Alexays/Waybar

cd "$HOME"/Waybar

meson build -Dgtk-layer-shell=enabled -Dlibudev=enabled -Dman-pages=enabled -Dsystemd=disabled -Drfkill=enabled

ninja -C build install
