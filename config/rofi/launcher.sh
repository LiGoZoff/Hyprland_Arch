#!/bin/sh
if pgrep -x rofi; then
    killall rofi
else
    rofi -show drun -theme $HOME/.config/rofi/style-1.rasi
fi 