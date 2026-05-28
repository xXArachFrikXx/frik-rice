#!/bin/bash
# Waybar theme picker — applies a named layout+style pair in one shot.
# Themes live in ~/.config/waybar/themes/ as *.theme files.
# Each theme file defines CONFIG= (filename in configs/) and STYLE= (filename without .css in style/).

IFS=$'\n\t'

THEMES_DIR="$HOME/.config/waybar/themes"
WAYBAR_CONFIG="$HOME/.config/waybar/config"
WAYBAR_STYLE="$HOME/.config/waybar/style.css"
CONFIGS_DIR="$HOME/.config/waybar/configs"
STYLE_DIR="$HOME/.config/waybar/style"
SCRIPTSDIR="$HOME/.config/hypr/scripts"
ROFI_CONFIG="$HOME/.config/rofi/config.rasi"
MSG="  Choose Waybar Theme"

# List theme names (strip the .theme extension for display)
menu() {
    find "$THEMES_DIR" -maxdepth 1 -type f -name "*.theme" \
        -exec basename {} .theme \; | sort
}

apply_theme() {
    local theme_file="$THEMES_DIR/$1.theme"

    # Read CONFIG= and STYLE= lines, strip comments and whitespace
    local config style
    config=$(grep -m1 '^CONFIG=' "$theme_file" | cut -d'=' -f2-)
    style=$(grep -m1 '^STYLE=' "$theme_file" | cut -d'=' -f2-)

    if [[ -z "$config" || -z "$style" ]]; then
        notify-send "WaybarTheme" "Bad theme file: $1 (missing CONFIG or STYLE)"
        exit 1
    fi

    ln -sf "$CONFIGS_DIR/$config" "$WAYBAR_CONFIG"
    ln -sf "$STYLE_DIR/$style.css" "$WAYBAR_STYLE"
    "${SCRIPTSDIR}/wbrestart.sh" &
}

main() {
    local choice
    choice=$(menu | rofi -i -dmenu -config "$ROFI_CONFIG" -mesg "$MSG")
    [[ -z "$choice" ]] && exit 0
    apply_theme "$choice"
}

if pgrep -x "rofi" >/dev/null; then
    pkill rofi
fi

main
