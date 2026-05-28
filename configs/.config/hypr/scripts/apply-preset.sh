#!/bin/bash
# Apply a rice preset: wallpaper + color scheme + waybar theme
# Usage: apply-preset.sh <preset-name>  OR  apply-preset.sh  (rofi picker)

PRESETS_DIR="$HOME/.config/hypr/presets"
WAYBAR_STYLE="$HOME/.config/waybar/style.css"
STYLE_DIR="$HOME/.config/waybar/style"

pick_preset() {
    find "$PRESETS_DIR" -maxdepth 1 -name "*.preset" -exec basename {} .preset \; | sort |
        rofi -i -dmenu -config "$HOME/.config/rofi/config.rasi" -mesg "  Choose Preset"
}

apply() {
    local preset_file="$PRESETS_DIR/$1.preset"
    [[ -f "$preset_file" ]] || { echo "Preset not found: $1"; exit 1; }

    local wallpaper scheme seed waybar_theme
    wallpaper=$(grep -m1 '^WALLPAPER=' "$preset_file" | cut -d= -f2-)
    scheme=$(grep -m1 '^SCHEME=' "$preset_file" | cut -d= -f2-)
    seed=$(grep -m1 '^SEED_COLOR=' "$preset_file" | cut -d= -f2-)
    waybar_theme=$(grep -m1 '^WAYBAR_THEME=' "$preset_file" | cut -d= -f2-)

    # Set wallpaper
    [[ -f "$wallpaper" ]] && awww img "$wallpaper" --transition-type any --transition-fps 60

    # Apply color scheme
    # If SEED_COLOR is set → use hex seed with the given scheme type
    # SCHEME=color          → hex seed, default (tonal-spot) scheme
    # SCHEME=<type>         → hex seed with that scheme type (e.g. vibrant, tonal-spot, expressive)
    # No SEED_COLOR         → analyze the wallpaper image instead
    if [[ -n "$seed" ]]; then
        if [[ "$scheme" == "color" ]]; then
            matugen color hex "$seed" --prefer darkness
        else
            matugen color hex "$seed" --type "scheme-${scheme}" --prefer darkness
        fi
    else
        matugen image "$wallpaper" --type "scheme-${scheme}" --prefer darkness
    fi

    # Switch waybar style
    if [[ -n "$waybar_theme" ]]; then
        ln -sf "$STYLE_DIR/$waybar_theme.css" "$WAYBAR_STYLE"
        pkill -SIGUSR2 waybar
    fi

    # Signal btop to redraw (new theme takes effect on next btop start)
    pkill -SIGUSR1 btop 2>/dev/null || true
}

if pgrep -x rofi >/dev/null; then pkill rofi; exit 0; fi

if [[ -n "$1" ]]; then
    apply "$1"
else
    choice=$(pick_preset)
    [[ -z "$choice" ]] && exit 0
    apply "$choice"
fi
