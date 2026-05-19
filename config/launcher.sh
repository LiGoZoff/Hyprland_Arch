#!/bin/sh
if pgrep -x rofi; then
    killall rofi
else
    current_time=$(date "+🕒 %I:%M ")
    
    rofi -show drun -display-drun "$current_time" -theme $HOME/.config/rofi/style-1.rasi
fi