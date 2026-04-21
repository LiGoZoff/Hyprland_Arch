#!/bin/bash
# Генерирует config.jsonc из template с цветами из colors.json

CACHE_DIR="$HOME/.cache/wal"
CONFIG_DIR="$HOME/.config/waybar"
SCRIPTS_DIR="$CONFIG_DIR/scripts"

# Читаем цвета из JSON
COLOR_MONTHS=$(jq -r '.colors.color6' "$CACHE_DIR/colors.json")
COLOR_DAYS=$(jq -r '.special.foreground' "$CACHE_DIR/colors.json")
COLOR_WEEKS=$(jq -r '.colors.color5' "$CACHE_DIR/colors.json")
COLOR_WEEKDAYS=$(jq -r '.colors.color5' "$CACHE_DIR/colors.json")
COLOR_TODAY=$(jq -r '.colors.color2' "$CACHE_DIR/colors.json")

# Подставляем в template и генерируем config
cat "$SCRIPTS_DIR/config.jsonc.template" | \
  sed "s|{{COLOR_MONTHS}}|$COLOR_MONTHS|g" | \
  sed "s|{{COLOR_DAYS}}|$COLOR_DAYS|g" | \
  sed "s|{{COLOR_WEEKS}}|$COLOR_WEEKS|g" | \
  sed "s|{{COLOR_WEEKDAYS}}|$COLOR_WEEKDAYS|g" | \
  sed "s|{{COLOR_TODAY}}|$COLOR_TODAY|g" > "$CONFIG_DIR/config.jsonc"

echo "✓ config.jsonc обновлен"
