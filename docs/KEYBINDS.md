# Keyboard Shortcuts

SUPER = Windows key (also called Meta or Mod4)

All keybinds are defined in `~/.config/hypr/Modules/Keybind.lua`.

---

## Apps & Windows

| Shortcut | Action |
|----------|--------|
| `SUPER + Return` | Open terminal (kitty) |
| `SUPER + SHIFT + Return` | Open floating terminal |
| `SUPER + D` | Open app launcher (rofi) |
| `SUPER + E` | Open file manager (Nautilus) |
| `SUPER + SHIFT + E` | Open Yazi file manager in terminal |
| `SUPER + B` | Open browser |
| `SUPER + C` | Close focused window |
| `SUPER + Q` | Force-kill active window's process |

---

## Window Management

| Shortcut | Action |
|----------|--------|
| `SUPER + SHIFT + F` | Toggle fullscreen |
| `SUPER + Space` | Toggle floating on focused window |
| `SUPER + P` | Toggle pseudo-tile (dwindle layout) |
| `SUPER + J` | Toggle dwindle split direction (horizontal ↔ vertical) |
| `SUPER + Arrow keys` | Move focus between windows |
| `SUPER + CTRL + Arrow keys` | Move window in tiling layout |
| `SUPER + SHIFT + Arrow keys` | Resize focused window |
| `SUPER + Left click (drag)` | Drag a floating window |
| `SUPER + Right click (drag)` | Resize a window |

---

## Workspaces

| Shortcut | Action |
|----------|--------|
| `SUPER + 1–9, 0` | Switch to workspace 1–10 |
| `SUPER + SHIFT + 1–9, 0` | Move focused window to workspace 1–10 |
| `SUPER + Scroll wheel` | Scroll through workspaces |
| `SUPER + ALT + 1` | Reset workspace 1 homepage layout (btop, clock, pipes, cmatrix, fastfetch) |

Workspaces 1–5 are pinned to the main HDMI monitor.
Workspaces 6–10 are pinned to the DisplayPort monitor.
(Edit in `~/.config/hypr/Modules/WindowsWorkspace.lua` if your monitors differ.)

---

## Rice / Theming

| Shortcut | Action |
|----------|--------|
| `SUPER + W` | Open theme preset picker (rofi) — sets wallpaper + colors |
| `SUPER + ALT + W` | Open wallpaper picker (rofi thumbnail menu) |
| `SUPER + SHIFT + W` | Open waybar theme picker |
| `SUPER + CTRL + B` | Open waybar style selector |
| `SUPER + ALT + B` | Open waybar layout selector |
| `SUPER + R` | Restart waybar + swaync |
| `SUPER + H` | Hide / show waybar |

---

## Music Overlay

| Shortcut | Action |
|----------|--------|
| `SUPER + M` | Toggle music overlay (rmpc + cava — two floating windows above waybar) |

When the overlay is open:
- The top window is **rmpc** (the music player)
- The bottom window is **cava** (the audio visualizer)
- Press SUPER+M again to close both

---

## System

| Shortcut | Action |
|----------|--------|
| `SUPER + L` | Lock screen (hyprlock) |
| `SUPER + SHIFT + S` | Screenshot (select region, saved to clipboard + file) |
| `CTRL + ALT + Delete` | Exit Hyprland entirely |

---

## Media Keys

| Key | Action |
|-----|--------|
| Volume Up / Down / Mute | Adjust system volume |
| Mic Mute | Mute/unmute microphone |
| Brightness Up / Down | Adjust screen brightness |
| Play / Pause / Next / Prev | Control media player via playerctl |
