cp "$1" $HOME/Pictures/Wallpapers/.wallpaper_current
cp "$1" /usr/share/sddm/themes/simple-sddm/Backgrounds/wallpaper_current.gif

pkill -SIGUSR1 waybar
rm -rf $HOME/.cache/wal
wal -i $HOME/Pictures/Wallpapers/.wallpaper_current
pkill -SIGUSR2 waybar
hyprctl reload
pkill -SIGUSR1 waybar
bash ~/.config/hypr/Themes/pywal-obsidian/pywal-obsidian.sh "$HOME/Документы/Obsidian"
walcord
