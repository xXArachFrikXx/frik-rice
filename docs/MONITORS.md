# Monitor Setup

Out of the box, Hyprland auto-detects all connected monitors and picks their
best resolution and refresh rate. You don't need to touch anything for a
single-monitor setup — it just works.

---

## Find Your Monitor Names

After logging into Hyprland, open a terminal and run:
```bash
hyprctl monitors
```

You'll see output like:
```
Monitor HDMI-A-1 (ID 0): 1920x1080@144Hz at 0x0 ...
Monitor DP-1 (ID 1): 1920x1080@60Hz at 1920x0 ...
```

The name before the parenthesis (`HDMI-A-1`, `DP-1`, etc.) is what you use in
the config. Names differ between machines and GPUs.

---

## Lock In Specific Settings (optional)

If you want exact resolution, refresh rate, or monitor positions, edit
`~/.config/hypr/Modules/Monitors.lua` and replace the auto-detect block with
per-monitor entries:

```lua
-- Example: two monitors, HDMI primary at 144Hz, DP secondary at 60Hz
hl.monitor({
    output   = "HDMI-A-1",
    mode     = "1920x1080@144",
    position = "1920x0",   -- to the right of DP-1
    scale    = "1",
})
hl.monitor({
    output   = "DP-1",
    mode     = "1920x1080@60",
    position = "0x0",
    scale    = "1",
})
```

---

## Pin Workspaces to Monitors (optional)

By default workspaces float freely between monitors. To lock workspaces 1–5
to the left monitor and 6–10 to the right, add monitor assignments to
`~/.config/hypr/Modules/WindowsWorkspace.lua`:

```lua
hl.workspace_rule({ workspace = "1",  monitor = "HDMI-A-1", default = true, on_created_empty = "exec:~/.config/hypr/scripts/ws1-home.sh" })
hl.workspace_rule({ workspace = "2",  monitor = "HDMI-A-1", default = true })
hl.workspace_rule({ workspace = "3",  monitor = "HDMI-A-1", default = true })
hl.workspace_rule({ workspace = "4",  monitor = "HDMI-A-1", default = true })
hl.workspace_rule({ workspace = "5",  monitor = "HDMI-A-1", default = true })
hl.workspace_rule({ workspace = "6",  monitor = "DP-1",     default = true })
hl.workspace_rule({ workspace = "7",  monitor = "DP-1",     default = true })
hl.workspace_rule({ workspace = "8",  monitor = "DP-1",     default = true })
hl.workspace_rule({ workspace = "9",  monitor = "DP-1",     default = true })
hl.workspace_rule({ workspace = "10", monitor = "DP-1",     default = true })
```

Replace `HDMI-A-1` and `DP-1` with your actual monitor names from `hyprctl monitors`.
