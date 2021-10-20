#!/bin/sh

if [ "$#" -ne 1 ]; then
    echo "please insert one parameter: 'up' 'down' 'load'"
    echo "you inserted $# parameters"
    exit
fi

mode=$1

if [ "$mode" != "up" ] && [ "$mode" != "down" ] && [ "$mode" != "load" ]; then
   echo "please pass as a parameter: 'up' 'down' 'load'"
   exit
fi

Brightness_Path="/sys/class/backlight/intel_backlight/brightness"

Max_Brightness_Path="/sys/class/backlight/intel_backlight/max_brightness"

Level_Path="$XDG_DATA_HOME/state/brightness_level"

# current_brightness="$(cat $Brightness_Path)"

max_brightness="$(cat $Max_Brightness_Path)"

current_level="$(cat "$Level_Path")"

number_steps=10

step="$(( max_brightness / number_steps ))"

min_brightness="$(( max_brightness - (number_steps - 1) * step ))"

if [ "$mode" = "up" ]; then
	# new_brightness="$(( current_brightness + step ))"
	if [ "$current_level" -lt 10 ]; then
    	new_level="$(( current_level + 1 ))"
	else
    	new_level="$current_level"
	fi
elif [ "$mode" = "down" ]; then
	# new_brightness="$(( current_brightness - step ))"
	if [ "$current_level" -gt 1 ]; then
    	new_level="$(( current_level - 1 ))"
	else
    	new_level="$current_level"
	fi
elif [ "$mode" = "load" ]; then
	# new_brightness="$current_brightness"
    new_level="$current_level"
fi

new_brightness="$(( new_level * step ))"

if [ "$new_brightness" -ge "$(( max_brightness + 1 ))" ]; then
	echo "$max_brightness" > "$Brightness_Path"
elif [ "$new_brightness" -le "$min_brightness" ]; then
	echo "$min_brightness" > "$Brightness_Path"
else
	echo "$new_brightness" > "$Brightness_Path"
fi

echo "$new_level" > "$Level_Path"
echo "$(( new_level * 10 ))"
