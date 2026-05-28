-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
-- hl.env() sets environment variables for all apps launched by Hyprland.
-- Equivalent to "env = NAME,value" in the old .conf format.

hl.env("XCURSOR_SIZE",    "24")  -- X11 cursor size (affects XWayland apps)
hl.env("HYPRCURSOR_SIZE", "24")  -- Hyprland native cursor size (affects Wayland apps)
