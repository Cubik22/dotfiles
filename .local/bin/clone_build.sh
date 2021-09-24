#!/bin/sh

git clone https://github.com/ifreund/river "$HOME"

cd "$HOME"/river

git submodule update --init

# -Dxwayland for xwayland support
zig build -Drelease-safe -Dman-pages --prefix "$HOME"/.local install

git clone https://github.com/Alexays/Waybar

cd "$HOME"/Waybar

# build options enabled/disabled
meson build -Dlibnl=enabled -Dlibevdev=disabled -Dlibudev=enabled -Dpulseaudio=enabled -Dsystemd=disabled -Ddbusmenu-gtk=disabled -Dman-pages=enabled -Dmpd=disabled -Dgtk-layer-shell=disabled -Drfkill=enabled -Dsndio=disabled -Dtests=disabled

ninja -C build install
