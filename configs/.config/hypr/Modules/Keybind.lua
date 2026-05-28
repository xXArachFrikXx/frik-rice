---------------------
---- MY PROGRAMS ----
---------------------

-- Change these to your preferred apps
local terminal    = "kitty"       -- Terminal emulator
local fileManager = "nautilus"    -- File manager
local menu        = "rofi -show drun"  -- App launcher (drun = desktop app list)

---------------------
---- KEYBINDINGS ----
---------------------

-- SUPER = Windows key (also called "Meta" or "Mod4")
local mainMod = "SUPER"

-- === CORE APPLICATIONS & WINDOW MANAGEMENT ===
hl.bind(mainMod .. " + Return",       hl.dsp.exec_cmd(terminal))                                                    -- Open terminal
hl.bind(mainMod .. " + SHIFT + RETURN", hl.dsp.exec_cmd("[float; size 800 550] " .. terminal))                     -- Open floating terminal
hl.bind(mainMod .. " + C",            hl.dsp.window.close())                                                        -- Close focused window
hl.bind("CTRL + ALT + Delete",        hl.dsp.exec_cmd("hyprctl dispatch exit 0"))                                   -- Exit Hyprland entirely
hl.bind(mainMod .. " + E",            hl.dsp.exec_cmd(fileManager))                                                 -- Open file manager
hl.bind(mainMod .. " + Space",        hl.dsp.window.float({ action = "toggle" }))                                   -- Toggle floating on focused window
hl.bind(mainMod .. " + D",            hl.dsp.exec_cmd(menu))                                                        -- Open app launcher (rofi)
hl.bind(mainMod .. " + P",            hl.dsp.window.pseudo())                                                       -- Toggle pseudo-tile (dwindle layout)
hl.bind(mainMod .. " + J",            hl.dsp.layout("togglesplit"))                                                      -- Toggle dwindle split direction
hl.bind(mainMod .. " + R",            hl.dsp.exec_cmd("~/.config/hypr/scripts/wbrestart.sh"))                       -- Restart waybar + swaync
hl.bind(mainMod .. " + B",            hl.dsp.exec_cmd("xdg-open 'https://'"))                                       -- Open default browser
hl.bind(mainMod .. " + L",            hl.dsp.exec_cmd("~/.config/hypr/scripts/hyprlock.sh"))                        -- Lock screen
hl.bind(mainMod .. " + SHIFT + F",    hl.dsp.window.fullscreen())                                                   -- Toggle fullscreen
hl.bind(mainMod .. " + SHIFT + S",    hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh"))                      -- Screenshot (region select)
hl.bind(mainMod .. " + W",            hl.dsp.exec_cmd("~/.config/hypr/scripts/PresetPicker.sh"))                    -- Theme preset picker (rofi menu)
hl.bind(mainMod .. " + ALT + W",      hl.dsp.exec_cmd("~/.config/hypr/scripts/wppicker.sh"))                        -- Wallpaper picker (rofi thumbnail menu)
hl.bind(mainMod .. " + SHIFT + Q",    hl.dsp.exec_cmd("~/.config/hypr/scripts/KillActiveProcess.sh"))               -- Force-kill active window's process
hl.bind(mainMod .. " + SHIFT + W",    hl.dsp.exec_cmd("~/.config/hypr/scripts/WaybarTheme.sh"))                    -- Waybar theme picker (layout + style in one)
hl.bind(mainMod .. " + M",            hl.dsp.exec_cmd("~/.config/hypr/scripts/music-overlay.sh"))                     -- Toggle music overlay (rmpc + cava)
hl.bind(mainMod .. " + ALT + 1",      hl.dsp.exec_cmd("~/.config/hypr/scripts/ws1-home.sh"))                          -- Reset workspace 1 homepage layout
hl.bind(mainMod .. " + CTRL + B",     hl.dsp.exec_cmd("~/.config/hypr/scripts/WaybarStyles.sh"))                    -- Waybar style selector menu
hl.bind(mainMod .. " + ALT + B",      hl.dsp.exec_cmd("~/.config/hypr/scripts/WaybarLayout.sh"))                    -- Waybar layout selector menu
hl.bind(mainMod .. " + H",            hl.dsp.exec_cmd("pkill -SIGUSR1 waybar"))                                     -- Hide/show waybar
hl.bind(mainMod .. " + SHIFT + E",    hl.dsp.exec_cmd("kitty yazi"))                                                -- Open Yazi file manager in terminal

-- === FOCUS MOVEMENT ===
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left"  }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up"    }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down"  }))

-- === MOVE WINDOWS ===
hl.bind(mainMod .. " + CTRL + left",  hl.dsp.window.move({ direction = "left"  }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + CTRL + up",    hl.dsp.window.move({ direction = "up"    }))
hl.bind(mainMod .. " + CTRL + down",  hl.dsp.window.move({ direction = "down"  }))

-- === RESIZE WINDOWS ===
-- { repeating = true } allows holding the key for continuous resizing
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.exec_cmd("hyprctl dispatch resizeactive -50 0"),  { repeating = true })
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 50 0"),   { repeating = true })
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 -50"),  { repeating = true })
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 50"),   { repeating = true })

-- === WORKSPACES ===
-- Loop generates binds for workspaces 1-10. Key "0" maps to workspace 10.
for i = 1, 10 do
    local key = i % 10  -- Workspace 10 uses the "0" key
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))           -- Switch to workspace N
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))     -- Move window to workspace N
end

-- Scroll through workspaces with mouse wheel (hold SUPER)
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))  -- Next workspace
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))  -- Previous workspace

-- === MOUSE WINDOW CONTROLS ===
-- { mouse = true } marks this as a mouse button bind (not a keyboard key)
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })  -- SUPER + Left click = drag window
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })  -- SUPER + Right click = resize window

-- === MULTIMEDIA KEYS ===
-- { locked = true } means the bind works even on the lock screen
-- { repeating = true } allows holding the key for continuous action
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("~/.config/hypr/scripts/volume.sh --inc"),          { locked = true, repeating = true })  -- Volume up
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("~/.config/hypr/scripts/volume.sh --dec"),          { locked = true, repeating = true })  -- Volume down
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("~/.config/hypr/scripts/volume.sh --toggle"),       { locked = true, repeating = true })  -- Mute toggle
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),    { locked = true, repeating = true })  -- Mic mute toggle
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("~/.config/hypr/scripts/brightness.sh --inc"),      { locked = true, repeating = true })  -- Brightness up
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("~/.config/hypr/scripts/brightness.sh --dec"),      { locked = true, repeating = true })  -- Brightness down

-- === MEDIA PLAYER CONTROLS (playerctl) ===
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),        { locked = true })  -- Next track
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"),  { locked = true })  -- Play/pause toggle
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"),  { locked = true })  -- Play/pause toggle
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),    { locked = true })  -- Previous track
