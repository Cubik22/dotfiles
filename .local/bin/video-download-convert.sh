#!/bin/sh

if [ "$#" -ne 1 ]; then
    echo "error: please insert just one parameter"
    exit
fi

url="$1"

mkdir tmp
cd tmp || return 1

youtube-dl \
--ignore-errors \
--retries=infinite \
--add-metadata \
--xattrs \
"$url"

name="$(echo *)"
name_ext="$(echo "$name" | rev | cut -d "." -f 1 | rev)"
name_no_ext="$(echo "$name" | rev | cut -d "." -f 2- | rev)"
name_ogg="${name_no_ext}.ogg"

if [ ! "$name_ext" = "ogg" ]; then
    ffmpeg -loglevel quiet -i "$name" "$name_ogg"
fi

mv "$name_ogg" ../
cd ..
rm -r tmp
