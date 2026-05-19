#!/bin/bash

CONFIG_DIR="$HOME/.config/hypr/conf/"

if [ ! -d "$CONFIG_DIR" ]; then
    notify-send -u critical "Ошибка" "Папка $CONFIG_DIR не найдена!"
    exit 1
fi

EDITOR_CMD=${EDITOR:-xdg-open}

# EDITOR_CMD="kitty -e ${EDITOR:-nvim}"


CHOSEN_FILE=$(cd "$CONFIG_DIR" && find . -maxdepth 1 -type f | sed 's|^\./||' | sort | rofi -dmenu -p "⚙️ Configs" -theme "$HOME/.config/rofi/style-1.rasi")

if [ -z "$CHOSEN_FILE" ]; then
    exit 0
fi

FULL_PATH="$CONFIG_DIR$CHOSEN_FILE"

$EDITOR_CMD "$FULL_PATH"