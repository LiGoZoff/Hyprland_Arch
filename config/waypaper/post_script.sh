#!/bin/bash

RAW_PATH="$1"
WALLPAPER_DIR=$(dirname "$RAW_PATH")
TARGET="$HOME/Pictures/Wallpapers/.wallpaper_current.jpg"

# 1. Поиск видеофайла (mp4, mkv, webm)
VIDEO_FILE=$(find "$WALLPAPER_DIR" -type f \( -name "*.mp4" -o -name "*.mkv" -o -name "*.webm" \) -printf "%s %p\n" | sort -rn | head -n1 | cut -d' ' -f2-)

# 2. Логика извлечения
if [ -n "$VIDEO_FILE" ]; then
    # Если видео найдено, берем первый кадр из него
    ffmpeg -y -i "$VIDEO_FILE" -frames:v 1 -f image2 "$TARGET" -loglevel error
else
    # Если видео нет (это сцена), берем ПЕРВЫЙ кадр из preview.gif
    # Это гарантирует, что мы получим картинку, а не черный фон от текстур
    magick "${RAW_PATH}[0]" "$TARGET"
fi

# 3. Символическая ссылка для совместимости
ln -sf "$TARGET" "$HOME/Pictures/Wallpapers/.wallpaper_current"

# 4. Копирование для SDDM
cp "$TARGET" "/usr/share/sddm/themes/simple-sddm/Backgrounds/wallpaper_current.gif"

pkill -SIGUSR1 waybar
# 5. Работа с Pywal
rm -rf "$HOME/.cache/wal"
wal -i "$TARGET"
bash ~/.config/waybar/scripts/generate-config.sh

pkill -SIGUSR2 waybar
hyprctl reload
pkill -SIGUSR1 waybar

bash ~/.config/hypr/Themes/pywal-obsidian/pywal-obsidian.sh "$HOME/Документы/Obsidian"
pywalfox install
walcord
