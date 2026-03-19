#!/usr/bin/env bash

device="SynPS/2 Synaptics TouchPad"

actions=(enable disable)

action="${actions[$(xinput list-props "$device" | grep "Device Enabled" | cut -d : -f2)]}"

xinput "$action" "$device"
notify-send -t 1500 -i "touchpad-${action}d" "Touchpad ${action}d"
