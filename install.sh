#!/usr/bin/env bash

ignorelist=("README.md" "install.sh" ".git" "." "..")

search_folder(){
	for i in $(ls -a $1); do
		if [[ ${ignorelist[@]} =~ "$i" ]]; then
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
				mkdir -p "$HOME/$dir"
			fi
			if [[ -e "$targetdir/$i" ]]; then
				echo "removing existing $targetdir/$i"
				rm "$targetdir/$i"
			fi
			echo "creating symlink to $repofile in $targetdir"
			ln -s "$repofile" "$targetdir"
		fi
	done
}

if [[ $0 != "./install.sh" ]]; then
	echo '''
You are running this script not from the repo directory!!!
cd to the directory you downloaded and only then run script by the

	./install.sh

command!
'''
	exit 1
fi

echo '''
This script will REMOVE every dotfile mentioned in repo 
IN YOUR HOME DIRECTORY and replace it with symlink to dotfile in repo
'''
read -p "Do you wish to continue?(y/n) > " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 2

search_folder .
