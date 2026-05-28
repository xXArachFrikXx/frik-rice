# Package List

These files list every package installed on Frik's system.
The install script reads them and skips anything already present.

- `pacman.txt` — official Arch Linux repository packages
- `aur.txt`    — AUR (community) packages, installed via yay

---

## What Each Package Does

### Core System
| Package | What it does |
|---------|-------------|
| `base` `base-devel` | Minimal Arch base + build tools (gcc, make, etc.) |
| `linux` `linux-firmware` `linux-headers` | The kernel and hardware firmware |
| `amd-ucode` | AMD CPU microcode updates (stability/security patches) |
| `grub` `efibootmgr` | UEFI bootloader |
| `sudo` | Allow running commands as root |
| `networkmanager` | Network management (WiFi, Ethernet) |
| `reflector` | Automatically sorts pacman mirrors by speed |
| `man-db` `man-pages` | Manual pages (`man ls`, etc.) |

### GPU (NVIDIA)
| Package | What it does |
|---------|-------------|
| `nvidia-open-dkms` | Open-source NVIDIA kernel module (for RTX 20xx+) |
| `nvidia-utils` | NVIDIA userspace utilities |
| `lib32-libxcomposite` | 32-bit compositing library (needed for some Wine/Steam games) |

### Desktop (Hyprland)
| Package | What it does |
|---------|-------------|
| `hyprland` | The Wayland compositor / window manager |
| `hyprlock` | Lock screen for Hyprland |
| `hyprpaper` | Wallpaper setter (used by the wallpaper picker script) |
| `hyprshot` | Screenshot tool (SUPER+SHIFT+S) |
| `xdg-desktop-portal-hyprland` | Allows apps to request file pickers, screen share, etc. |
| `waybar` | The status bar at the top of the screen |
| `swaync` | Notification center (click the bell icon in waybar) |
| `sddm` | Login screen / display manager |
| `wlogout` | The logout/shutdown/reboot screen (SUPER+SHIFT+Q or the power button) |
| `rofi` | App launcher and picker menus (SUPER+D) |
| `mako` | Simple notification daemon (fallback) |

### Terminal & Shell
| Package | What it does |
|---------|-------------|
| `kitty` | The terminal emulator |
| `zsh` | The shell (better than bash) |
| `zsh-autosuggestions` | Shows command suggestions as you type |
| `zsh-syntax-highlighting` | Colors commands while typing (red = invalid) |
| `starship` | The fancy prompt showing user@host, directory, git status |
| `tmux` | Terminal multiplexer (multiple panes in one terminal) |
| `neovim` | Terminal text editor |
| `yazi` | Terminal file manager with image preview (SUPER+SHIFT+E) |

### System Monitoring & Info
| Package | What it does |
|---------|-------------|
| `btop` | Beautiful system monitor (CPU, RAM, disk, network) — on homepage workspace |
| `fastfetch` | System info display shown on terminal open |

### Music Player Stack
| Package | What it does |
|---------|-------------|
| `mpd` | Music Player Daemon — runs in background, plays the music |
| `rmpc` | TUI frontend for MPD — the actual music player interface (SUPER+M) |
| `mpc` | Command-line MPD client (used in scripts) |
| `cava` | Audio visualizer shown in the music overlay (SUPER+M) |
| `playerctl` | Controls any media player from the keyboard (media keys) |
| `picard` | MusicBrainz Picard — tags and organizes your music library |

### Theming
| Package | What it does |
|---------|-------------|
| `matugen` | Generates a full color palette from a wallpaper or hex color |
| `papirus-icon-theme` | Icon set used by Nautilus and GTK apps |
| `ttf-jetbrains-mono-nerd` | The main font used in the terminal and waybar |
| `ttf-nerd-fonts-symbols` | Nerd Font symbol glyphs (icons in waybar, fastfetch, etc.) |
| `awww` (AUR) | Wallpaper setter with smooth transitions (fork of swww) |

### Eye Candy (Homepage Workspace)
| Package | What it does |
|---------|-------------|
| `cmatrix` | The Matrix green rain effect |
| `pipes.sh` (AUR) | Animated pipes screensaver |
| `tty-clock` (AUR) | Big digital clock in the terminal |

### Applications
| Package | What it does |
|---------|-------------|
| `nautilus` | GNOME file manager |
| `pavucontrol` | PulseAudio volume mixer GUI |
| `obsidian` | Markdown note-taking app |
| `freetube` (AUR) | YouTube client without tracking |
| `zen-browser-bin` (AUR) | Firefox-based privacy-focused browser |
| `vesktop` (AUR) | Discord client with better Wayland support |
| `vscodium` (AUR) | VS Code without Microsoft telemetry |
| `steam` | Steam gaming platform |

### Wine / Windows Compatibility
| Package | What it does |
|---------|-------------|
| `wine-staging` | Run Windows programs on Linux |
| `winetricks` | Helper for installing Windows libraries in Wine |
| `cabextract` | Extract Windows Cabinet files (needed by winetricks) |

### Utilities
| Package | What it does |
|---------|-------------|
| `git` | Version control |
| `github-cli` | GitHub from the terminal |
| `wget` | Download files from the terminal |
| `wl-clipboard` | Clipboard for Wayland (`wl-copy`, `wl-paste`) |
| `xclip` `wmctrl` | X11 clipboard/window utilities (for some apps) |
| `openbsd-netcat` | Network utility |
| `pipewire-alsa` `pipewire-pulse` | PipeWire compatibility layers for audio |

### Qt libraries (needed by some apps)
| Package | What it does |
|---------|-------------|
| `qt5-graphicaleffects` `qt5-quickcontrols2` `qt5-multimedia` `qt5-svg` | Qt5 runtime libs for SDDM and other Qt apps |

### Misc AUR
| Package | What it does |
|---------|-------------|
| `python-spotipy` `python-spotapi` etc. | Python libs for Spotify/SoundCloud downloading tools |
| `lib-tls-client-git` | TLS client lib dependency |
| `ex-vi-compat` | Vi compatibility shim |
