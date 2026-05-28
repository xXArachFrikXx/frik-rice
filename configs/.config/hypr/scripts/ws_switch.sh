#!/bin/bash
# Switch workspace via Hyprland Lua eval — hyprctl dispatch doesn't work in Lua mode
hyprctl eval "hl.dispatch(hl.dsp.focus({ workspace = $1 }))"
