-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
-- All commands here run once when Hyprland starts.
-- hl.exec_cmd() is the Lua equivalent of "exec-once" in the old .conf format.
-- waybar and swaync are killed first to prevent stacking on Hyprland reload.

hl.exec_cmd("nm-applet")                               -- Network Manager tray icon (wifi/ethernet)
hl.exec_cmd("bash -c 'pkill -x waybar; waybar'")       -- Status bar (kill first to prevent duplicate instances)
hl.exec_cmd("awww-daemon")                             -- Wallpaper daemon (awww = rebranded swww)
hl.exec_cmd("blueman-applet")                          -- Bluetooth tray icon
hl.exec_cmd("bash -c 'pkill swaync; swaync'")          -- Notification daemon (kill first to prevent stacking)
hl.exec_cmd("systemctl --user start hyprpolkitagent")  -- Polkit agent: handles permission popups (sudo GUI)
hl.exec_cmd("hypridle")                                -- Idle daemon: locks screen after inactivity
