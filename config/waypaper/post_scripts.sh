#!/bin/bash

WALLPAPER="$1"

cp "$WALLPAPER" "$HOME/Pictures/Wallpapers/.wallpaper_current"

sudo cp "$WALLPAPER" "/usr/share/sddm/themes/simple-sddm/Backgrounds/wallpaper_current.gif"

pkill -SIGUSR1 waybar

rm -rf "$HOME/.cache/wal"
wal -i "$HOME/Pictures/Wallpapers/.wallpaper_current"

pkill -SIGUSR2 waybar
hyprctl reload
pkill -SIGUSR1 waybar

bash ~/.config/hypr/Themes/pywal-obsidian/pywal-obsidian.sh "$HOME/Документы/Obsidian"