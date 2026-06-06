#!/bin/bash
# scheme-apply.sh — Apply a per-wallpaper color scheme to all apps.
# Usage: scheme-apply.sh <wallpaper-path>
#
# On first use for a wallpaper, generates a 31-color gruvbox-format scheme file
# in ~/.config/hypr/schemes/.  Edit that file to fine-tune colors, then re-run
# this script to propagate the changes.

WALLPAPER="${1:?Usage: scheme-apply.sh <wallpaper-path>}"
WALLPAPER="$(realpath "$WALLPAPER")"

SCRIPTS="$HOME/.config/hypr/scripts"
TEMPLATES="$HOME/.config/hypr/templates"
SCHEMES="$HOME/.config/hypr/schemes"
CONF="$HOME/.config"

BASENAME="$(basename "$WALLPAPER")"
SCHEME="$SCHEMES/$BASENAME.colors"

# Generate scheme if this wallpaper has never been themed before
if [[ ! -f "$SCHEME" ]]; then
    echo "Generating scheme for $BASENAME…"
    python3 "$SCRIPTS/scheme-gen.py" "$WALLPAPER" "$SCHEME"
fi

# Source the scheme so $red, $bg, etc. are available for cava patching
# shellcheck source=/dev/null
source "$SCHEME"

FILL="python3 $SCRIPTS/fill-template.py $SCHEME"

# === Distribute templates to app config locations ===
$FILL "$TEMPLATES/colors.css"            "$CONF/waybar/colors.css"
$FILL "$TEMPLATES/hyprland-colors.conf"  "$CONF/hypr/colors.conf"
$FILL "$TEMPLATES/hyprland-colors.lua"   "$CONF/hypr/Modules/colors.lua"
$FILL "$TEMPLATES/kitty-colors.conf"     "$CONF/kitty/colors.conf"
$FILL "$TEMPLATES/rofi-colors.rasi"      "$CONF/rofi/colors.rasi"
$FILL "$TEMPLATES/wal-gtk.css"           "$CONF/gtk-3.0/colors.css"
$FILL "$TEMPLATES/wal-gtk.css"           "$CONF/gtk-4.0/colors.css"
$FILL "$TEMPLATES/wal-btop.theme"        "$CONF/btop/themes/wpg.theme"
$FILL "$TEMPLATES/wal-wlogout.css"       "$CONF/wlogout/style.css"
$FILL "$TEMPLATES/wal-vesktop.css"       "$CONF/vesktop/themes/wpg.css"      2>/dev/null || true
$FILL "$TEMPLATES/wal-spicetify.ini"     "$CONF/spicetify/Themes/text/color.ini" 2>/dev/null || true
$FILL "$TEMPLATES/fastfetch-config.jsonc" "$CONF/fastfetch/config.jsonc"
$FILL "$TEMPLATES/rmpc-colors.ron"       "$CONF/rmpc/theme.ron"
$FILL "$TEMPLATES/eww-colors.scss"       "$CONF/eww/colors.scss"
$FILL "$TEMPLATES/yazi-theme.toml"       "$CONF/yazi/theme.toml"

# === Patch starship prompt accent1 in-place ===
sed -i \
    -e "s|\(bold \)#[0-9a-fA-F]*|\1$accent1|g" \
    "$CONF/starship.toml"

# === Patch tty-clock and cmatrix colors in-place ===
sed -i \
    -e "s|tty-clock -c -C [0-9]*|tty-clock -c -C $tty_clock_color|" \
    -e "s|cmatrix -a -b -C [a-z]*|cmatrix -a -b -C $cmatrix_color|" \
    "$SCRIPTS/ws1-home.sh"

# === Patch cava gradient: accent1 (bottom) → accent2 (top), middle 2 interpolated ===
read -r CAVA_1 CAVA_2 CAVA_3 CAVA_4 <<< "$(python3 - "$accent1" "$accent2" <<'PYEOF'
import sys, colorsys
def h2rgb(h): h=h.lstrip('#'); return tuple(int(h[i:i+2],16)/255 for i in (0,2,4))
def rgb2h(r,g,b): return '#{:02x}{:02x}{:02x}'.format(int(r*255),int(g*255),int(b*255))
def lerp(c1,c2,t):
    r1,g1,b1=h2rgb(c1); r2,g2,b2=h2rgb(c2)
    return rgb2h(r1+(r2-r1)*t, g1+(g2-g1)*t, b1+(b2-b1)*t)
a,b=sys.argv[1],sys.argv[2]
print(a, lerp(a,b,0.33), lerp(a,b,0.66), b)
PYEOF
)"
sed -i \
    -e "s|gradient_color_1 = '#[0-9a-fA-F]*'|gradient_color_1 = '$CAVA_1'|" \
    -e "s|gradient_color_2 = '#[0-9a-fA-F]*'|gradient_color_2 = '$CAVA_2'|" \
    -e "s|gradient_color_3 = '#[0-9a-fA-F]*'|gradient_color_3 = '$CAVA_3'|" \
    -e "s|gradient_color_4 = '#[0-9a-fA-F]*'|gradient_color_4 = '$CAVA_4'|" \
    "$CONF/cava/config"

# === Reload apps ===
pkill -SIGUSR2 waybar 2>/dev/null || true
pkill swaync 2>/dev/null || true; sleep 0.2; swaync &
kill -SIGUSR1 "$(pidof kitty)" 2>/dev/null || true
gsettings set org.gnome.desktop.interface color-scheme 'default'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
pkill -USR1 cava 2>/dev/null || true
pkill -SIGUSR1 btop 2>/dev/null || true
eww reload 2>/dev/null || true
