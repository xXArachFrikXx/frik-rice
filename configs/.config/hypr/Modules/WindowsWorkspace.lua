--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- hl.window_rule() applies rules to windows matching the given criteria.
-- match = { class, title, tag, xwayland, float, fullscreen, pin } — any combination
-- See all options: https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- hl.layer_rule() applies rules to overlay layers (waybar, rofi, swaync, etc.)
-- match = { namespace } — use the layer's namespace string

-- hl.workspace_rule() pins workspaces to specific monitors.
-- See: https://wiki.hypr.land/Configuring/Workspace-Rules/

-- === GLOBAL FIXES ===

-- Prevent apps from maximizing themselves (keeps window management predictable)
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix XWayland drag-and-drop ghost windows stealing focus
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- === TAGS ===
-- Tags group windows so rules can target entire categories instead of listing every app class.
-- A window can have multiple tags. Tags are prefixed with "+" to add (never replaces).

hl.window_rule({ name = "tag-multimedia", match = { class = "^([Mm]pv|vlc)$" },                                            tag = "+multimedia_video" })
hl.window_rule({ name = "tag-settings-1", match = { class = "^(nm-applet|nm-connection-editor|blueman-manager|org.gnome.FileRoller)$" }, tag = "+settings" })
hl.window_rule({ name = "tag-settings-2", match = { class = "^(org.gnome.DiskUtility|wihotspot(-gui)?)$" },                 tag = "+settings" })
hl.window_rule({ name = "tag-viewer-sys", match = { class = "^(org.gnome.SystemMonitor)$" },                                tag = "+viewer" })  -- System monitor
hl.window_rule({ name = "tag-viewer-doc", match = { class = "^(org.gnome.Evince)$" },                                       tag = "+viewer" })  -- PDF viewer
hl.window_rule({ name = "tag-viewer-img", match = { class = "^(eog|org.gnome.Loupe)$" },                                    tag = "+viewer" })  -- Image viewer

-- === OPACITY & BLUR RULES ===
-- opacity values: single number applies to all states
-- "active override inactive override fullscreen override" = separate values per focus state

hl.window_rule({ name = "noblur-video",     match = { tag = "multimedia_video*" }, no_blur = true })         -- Video players: disable blur (visual artifact behind video)
hl.window_rule({ name = "opacity-video",    match = { tag = "multimedia_video*" }, opacity = 1.0 })          -- Video players: always fully opaque
hl.window_rule({ name = "opacity-settings", match = { tag = "settings*" },         opacity = 0.8 })          -- Settings windows: slight transparency
hl.window_rule({ name = "opacity-nautilus", match = { class = "^(org.gnome.Nautilus)$" }, opacity = 0.8 })   -- File manager: slight transparency
hl.window_rule({ name = "opacity-editors",  match = { class = "^(gedit|org.gnome.TextEditor|mousepad)$" }, opacity = 0.9 })
hl.window_rule({ name = "opacity-pavu",     match = { class = "^(org.pulseaudio.pavucontrol)$" }, opacity = 0.9 })  -- Volume mixer
hl.window_rule({ name = "opacity-kitty",    match = { class = "^(kitty)$" },       opacity = 0.9 })          -- Terminal: slight transparency
hl.window_rule({ name = "opacity-chat",     match = { class = "^(discord|vesktop|org.telegram.desktop)$" }, opacity = "0.85 override 0.7 override 1 override" })  -- Chat apps
hl.window_rule({ name = "opacity-spotify",  match = { class = "^(Spotify)$" },     opacity = "0.8 override 0.6 override 1 override" })
hl.window_rule({ name = "opacity-zen",      match = { class = "^(zen)$" },         opacity = "0.9 override 0.7 override 1 override" })  -- Zen browser

-- === FLOAT & SIZE RULES ===

hl.window_rule({ name = "float-settings",   match = { tag = "settings*" }, float = true })
hl.window_rule({ name = "float-viewer",     match = { tag = "viewer*" },   float = true })
hl.window_rule({ name = "float-video",      match = { tag = "multimedia_video*" }, float = true, size = "900 506" })  -- 16:9 at 900px wide
hl.window_rule({ name = "float-pavu",       match = { class = "^(org.pulseaudio.pavucontrol)$" }, float = true, size = "50% 60%" })

-- File save/open dialogs: float, center, reasonable size
hl.window_rule({ name = "dialogs",    match = { title = "^(Save As|Save a File|Pick Files)$" }, float = true, size = "50% 60%", center = true })
hl.window_rule({ name = "open-files", match = { title = "(Open Files)" },                        float = true, size = "70% 60%" })

-- Music overlay: two separate floating windows (rmpc top, cava bottom), above waybar with side margins
hl.window_rule({
    name  = "rmpc-overlay",
    match = { class = "^kitty-rmpc-overlay$" },
    float = true,
    size  = "1880 640",
    move  = "20 56",
})
hl.window_rule({
    name  = "cava-overlay",
    match = { class = "^kitty-cava-overlay$" },
    float = true,
    size  = "1880 360",
    move  = "20 716",
})

-- Homepage windows: each pinned to workspace 1
hl.window_rule({ name = "homepage-btop",     match = { class = "^kitty-btop$" },     workspace = "1 silent" })
hl.window_rule({ name = "homepage-cmatrix",  match = { class = "^kitty-cmatrix$" },  workspace = "1 silent" })
hl.window_rule({ name = "homepage-clock",    match = { class = "^kitty-clock$" },    workspace = "1 silent" })
hl.window_rule({ name = "homepage-pipes",    match = { class = "^kitty-pipes$" },    workspace = "1 silent" })
hl.window_rule({ name = "homepage-fastfetch", match = { class = "^kitty-fastfetch$" }, float = true, size = "900 640", center = true, workspace = "1 silent" })

-- === LAYER RULES ===
-- These apply to compositor overlay layers, not regular windows.

hl.layer_rule({ name = "waybar-blur",   match = { namespace = "waybar" },          blur = true, ignore_alpha = 0.5 })  -- Blur through waybar
hl.layer_rule({ name = "notif-alpha",   match = { tag = "notif*" },                ignore_alpha = 0.5 })
hl.layer_rule({ name = "logout-blur",   match = { namespace = "logout_dialog" },   blur = false })  -- wlogout: no blur so bright wallpaper doesn't bleed through

-- SwayNC (notification center) blur
hl.layer_rule({ name = "swaync-cc-blur",  match = { namespace = "swaync-control-center" },       blur = true, ignore_alpha = 0.5, xray = 0 })
hl.layer_rule({ name = "swaync-win-blur", match = { namespace = "swaync-notification-window" },  blur = true, ignore_alpha = 0.5, xray = 0 })

-- === WORKSPACE RULES ===
-- Workspace 1 auto-opens the homepage layout on first use.
-- No monitor = "..." assignment here — workspaces float freely between monitors.
-- This works correctly on single-monitor setups and lets multi-monitor setups
-- choose which workspace lives where manually.
-- To pin workspaces to specific monitors, add: monitor = "HDMI-A-1" (or your port name).
-- Run `hyprctl monitors` inside Hyprland to see your actual port names.

hl.workspace_rule({ workspace = "1",  on_created_empty = "exec:~/.config/hypr/scripts/ws1-home.sh" })
