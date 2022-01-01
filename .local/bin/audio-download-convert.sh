#/bin/sh

if [ "$#" -ne 1 ]; then
    echo "error: please insert just one parameter"
    exit
fi

url="$1"

# name="$(youtube-dl --get-filename "$url" \
# | rev | cut -d "." -f 2- | rev)"
# ext="$(youtube-dl --get-filename "$url" \
# | rev | cut -d "." -f 1 | rev)"
# full="${name}.${ext}"
# youtube-dl \
# --ignore-errors \
# --retries=infinite \
# --extract-audio \
# --add-metadata \
# --xattrs \
# "$url" \
# -o "$full"
# ffmpeg -i "$full" "${name}.opus"

mkdir tmp
cd tmp

youtube-dl \
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
cd ..
rm -r tmp
