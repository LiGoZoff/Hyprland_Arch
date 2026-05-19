#!/usr/bin/env bash

get_backlight() {
	echo $(brightnessctl -m | cut -d, -f4)
}

get_icon() {
	current=$(get_backlight | sed 's/%//')
}

notify_user() {
	notify-send -h string:x-canonical-private-synchronous:sys-notify -h string:transient:true -u low "Brightness : $current%"
}

change_backlight() {
	brightnessctl set "$1" && get_icon && notify_user
}

case "$1" in
	"--get")
		get_backlight
		;;
	"--inc")
		change_backlight "+10%"
		;;
	"--dec")
		change_backlight "10%-"
		;;
	*)
		get_backlight
		;;
esac