------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- hl.monitor() configures each physical display.
-- output   = port name (run `hyprctl monitors` to see yours), or "preferred" to auto-detect all
-- mode     = resolution@refreshrate, or "preferred" for each monitor's native best mode
-- position = x,y offset in pixels, or "auto" to let Hyprland arrange side by side
-- scale    = DPI scaling factor (1 = 100%, 2 = 200% for HiDPI)

-- AUTO-DETECT: works on any machine with 1 or more monitors.
-- Hyprland picks each monitor's best resolution/refresh rate and arranges them.
-- After logging in, run `hyprctl monitors` to see your actual port names.
-- To lock in specific resolutions, refresh rates, or positions, replace this
-- with per-monitor blocks — see docs/MONITORS.md for examples.
hl.monitor({
    output   = "preferred",
    mode     = "preferred",
    position = "auto",
    scale    = "1",
})
