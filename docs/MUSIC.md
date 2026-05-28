# Music Setup

The music library (6+ GB) is too large to store in this git repo.
Use the transfer script to copy it from the old machine over your local network.

---

## Transferring from Old Machine

### Step 1 — Enable SSH on the old machine (if not already running)

On the **old machine**, open a terminal and run:
```bash
sudo systemctl start sshd
ip addr show | grep 'inet '   # Note the IP address (e.g. 192.168.1.50)
```

### Step 2 — Run the transfer script on the new machine

On the **new machine**, from this repo:
```bash
bash transfer-music.sh 192.168.1.50
```

Replace `192.168.1.50` with the old machine's actual IP.

The transfer uses rsync, so:
- It shows progress per file
- You can stop and restart anytime — already-transferred files are skipped
- A 6GB library on a gigabit home network takes roughly 1–3 minutes

### Step 3 — Refresh MPD's library

After the transfer finishes:
```bash
mpc update
```
Or open rmpc and press `U` to rescan.

---

## Music Player Stack

| Component | Role |
|-----------|------|
| **MPD** | Background daemon that actually plays audio. Reads `~/Music/`. |
| **rmpc** | TUI interface for MPD. Open with `SUPER+M` (appears as the top overlay window). |
| **cava** | Audio visualizer. Open with `SUPER+M` (bottom overlay window). |
| **mpc** | Command-line MPD client used in scripts (e.g. shuffle, volume). |
| **playerctl** | Generic media controller — lets keyboard media keys work with MPD. |

### rmpc keybinds (when rmpc window is focused)

| Key | Action |
|-----|--------|
| `j` / `k` | Move down / up |
| `Enter` | Play selected song |
| `Space` | Add to queue |
| `d` | Delete from queue |
| `z` | Toggle random/shuffle |
| `r` | Toggle repeat |
| `p` | Pause / resume |
| `[` / `]` | Previous / next song |
| `+` / `-` | Volume up / down |
| `1`–`5` | Switch tabs (Queue, Browser, Search, Playlists, Artists) |

---

## MPD Config Location

MPD's config: `~/.config/mpd/mpd.conf`

It's set to read music from `~/Music/` and keep its database/state files in
`~/.config/mpd/`. The database file is NOT in this repo (it's auto-generated
when MPD scans your music folder).
