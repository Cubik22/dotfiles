#!/bin/sh

fuzzel  -f "JetBrainsMono Nerd Font Mono:style=Medium:size=14" \
        -D no -P "" -T footclient -l 20 \
        -w 64 -x 32 -y 8 -p 0 \
        -b ebdbb2ff -t 1d2021ff -m 458588ff -s d5c4a1ff -S 3c3836ff \
        -B 2 -r 0 -C 6e6e6eff "$@" <&0
