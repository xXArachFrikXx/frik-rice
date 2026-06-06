#!/bin/bash
# Applies a wallpaper selected from the eww picker.
# $1 = base name without extension (e.g. "ATSV1")
# Finds the actual file (jpg/png/etc), closes the picker, sets wallpaper,
# applies color scheme, and updates the hyprlock symlink.

NAME="$1"
WALLPAPER_DIR="$HOME/wallpapers"
SYMLINK_PATH="$HOME/.config/hypr/current_wallpaper"

[ -z "$NAME" ] && exit 1

# Find the actual wallpaper file (any extension)
SELECTED_PATH=$(ls "$WALLPAPER_DIR/$NAME".{jpg,jpeg,png,gif} 2>/dev/null | head -1)
[ -z "$SELECTED_PATH" ] && exit 1

# Close the picker immediately so it feels snappy
eww close wallpaper-picker

# Set the wallpaper via swww
awww img --transition-type outer --transition-duration 1 --transition-fps 60 "$SELECTED_PATH"

# Apply the per-wallpaper color scheme
"$HOME/.config/hypr/scripts/scheme-apply.sh" "$SELECTED_PATH"

# Update hyprlock background symlink
ln -sf "$SELECTED_PATH" "$SYMLINK_PATH"
