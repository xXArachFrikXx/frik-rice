# Monitor Setup

The monitor configuration needs to be updated for the new machine since
monitor connector names differ between systems.

---

## Current Setup (original machine)

- Monitor 1: `HDMI-A-1` — main monitor, workspaces 1–5
- Monitor 2: `DP-1` — secondary monitor, workspaces 6–10

---

## How to Find Your Monitor Names

After logging into Hyprland, open a terminal and run:
```bash
hyprctl monitors
```

Look for lines like:
```
Monitor HDMI-A-1 (ID 0): 1920x1080 at 0x0 ...
Monitor DP-1 (ID 1): 1920x1080 at 1920x0 ...
```

---

## Where to Edit

Open `~/.config/hypr/Modules/Monitors.lua` and update the monitor names.
Also update `~/.config/hypr/Modules/WindowsWorkspace.lua` — the workspace rules
at the bottom use the same monitor names to pin workspaces 1–5 and 6–10.

---

## Single Monitor Setup

If you only have one monitor, in `WindowsWorkspace.lua` change all workspace rules
to use your single monitor name:
```lua
hl.workspace_rule({ workspace = "1",  monitor = "YOUR-MONITOR-NAME", default = true })
-- repeat for 2–10
```
