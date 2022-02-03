#!/bin/sh

# white
        # --background=ebdbb2ff --text-color=1d2021ff \
        # --match-color=458588ff \
        # --selection-color=d5c4a1ff --selection-text-color=3c3836ff \

# black
fuzzel  --font="JetBrainsMono Nerd Font Mono:style=Medium:size=14" \
        --dpi-aware=no --prompt="" --terminal=footclient --lines=20 \
        --width=64 --horizontal-pad=32 --vertical-pad=8 --inner-pad=0 \
        --background=1d2021ff --text-color=d5c4a1ff \
        --match-color=cc241dff \
        --selection-color=3c3836ff --selection-text-color=fbf1c7ff \
        --border-width=2 --border-radius=0 --border-color=6e6e6eff $@ <&0
