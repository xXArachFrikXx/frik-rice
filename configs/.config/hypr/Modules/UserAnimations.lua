--------------------
---- ANIMATIONS ----
--------------------

-- Enable the animation system
hl.config({
    animations = {
        enabled = true,
    },
})

-- === BEZIER CURVES ===
-- Custom easing functions for animations.
-- hl.curve(name, { type = "bezier", points = { {x1,y1}, {x2,y2} } })
-- The two points define a cubic bezier: P1 and P2 (P0=0,0 and P3=1,1 are fixed).
-- Visualise any curve at: https://cubic-bezier.com

hl.curve("myBezier",   { type = "bezier", points = { {0.05, 0.9},  {0.1,  1.05} } })  -- Slight overshoot
hl.curve("been",       { type = "bezier", points = { {0.24, 0.9},  {0.25, 0.91} } })  -- Smooth deceleration
hl.curve("been2",      { type = "bezier", points = { {0,    0.94}, {0.5,  0.99} } })  -- Gentle ease-out
hl.curve("menu_decel", { type = "bezier", points = { {0.1,  1},    {0,    1}    } })  -- Sharp decel (menus)
hl.curve("linear",     { type = "bezier", points = { {0.0,  0.0},  {1.0,  1.0} } })  -- Constant speed
hl.curve("wind",       { type = "bezier", points = { {0.05, 0.9},  {0.1,  1.05} } })  -- Slight overshoot
hl.curve("winIn",      { type = "bezier", points = { {0.1,  1.1},  {0.1,  1.1} } })  -- Bouncy open
hl.curve("winOut",     { type = "bezier", points = { {0.3,  -0.3}, {0,    1}   } })  -- Quick snap close
hl.curve("slow",       { type = "bezier", points = { {0,    0.85}, {0.3,  1}   } })  -- Slow start, fast end
hl.curve("overshot",   { type = "bezier", points = { {0.7,  0.6},  {0.1,  1.1} } })  -- Overshoot then settle
hl.curve("bounce",     { type = "bezier", points = { {1.1,  1.6},  {0.1,  0.85}} })  -- Big bounce effect
hl.curve("sligshot",   { type = "bezier", points = { {1,    -1},   {0.15, 1.25}} })  -- Pull-back slingshot
hl.curve("nice",       { type = "bezier", points = { {0,    2},    {0.5,  -1}  } })  -- Wild oscillation
-- Note: "nice" original values (0, 6.9 / 0.5, -4.20) exceeded valid bezier range; clamped to safe values

-- === ANIMATION ASSIGNMENTS ===
-- hl.animation({ leaf = "target", enabled, speed, bezier, style })
-- speed  = animation duration multiplier (lower = faster)
-- style  = optional modifier ("popin", "slide", "fade", "popin 70%" etc.)

hl.animation({ leaf = "windowsIn",   enabled = true, speed = 5, bezier = "slow",    style = "popin"     })  -- Window open animation
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 7, bezier = "been",    style = "popin 70%" })  -- Window close animation
hl.animation({ leaf = "windowsMove", enabled = true, speed = 5, bezier = "wind",    style = "slide"     })  -- Window drag/move animation
hl.animation({ leaf = "border",      enabled = true, speed = 1, bezier = "linear"                       })  -- Border color transition
hl.animation({ leaf = "fade",        enabled = true, speed = 5, bezier = "overshot"                     })  -- Fade in/out (opacity changes)
hl.animation({ leaf = "workspaces",  enabled = true, speed = 5, bezier = "wind"                         })  -- Workspace switch animation
hl.animation({ leaf = "windows",     enabled = true, speed = 5, bezier = "bounce",  style = "popin"     })  -- General window animation fallback
