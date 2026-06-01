-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
-- All commands here run once when Hyprland starts.
-- hl.exec_cmd() is the Lua equivalent of "exec-once" in the old .conf format.
--
-- awww-daemon is managed by systemd (awww-daemon.service, WantedBy=default.target).
-- It auto-restarts until Hyprland exports WAYLAND_DISPLAY to the session.
-- Autostart.lua only restores the wallpaper once the daemon is up.

hl.exec_cmd("pkill -x rg")                                    -- Kill rg (ripgrep) if running
hl.exec_cmd("nm-applet")                                      -- Network Manager tray icon
hl.exec_cmd("blueman-applet")                                 -- Bluetooth tray icon
hl.exec_cmd("bash -c 'pkill swaync; swaync'")                 -- Notification daemon
hl.exec_cmd("systemctl --user start hyprpolkitagent")         -- Polkit agent (sudo GUI popups)
hl.exec_cmd("hypridle")                                       -- Idle/lock daemon

-- Waybar: short delay so compositor output is registered before waybar queries it
hl.exec_cmd("bash -c 'sleep 2; pkill -x waybar; waybar'")

-- Wallpaper restore: retry every second until awww-daemon accepts the command
hl.exec_cmd("bash -c 'for i in $(seq 1 60); do sleep 1; /usr/bin/awww img /home/Frik/.config/hypr/current_wallpaper 2>/dev/null && break; done'")

-- Homepage: runs after wallpaper and waybar have settled (waybar takes ~2s, wallpaper ~3-5s)
hl.exec_cmd("bash -c 'sleep 12; /home/Frik/.config/hypr/scripts/ws1-home.sh'")
