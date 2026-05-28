#!/bin/bash
if hyprctl clients -j | grep -q '"class": "kitty-rmpc-overlay"'; then
    hyprctl eval '
        local wins = hl.get_windows()
        for _, w in ipairs(wins) do
            local c = w:get_class()
            if c == "kitty-rmpc-overlay" or c == "kitty-cava-overlay" then
                w:close()
            end
        end
    ' 2>/dev/null
else
    kitty --class kitty-rmpc-overlay \
          --override background_opacity=1.0 \
          --override window_border_width=0 \
          -e rmpc &
    sleep 0.15
    kitty --class kitty-cava-overlay \
          --override background_opacity=1.0 \
          --override window_border_width=0 \
          -e cava &
fi
