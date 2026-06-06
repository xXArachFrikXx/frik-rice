#!/bin/bash
if hyprctl clients -j | grep -q '"class": "kitty-rmpc-overlay"'; then
    hyprctl clients -j \
        | jq -r '.[] | select(.class == "kitty-rmpc-overlay" or .class == "kitty-cava-overlay") | .pid' \
        | xargs -r kill
else
    kitty --class kitty-cava-overlay \
          --override background_opacity=1.0 \
          --override window_border_width=0 \
          -e cava &
    sleep 0.15
    kitty --class kitty-rmpc-overlay \
          --override background_opacity=1.0 \
          --override window_border_width=0 \
          -e rmpc &
fi
