#!/usr/bin/env bash

dir="$1"
[ ! -d $dir ] && echo "Directory $dir does not exist" && exit 1
echo "chosen folder is: $dir"

while file=$(inotifywait -e attrib --format %f $dir); do
	if [ "$(file -b --extension $dir/$file)" = "webp" ]; then
		if [ "$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $dir/$file)" = 'N/A' ]; then
			newfile=$(echo "$file" | cut -d . -f1)
			postfix=""
			index=0
			while [ -f "$dir/$newfile$postfix.png" ]; do
				let ++index
				export postfix="($index)"
			done
			ffmpeg -i "$dir/$file" -n "$dir/$newfile$postfix.png" \
			&& rm "$dir/$file"
		fi
	fi
done
