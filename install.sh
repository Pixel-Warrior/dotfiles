#!/usr/bin/env bash

search_folder(){
	for i in $(ls -a $1); do
		if [[ "$i" == "install.sh" || "$i" == "." || "$i" == ".." || "$i" == ".git" ]]; then
			continue
		elif [[ -d "$1/$i" ]]; then
			search_folder "$1/$i"
		else
			dir="$(echo "$1" | cut -d '/' -f 2-)"
			if [[ ! -d "$HOME/$dir" ]]; then
				echo "creating directory $HOME/$dir"
				mkdir "$HOME/$dir"
			else
				:
			fi
			echo "creating symlink to $1/$i"
			#rm "$HOME/$dir/$i"
			ln "$1/$i" "$HOME/$dir"
		fi
	done
}

search_folder .
