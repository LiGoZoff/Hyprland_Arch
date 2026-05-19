#!/bin/bash

get_volume() {
	volume=$(pamixer --get-volume)
	echo "$volume"
}

get_icon() {
	current=$(get_volume)
}

notify_user() {
	notify-send -h string:x-canonical-private-synchronous:sys-notify -h string:transient:true -u low "Volume : $(get_volume) %"
}

inc_volume() {
	pamixer -i 5 && notify_user
}

dec_volume() {
	pamixer -d 5 && notify_user
}

toggle_mute() {
	if [ "$(pamixer --get-mute)" == "false" ]; then
		pamixer -m && notify-send -h string:x-canonical-private-synchronous:sys-notify -h string:transient:true -u low  "Volume Switched OFF"
	elif [ "$(pamixer --get-mute)" == "true" ]; then
		pamixer -u && notify-send -h string:x-canonical-private-synchronous:sys-notify -h string:transient:true -u low "Volume Switched ON"
	fi
}

toggle_mic() {
	if [ "$(pamixer --default-source --get-mute)" == "false" ]; then
		pamixer --default-source -m && notify-send -h string:x-canonical-private-synchronous:sys-notify -h string:transient:true -u low "Microphone Switched OFF"
	elif [ "$(pamixer --default-source --get-mute)" == "true" ]; then
		pamixer -u --default-source u && notify-send -h string:x-canonical-private-synchronous:sys-notify -h string:transient:true -u low "Microphone Switched ON"
	fi
}
get_mic_icon() {
	current=$(pamixer --default-source --get-volume)
}
notify_mic_user() {
	notify-send -h string:x-canonical-private-synchronous:sys-notify -h string:transient:true -u low "Mic-Level : $(pamixer --default-source --get-volume) %"
}

inc_mic_volume() {
	pamixer --default-source -i 5 && notify_mic_user
}

dec_mic_volume() {
	pamixer --default-source -d 5 && notify_mic_user
}

if [[ "$1" == "--get" ]]; then
	get_volume
elif [[ "$1" == "--inc" ]]; then
	inc_volume
elif [[ "$1" == "--dec" ]]; then
	dec_volume
elif [[ "$1" == "--toggle" ]]; then
	toggle_mute
elif [[ "$1" == "--toggle-mic" ]]; then
	toggle_mic
elif [[ "$1" == "--get-icon" ]]; then
	get_icon
elif [[ "$1" == "--get-mic-icon" ]]; then
	get_mic_icon
elif [[ "$1" == "--mic-inc" ]]; then
	inc_mic_volume
elif [[ "$1" == "--mic-dec" ]]; then
	dec_mic_volume
else
	get_volume
fi
