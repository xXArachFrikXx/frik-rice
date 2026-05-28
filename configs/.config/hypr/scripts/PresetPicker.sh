#!/bin/bash
PRESETS_DIR="$HOME/.config/hypr/presets"

if pgrep -x rofi >/dev/null; then pkill rofi; exit 0; fi

chosen=$(find "$PRESETS_DIR" -maxdepth 1 -name "*.preset" | sort | \
    xargs -I{} basename {} .preset | \
    rofi -i -dmenu \
        -config "$HOME/.config/rofi/config.rasi" \
        -mesg "  Choose Theme Preset")

[[ -z "$chosen" ]] && exit 0
"$HOME/.config/hypr/scripts/apply-preset.sh" "$chosen"
