#!/bin/sh

status=$(doas sv status iwd | awk -F ":" '{print $1}')

if [ $status = "run" ]; then
    doas sv down iwd
elif [ $status = "down" ]; then
    doas sv up iwd
else
    echo "ERROR: iwd status is $status"
fi
