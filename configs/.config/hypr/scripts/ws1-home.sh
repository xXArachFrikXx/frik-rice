#!/bin/bash
# Close any existing homepage windows
hyprctl eval '
local wins = hl.get_windows()
for _, w in ipairs(wins) do
    local c = w:get_class()
    if c=="kitty-btop" or c=="kitty-clock" or c=="kitty-cava" or c=="kitty-cmatrix" or c=="kitty-fastfetch" then
        w:close()
    end
end
' 2>/dev/null
sleep 0.3

# Helper: run a Lua dispatch
lsp() { hyprctl eval "hl.dispatch($1)" 2>/dev/null; }

# Switch to workspace 1
lsp 'hl.dsp.focus({ workspace = 1 })'
sleep 0.2

# ── 1. btop — opens first, takes full workspace ──
kitty --class kitty-btop -e btop &
sleep 0.5

# ── 2. cmatrix — split LEFT of btop (btop stays left, cmatrix opens right) ──
lsp 'hl.dsp.layout("preselect l")'
sleep 0.05
kitty --class kitty-cmatrix -e cmatrix -a -b -C magenta &
sleep 0.5

# Layout: [btop | cmatrix]

# ── 3. tty-clock — split UP inside the right column (above cmatrix) ──
lsp 'hl.dsp.focus({ window = "class:kitty-cmatrix" })'
lsp 'hl.dsp.layout("preselect u")'
sleep 0.05
kitty --class kitty-clock -e tty-clock -c -C 5 -b -s &
sleep 0.5

# Shrink top row so cmatrix gets more height (~20% top / 80% bottom)
lsp 'hl.dsp.focus({ window = "class:kitty-clock" })'
lsp 'hl.dsp.layout("splitratio -0.15")'

# Layout: [btop | tty-clock / cmatrix]

# ── 4. cava — split left of tty-clock (tty-clock stays left, cava opens right) ──
lsp 'hl.dsp.focus({ window = "class:kitty-clock" })'
lsp 'hl.dsp.layout("preselect l")'
sleep 0.05
kitty --class kitty-cava -e cava &
sleep 0.4

# Layout: [btop | tty-clock | cava]
#                [    cmatrix      ]

# ── 5. fastfetch — floating window, window rule centers it ──
kitty --class kitty-fastfetch --override font_size=14 -e bash -c 'fastfetch; exec bash' &
