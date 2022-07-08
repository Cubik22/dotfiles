#!/bin/sh

ytdl="${YTDL:-yt-dlp}"

if [ "$#" -lt 1 ]; then
    echo "error: please insert at least one url"
    exit
fi

for url in "$@"; do
    # name="$(youtube-dl --get-filename "$url" \
    #     | rev | cut -d "." -f 2- | rev)"
    # ext="$(youtube-dl --get-filename "$url" \
    #     | rev | cut -d "." -f 1 | rev)"
    # full="${name}.${ext}"
    # $ytdl \
    #     --ignore-errors \
    #     --retries=infinite \
    #     --extract-audio \
    #     --add-metadata \
    #     --xattrs \
    #     "$url" \
    #     -o "$full"
    # ffmpeg -i "$full" "${name}.opus"

    dir="$(mktemp -d audio-XXXXXX)"
    cd "$dir" || return 1

    $ytdl \
        --ignore-errors \
        --retries=infinite \
        --extract-audio \
        --add-metadata \
        --xattrs \
        "$url"

    name="$(echo *)"
    name_ext="$(echo "$name" | rev | cut -d "." -f 1 | rev)"
    name_no_ext="$(echo "$name" | rev | cut -d "." -f 2- | rev)"
    name_opus="${name_no_ext}.opus"

    if [ ! "$name_ext" = "opus" ]; then
        ffmpeg -loglevel quiet -i "$name" "$name_opus"
    fi

    mv "$name_opus" ../
    cd .. || return 1
    rm -r "$dir"
done
