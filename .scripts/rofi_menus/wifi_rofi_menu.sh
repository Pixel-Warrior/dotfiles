#!/usr/bin/env bash

choose_wifi(){
	local chosen_wifi=$(\
	nmcli -t -f IN-USE,SSID,BARS d wifi |\
	awk -F ":" '{if ($1 == "*") {printf"> "; printf("%-36s|%4s|\n",$2,$3)} else printf("%-38s|%4s|\n",$2 ,$3)}' |\
	rofi -dmenu -p "Choose your WiFi" -i -l 10\
	-theme-str 'window{width:34%;}') || exit 0
	[ -z "$chosen_wifi" ] && exit 0
	if [[ "$chosen_wifi" == *"> "* ]]; then
		nmcli r wifi off
	else
		echo "$chosen_wifi" | head -c -6 | awk '{NF--; print $0}' |\
		xargs -I % nmcli d wifi connect "%"
	fi
}

if [[ $(nmcli r wifi) == "disabled" ]]; then
	#not connected
	if [[ $(echo "Enable WiFi" |\
		rofi -dmenu -l 1 -a \
		-theme-str 'window{width:12%;}'\
		-p "WiFi is DOWN") ]]; then
		nmcli r wifi on
		while [[ $(nmcli d wifi | wc -l) -le 1 ]]; do
			sleep 0.1
		done
		sleep 0.5
		if [[ $(nmcli -t -f IN-USE d wifi | grep "\*") ]]; then
			exit 0
		else
			choose_wifi
		fi
	fi
else
	#connected
	choose_wifi
fi
