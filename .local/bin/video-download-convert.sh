#!/bin/sh

if [ "$#" -lt 1 ]; then
    echo "error: please insert at least one url"
    exit
fi

for url in "$@"; do
    dir="$(mktemp -d video-XXXXXX)"
    cd "$dir" || return 1

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
    cd .. || return 1
    rm -r "$dir"
done
