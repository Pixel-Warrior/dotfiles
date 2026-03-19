#!/usr/bin/env bash

interface=$(nmcli c | grep wireguard |\
	awk '{if ($4 != "--") printf "> "; print $1}' |\
	rofi -dmenu -p VPN -i -l 5 -theme-str 'window{width:20%;}') || exit 0

if [[ $interface == *"> "* ]]; then
	nmcli c down $(echo $interface | awk '{$1="";print $0}')
else
	nmcli c up $interface
fi
