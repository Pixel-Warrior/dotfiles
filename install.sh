#!/usr/bin/env bash

search_folder(){
	for i in $(ls -a $1); do
		if [[ "$i" == "install.sh" || "$i" == "." || "$i" == ".." || "$i" == ".git" ]]; then
			continue
		elif [[ -d "$1/$i" ]]; then
			search_folder "$1/$i"
		else
			dir="$(echo "$1" | cut -d '/' -s -f 2-)"
			if [[ -z "$dir" ]]; then
				repofile="$PWD/$i"
				targetdir="$HOME"
			else
				repofile="$PWD/$dir/$i"
				targetdir="$HOME/$dir"
			fi
			if [[ ! -d "$HOME/$dir" ]]; then
				echo "creating directory $HOME/$dir"
				mkdir "$HOME/$dir"
			fi
			echo "creating symlink to $repofile in $targetdir"
			rm "$targetdir/$i"
			ln -s "$repofile" "$targetdir"
		fi
	done
}

echo '''
This script will REMOVE every dotfile mentioned in repo 
IN YOUR HOME DIRECTORY and replace it with symlink to dotfile in repo
'''
read -p "Do you wish to continue?(y/n) > " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

search_folder .
