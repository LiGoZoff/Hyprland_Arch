#!/bin/bash

CURRENT_BACKEND=$(grep "^backend\s*=" "$HOME/.config/waypaper/config.ini" | sed 's/.*=\s*//' | xargs)
LAST_BACKEND_FILE="$HOME/.config/waypaper/last_backend"
ALL_BACKENDS=("awww" "linux-wallpaperengine" "mpvpaper" "swaybg" "hyprpaper")

if [ -f "$LAST_BACKEND_FILE" ]; then
    LAST_BACKEND=$(cat "$LAST_BACKEND_FILE")
fi

if
    [ "$CURRENT_BACKEND" == "awww" ]; then
        pkill -9 -f "linux-wallpaperengine|mpvpaper|swaybg|hyprpaper"
    elif [ "$CURRENT_BACKEND" == "linux-wallpaperengine" ]; then
        pkill -9 -f "awww-daemon|mpvpaper|swaybg|hyprpaper"
    elif [ "$CURRENT_BACKEND" == "mpvpaper" ]; then
        pkill -9 -f "awww-daemon|linux-wallpaperengine|swaybg|hyprpaper"
    elif [ "$CURRENT_BACKEND" == "swaybg" ]; then
        pkill -9 -f "awww-daemon|linux-wallpaperengine|mpvpaper|hyprpaper"
    elif [ "$CURRENT_BACKEND" == "hyprpaper" ]; then
        pkill -9 -f "awww-daemon|linux-wallpaperengine|mpvpaper|swaybg"
    fi



echo "$CURRENT_BACKEND" > "$LAST_BACKEND_FILE"

RAW_PATH="$1"
WALLPAPER_DIR=$(dirname "$RAW_PATH")
TARGET="$HOME/Pictures/Wallpapers/.wallpaper_current.jpg"

VIDEO_FILE=$(find "$WALLPAPER_DIR" -type f \( -name "*.mp4" -o -name "*.mkv" -o -name "*.webm" \) -printf "%s %p\n" | sort -rn | head -n1 | cut -d' ' -f2-)

if [ -n "$VIDEO_FILE" ]; then
    ffmpeg -y -i "$VIDEO_FILE" -frames:v 1 -f image2 "$TARGET" -loglevel error
else
    magick "${RAW_PATH}[0]" "$TARGET"
fi

cp "$TARGET" "/usr/share/sddm/themes/simple-sddm/Backgrounds/wallpaper_current.gif"

rm -rf "$HOME/.cache/wal"
wal -i "$TARGET"
bash ~/.config/waybar/scripts/generate-config.sh

pkill -SIGUSR2 waybar
hyprctl reload

bash ~/.config/hypr/Themes/pywal-obsidian/pywal-obsidian.sh "$HOME/Документы/Obsidian"
pywalfox install
walcord
swaync-client --reload-css
systemctl --user restart swaync