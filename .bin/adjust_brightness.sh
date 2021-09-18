#!/bin/sh

mode=$1

Brightness_Path="/sys/class/backlight/intel_backlight/brightness"

Max_Brightness_Path="/sys/class/backlight/intel_backlight/max_brightness"

current_brightness=$(cat $Brightness_Path)

max_brightness=$(cat $Max_Brightness_Path)

number_steps=10

step="$(( $max_brightness / $number_steps ))"

minimum="$(( $max_brightness - ($number_steps - 1) * $step ))"

if [ "$mode" = "up" ]; then
	new_brightness="$(( $current_brightness + $step ))"

	if [ $new_brightness -lt "$(( $max_brightness + 1 ))" ]; then
		echo $new_brightness > $Brightness_Path
	else
		echo $max_brightness > $Brightness_Path
	fi
elif [ "$mode" = "down" ]; then
	new_brightness="$(( $current_brightness - $step ))"

	if [ $new_brightness -gt $minimum ]; then
		echo $new_brightness > $Brightness_Path
	else
		echo $minimum > $Brightness_Path
	fi
else
	echo "please pass as a parameter 'up' or 'down'"
fi
