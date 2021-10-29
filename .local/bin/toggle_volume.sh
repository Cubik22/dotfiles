#!/bin/sh

if [ "$#" -ne 1 ]; then
	echo "please insert one parameter: 'on' 'off' 'toggle' 'load'"
    echo "you inserted $# parameters"
    return 1
fi

mode=$1

if [ "$mode" != "on" ] && [ "$mode" != "off" ] && [ "$mode" != "toggle" ] && [ "$mode" != "load" ]; then
	echo "please pass as a parameter: 'on' 'off' 'toggle' 'load'"
	echo "you passed $*"
	return 1
fi

Status_Path="$XDG_DATA_HOME/state/audio_status"

current_status="$(cat "$Status_Path")"

if [ "$mode" = "on" ] || [ "$mode" = "off" ]; then
	new_status="$mode"
elif [ "$mode" = "load" ]; then
    new_status="$current_status"
elif [ "$mode" = "toggle" ]; then
    if [ "$current_status" = "on" ]; then
		new_status="off"
    elif [ "$current_status" = "off" ]; then
		new_status="on"
    fi
fi

amixer -q -M set Master "$new_status"
echo "$new_status" > "$Status_Path"
