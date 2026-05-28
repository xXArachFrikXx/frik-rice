#!/bin/bash
# Wallpaper picker — opens a rofi thumbnail menu to pick a wallpaper.
# After selecting, matugen generates a new color scheme from the wallpaper
# and updates all apps (waybar, kitty, rofi, cava, hyprland borders, etc.).
# The selected wallpaper is also symlinked to current_wallpaper for hyprlock.

# === CONFIG ===
WALLPAPER_DIR="$HOME/Wallpapers"                     # Directory to scan for wallpapers
SYMLINK_PATH="$HOME/.config/hypr/current_wallpaper"  # Symlink used by hyprlock background

cd "$WALLPAPER_DIR" || exit 1  # Exit if wallpaper dir doesn't exist

# Prevent spaces in filenames from splitting the list
IFS=$'\n'

# Build rofi icon-preview menu sorted by newest file first
# Format: "filename\0icon\x1ffilename\n" tells rofi to use the file itself as the icon
SELECTED_WALL=$(for a in $(ls -t *.jpg *.png *.gif *.jpeg 2>/dev/null); do echo -en "$a\0icon\x1f$a\n"; done | rofi -dmenu -p "")
[ -z "$SELECTED_WALL" ] && exit 1  # User closed rofi without selecting

SELECTED_PATH="$WALLPAPER_DIR/$SELECTED_WALL"

# Set the wallpaper immediately via awww (matugen's built-in wallpaper setter is unreliable)
awww img --transition-type any --transition-fps 60 "$SELECTED_PATH"

# Generate color scheme from the new wallpaper and update all apps (waybar, kitty, rofi, etc.)
# --source-color-index 0 picks the dominant color automatically (no interactive prompt needed)
matugen image --source-color-index 0 "$SELECTED_PATH"

# Update the hyprlock background symlink to the new wallpaper
mkdir -p "$(dirname "$SYMLINK_PATH")"
ln -sf "$SELECTED_PATH" "$SYMLINK_PATH"
