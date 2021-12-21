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

State_Dir="$XDG_DATA_HOME/state"
Status_Path="$State_Dir/audio_status"

if [ ! -e "$Status_Path" ]; then
    mkdir -p "$State_Dir"
    echo "off" > "$Status_Path"
elif [ ! -f "$Status_Path" ]; then
    echo "error: Status_Path is not a file"
    return 1
fi

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
