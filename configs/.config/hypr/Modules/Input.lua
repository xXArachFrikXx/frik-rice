---------------
---- INPUT ----
---------------

hl.config({
    input = {
        -- Keyboard layout settings
        kb_layout  = "us",  -- Keyboard layout (e.g. "us", "gb", "de")
        kb_variant = "",    -- Layout variant (e.g. "dvorak", "colemak")
        kb_model   = "",    -- Keyboard model (leave empty for default)
        kb_options = "",    -- Extra options (e.g. "caps:escape" to remap Caps Lock)
        kb_rules   = "",    -- XKB rules file (leave empty for default)

        follow_mouse  = 1,        -- 1 = keyboard focus follows mouse cursor
        sensitivity   = 0,        -- Mouse sensitivity: -1.0 to 1.0, 0 = no change
        accel_profile = "flat",   -- "flat" = no acceleration curve (raw 1:1 movement)
        force_no_accel = 1,       -- Force disable acceleration even if driver enables it

        touchpad = {
            natural_scroll = true,  -- Reverse scroll direction (Mac-style: finger down = page down)
        },
    },
})

-- Touchpad/trackpad gesture: swipe 3 fingers left/right to switch workspaces
-- https://wiki.hyprland.org/Configuring/Variables/#gestures
hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})

-- Per-device sensitivity override (leave name as-is unless you have this mouse)
-- Run `hyprctl devices` to find your device name
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})
