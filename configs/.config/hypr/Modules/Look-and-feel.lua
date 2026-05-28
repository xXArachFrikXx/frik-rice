-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Load wallpaper-generated Material Design 3 colors (written by matugen on each wallpaper change)
local colors = require("Modules/colors")

hl.config({
    general = {
        gaps_in  = 10,   -- Gap size between tiled windows (pixels)
        gaps_out = 20,  -- Gap between windows and screen edge (pixels)

        border_size = 2,  -- Window border thickness (pixels)

        col = {
            active_border   = colors.outline,         -- Border color of the focused window
            inactive_border = colors.outline_variant, -- Border color of unfocused windows
        },

        resize_on_border = false,  -- If true, you can resize windows by dragging the border
        allow_tearing    = false,  -- Screen tearing (only enable if you need lowest latency gaming)
        layout           = "dwindle",  -- Tiling layout: "dwindle" (spiral) or "master"
    },

    decoration = {
        rounding       = 10,  -- Window corner rounding (pixels); 0 = square corners
        rounding_power = 2,   -- Controls the curve shape of rounded corners (higher = rounder)

        active_opacity   = 0.8,  -- Opacity of the focused window
        inactive_opacity = 0.8,  -- Opacity of unfocused windows

        shadow = {
            enabled      = false,       -- Drop shadow under windows (disabled for performance)
            range        = 4,           -- Shadow blur radius
            render_power = 3,           -- Shadow intensity (higher = darker)
            color        = "rgba(1a1a1aee)",  -- Shadow color
        },

        blur = {
            enabled           = true,   -- Blur the content behind transparent windows
            size              = 5,      -- Blur kernel size (higher = more blur, more GPU usage)
            passes            = 3,      -- Number of blur passes (more = smoother blur)
            ignore_opacity    = true,   -- Apply blur even if window opacity is 1.0 (for layerrules)
            new_optimizations = true,   -- Use optimized blur algorithm (keep this true)
            special           = false,  -- Blur the special/scratchpad workspace
            popups            = true,   -- Blur popup windows (tooltips, context menus)
            xray              = true,   -- Windows on top don't block the blur of windows below
            vibrancy          = 0.1696, -- Color vibrancy boost for blurred areas
        },
    },
})
