#!/bin/sh

getMaster=$(amixer get Master)

# this does not work always
#IFS="$(printf '\n')"

# this should work always
#IFS='
#'

elements=$(echo "$getMaster" | grep 'Playback channels' | awk -F "Playback channels: " '{print $2}' | awk -F " - " '{for (i=1; i<=NF; i++) {print $i}}')

#string=$(amixer get Master | grep 'Playback channels' | awk -F "Playback channels: " '{print $2}' | awk -F " - " 'BEGIN {printf "("} END {printf ")\n"} {for (i=1; i<=NF; i++) {printf "\""; printf $i; printf "\" "}}')

allsame=false

while read -r i; do
    string="echo \"\$getMaster\" | awk '/^ *"$i"/ {print \$0}' | awk -F '\\\[|]' '{print \$(NF - 1)}'"
    eval "new=\$($string)"
    if [ -n "$old" ]; then
        if [ ! "$new" = "$old" ]; then
            allsame=false
            break
        fi
    else
        allsame=true
    fi
    old="$new"
done <<EOT
$(echo "$elements")
EOT

if [ "$allsame" = "false" ]; then
    echo "ERROR: not every channel is on/off"
else
    if [ "$new" = "on" ]; then
        amixer set Master mute
    elif [ "$new" = "off" ]; then
        amixer set Master unmute
    else
        echo "ERROR: status is $new"
    fi
fi
