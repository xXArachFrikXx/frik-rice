#!/bin/bash
# Wallpaper picker — opens a rofi thumbnail menu to pick a wallpaper.
# After selecting, generates (or reuses) a per-wallpaper gruvbox-format color
# scheme and distributes it to all apps.  Edit the scheme file at
# ~/.config/hypr/schemes/<wallpaper>.colors to fine-tune colors.

# === CONFIG ===
WALLPAPER_DIR="$HOME/wallpapers"                     # Directory to scan for wallpapers
SYMLINK_PATH="$HOME/.config/hypr/current_wallpaper"  # Symlink used by hyprlock background

cd "$WALLPAPER_DIR" || exit 1  # Exit if wallpaper dir doesn't exist

# Prevent spaces in filenames from splitting the list
IFS=$'\n'

# Build rofi icon-preview menu sorted by newest file first
# Format: "filename\0icon\x1ffilename\n" tells rofi to use the file itself as the icon
SELECTED_WALL=$(for a in $(ls -t *.jpg *.png *.gif *.jpeg 2>/dev/null); do echo -en "$a\0icon\x1f$a\n"; done | rofi -dmenu -p "" -theme ~/.config/rofi/wallpaper.rasi)
[ -z "$SELECTED_WALL" ] && exit 1  # User closed rofi without selecting

SELECTED_PATH="$WALLPAPER_DIR/$SELECTED_WALL"

# Set the wallpaper immediately via awww
awww img --transition-type wipe --transition-angle 30 --transition-fps 60 "$SELECTED_PATH"

# Apply color scheme (generates one on first use, reuses on subsequent loads)
"$HOME/.config/hypr/scripts/scheme-apply.sh" "$SELECTED_PATH"

# Update the hyprlock background symlink to the new wallpaper
mkdir -p "$(dirname "$SYMLINK_PATH")"
ln -sf "$SELECTED_PATH" "$SYMLINK_PATH"
