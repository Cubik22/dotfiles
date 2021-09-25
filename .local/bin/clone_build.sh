#!/bin/sh

if [ "$#" -ne 1 ]; then
	echo "illegal number of parameters: $#"
	echo "possible parameters: install update"
elif [ ! "$1" = "install" ] && [ ! "$1" = "update" ]; then
	echo "wrong parameter"	
	echo "possible parameters: install update"
else
	prefix_dir="$HOME/.local"
	
	dev="$HOME/dev"

	mkdir -p $dev

	if [ "$1" = "install" ]; then
		git clone https://github.com/ifreund/river "$dev"/river
	fi
	
	cd "$dev"/river
	
	if [ "$1" = "install" ]; then
		git submodule init
	fi

	git submodule update
	
	# -Dxwayland for xwayland support
	zig build -Drelease-safe -Dman-pages -Dxwayland --prefix $prefix_dir install
	
	if [ "$1" = "install" ]; then
		git clone https://github.com/Alexays/Waybar "$dev"/waybar
	fi

	cd "$dev"/waybar
	
	# build options enabled/disabled
	meson -Dprefix=$prefix_dir -Dlibnl=enabled -Dlibudev=enabled -Dlibevdev=enabled -Dpulseaudio=enabled -Dsystemd=disabled -Ddbusmenu-gtk=disabled -Dman-pages=enabled -Dmpd=disabled -Dgtk-layer-shell=disabled -Drfkill=enabled -Dsndio=disabled -Dtests=disabled build
	
	ninja -C build install
	
	cd "$dev"
fi
