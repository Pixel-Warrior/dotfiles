#!/usr/bin/env bash

# Usage:
# First argument: Subtitle file path
# Second argument: Subtitle styles to strip|stay
# Third argument: Enter -v if you want to strip style
# Example: subtitles_stripper.sh subtitle.ass "Note|Sign"
# Example: subtitles_stripper.sh subtitle.ass "Main|Default" -v

[ ! -e "$1" ] && echo "File $1 does not exist" && exit 1
[ -z "$2" ] && echo "No style was given, find styles with grep 'Style:'" && exit 2
[ ! -e ./stripped ] && mkdir ./stripped
cat "$1" | tee >(grep Dialogue | grep $3 -E "($2)" > /tmp/notes) | grep -v Dialogue > ./stripped/"$1"; cat /tmp/notes >> ./stripped/"$1"
rm /tmp/notes
