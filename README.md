# Frik's Hyprland Rice

A full Arch Linux system snapshot — every config, every wallpaper, every package.
Install from scratch on a new machine with one script.

---

## Quick Start

### Fresh Arch install (nothing on it yet)
```bash
# 1. Clone this repo
git clone https://github.com/xXArachFrikXx/frik-rice.git ~/frik-rice

# 2. Run the install script
cd ~/frik-rice
bash install.sh

# 3. Transfer your music library (see docs/MUSIC.md)
bash transfer-music.sh <old-machine-ip>

# 4. Log out and back in — done!
```

### Already have stuff installed? Reset to bare Arch first
If the machine has an existing desktop or random packages, wipe it to a minimal
base before installing. Switch to a TTY first (Ctrl+Alt+F2), then:
```bash
cd ~/frik-rice
bash reset.sh    # strips everything except core system packages
bash install.sh  # installs everything fresh
```

The install script tells you exactly what it's doing at every step.
It skips packages that are already installed, so re-running it is always safe.

---

## What's Included

```
frik-rice/
├── install.sh          ← Master setup script (start here)
├── transfer-music.sh   ← Copy music from old machine via rsync
│
├── configs/            ← All ~/.config/ directories
│   └── .config/
│       ├── hypr/       ← Hyprland window manager (Lua config)
│       ├── kitty/      ← Terminal emulator
│       ├── waybar/     ← Status bar
│       ├── fastfetch/  ← System info on terminal open
│       ├── cava/       ← Audio visualizer
│       ├── rofi/       ← App launcher
│       ├── matugen/    ← Color theme generator + templates
│       ├── btop/       ← System monitor
│       ├── wlogout/    ← Logout screen
│       ├── swaync/     ← Notification center
│       ├── rmpc/       ← Music player TUI (MPD frontend)
│       └── mpd/        ← Music Player Daemon config
│
├── home/               ← Dotfiles that live in ~/
│   └── .zshrc          ← Shell config (oh-my-zsh + starship + plugins)
│
├── wallpapers/         ← All 82 wallpapers
│
├── packages/
│   ├── pacman.txt      ← Official repo packages
│   ├── aur.txt         ← AUR packages (installed via yay)
│   └── README.md       ← What every package does
│
├── sddm/
│   ├── sddm.conf       ← SDDM config (uses YoRHa theme)
│   └── theme/          ← YoRHa SDDM login screen theme files
│
└── docs/
    ├── KEYBINDS.md     ← All keyboard shortcuts
    ├── THEMING.md      ← How the color system works
    ├── MUSIC.md        ← How to transfer/set up music
    └── MONITORS.md     ← How to set up monitors on a new machine
```

---

## The Desktop

| Component | Program |
|-----------|---------|
| Window Manager | Hyprland (Wayland, Lua config) |
| Status Bar | Waybar |
| Terminal | Kitty |
| Shell | Zsh + Oh My Zsh + Starship prompt |
| App Launcher | Rofi |
| Notifications | SwayNC |
| Login Screen | SDDM with YoRHa theme |
| File Manager | Nautilus + Yazi (terminal) |
| Browser | Zen Browser |

## The Rice

| Feature | Details |
|---------|---------|
| Theme | Snow-winter — dark background, orange amber accent |
| Colors | Material Design 3 via matugen (tonal-spot scheme, `#f68500` seed) |
| Waybar style | Solid rounded pill buttons |
| Font | JetBrains Mono Nerd Font |
| Icons | Papirus-Dark |

## Homepage Workspace (Workspace 1)

Press `SUPER + ALT + 1` to set up this layout:

```
┌─────────────────────┬───────────────┬──────────────┐
│                     │  tty-clock    │   pipes.sh   │
│        btop         ├───────────────┴──────────────┤
│                     │         cmatrix              │
└─────────────────────┴──────────────────────────────┘
                    [floating: fastfetch]
```

## Music Overlay (SUPER+M)

```
┌──────────────────────────────────────────────────────┐  ← waybar visible above
│                       rmpc                           │
├──────────────────────────────────────────────────────┤  ← gap
│                       cava                           │
└──────────────────────────────────────────────────────┘
```

## Keybinds

See [docs/KEYBINDS.md](docs/KEYBINDS.md) for the full list.
Most important:

| Key | Action |
|-----|--------|
| `SUPER + W` | Pick a theme preset |
| `SUPER + M` | Toggle music overlay |
| `SUPER + D` | App launcher |
| `SUPER + Return` | Terminal |
| `SUPER + L` | Lock screen |

---

## After Installing

1. **Fix monitor names** — see [docs/MONITORS.md](docs/MONITORS.md)
2. **Transfer music** — see [docs/MUSIC.md](docs/MUSIC.md)
3. **Apply a theme** — press `SUPER+W` and pick `snow-winter`
4. **Set up homepage** — press `SUPER+ALT+1` on workspace 1

---

## Updating Configs

When you change a config file on this machine, sync it back to the repo:

```bash
cd ~/frik-rice
# Configs are symlinked, so edits in ~/.config/ ARE edits in the repo
git add -A && git commit -m "update config" && git push
```

Then on the other machine:
```bash
cd ~/frik-rice && git pull
```
