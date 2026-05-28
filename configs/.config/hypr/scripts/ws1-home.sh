#!/bin/bash
# Close any existing homepage windows
hyprctl eval '
local wins = hl.get_windows()
for _, w in ipairs(wins) do
    local c = w:get_class()
    if c=="kitty-btop" or c=="kitty-clock" or c=="kitty-pipes" or c=="kitty-cmatrix" or c=="kitty-fastfetch" then
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

# ── 2. cmatrix — split RIGHT of btop ──
lsp 'hl.dsp.layout("preselect r")'
sleep 0.05
kitty --class kitty-cmatrix -e cmatrix -a -b &
sleep 0.5

# Layout: [btop | cmatrix]

# ── 3. tty-clock — split UP inside the right column (above cmatrix) ──
lsp 'hl.dsp.focus({ window = "class:kitty-cmatrix" })'
lsp 'hl.dsp.layout("preselect u")'
sleep 0.05
kitty --class kitty-clock -e tty-clock -c -C 3 -b -s &
sleep 0.5

# Layout: [btop | tty-clock / cmatrix]

# ── 4. pipes — split RIGHT of tty-clock ──
lsp 'hl.dsp.focus({ window = "class:kitty-clock" })'
lsp 'hl.dsp.layout("preselect r")'
sleep 0.05
kitty --class kitty-pipes -e pipes.sh -p 3 -f 0 &
sleep 0.4

# Layout: [btop | tty-clock | pipes]
#                [    cmatrix        ]

# ── 5. fastfetch — floating window, window rule centers it ──
kitty --class kitty-fastfetch --override font_size=14 -e bash -c 'fastfetch; exec bash' &
