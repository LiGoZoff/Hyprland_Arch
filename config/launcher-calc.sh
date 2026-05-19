#!/bin/sh
if pgrep -x rofi; then
    killall rofi
else
    rofi -show calc -theme $HOME/.config/rofi/style-1.rasi
fi 