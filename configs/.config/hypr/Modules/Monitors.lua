------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- hl.monitor() configures each physical display.
-- output   = port name (run `hyprctl monitors` to see yours)
-- mode     = resolution@refreshrate
-- position = x,y offset in pixels (arrange side-by-side, stacked, etc.)
-- scale    = DPI scaling factor (1 = 100%, 2 = 200% for HiDPI)

hl.monitor({
    output   = "HDMI-A-1",       -- Primary monitor on HDMI
    mode     = "1920x1080@144",  -- 1080p at 144Hz
    position = "1920x0",         -- Placed to the RIGHT of DP-1
    scale    = "1",
})

hl.monitor({
    output   = "DP-1",           -- Secondary monitor on DisplayPort
    mode     = "1920x1080@60",   -- 1080p at 60Hz
    position = "0x0",            -- Leftmost position
    scale    = "1",
})
