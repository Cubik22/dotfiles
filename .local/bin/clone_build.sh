#!/bin/sh

prefix_dir="$HOME/.local"

git clone https://github.com/ifreund/river "$HOME"/river

cd "$HOME"/river

git submodule update --init

# -Dxwayland for xwayland support
zig build -Drelease-safe -Dman-pages -Dxwayland --prefix $prefix_dir install

git clone https://github.com/Alexays/Waybar "$HOME"/waybar

cd "$HOME"/waybar

# build options enabled/disabled
meson -Dprefix=$prefix_dir -Dlibnl=enabled -Dlibudev=enabled -Dlibevdev=enabled -Dpulseaudio=enabled -Dsystemd=disabled -Ddbusmenu-gtk=disabled -Dman-pages=enabled -Dmpd=disabled -Dgtk-layer-shell=disabled -Drfkill=enabled -Dsndio=disabled -Dtests=disabled build

ninja -C build install

cd "$HOME"
