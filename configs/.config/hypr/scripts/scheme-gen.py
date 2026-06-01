#!/usr/bin/env python3
"""Generate a 31-color gruvbox-format scheme from a wallpaper using pywal."""

import colorsys
import json
import os
import subprocess
import sys
from datetime import date
from pathlib import Path


def hex_to_hsv(h: str) -> tuple[float, float, float]:
    h = h.lstrip("#")
    r, g, b = int(h[0:2], 16) / 255, int(h[2:4], 16) / 255, int(h[4:6], 16) / 255
    return colorsys.rgb_to_hsv(r, g, b)


def hsv_to_hex(hh: float, s: float, v: float) -> str:
    r, g, b = colorsys.hsv_to_rgb(hh, s, v)
    return "#{:02x}{:02x}{:02x}".format(int(r * 255), int(g * 255), int(b * 255))


def darken(color: str, amount: float) -> str:
    hh, s, v = hex_to_hsv(color)
    return hsv_to_hex(hh, s, max(0.0, v - amount))


def lighten(color: str, amount: float) -> str:
    hh, s, v = hex_to_hsv(color)
    return hsv_to_hex(hh, s, min(1.0, v + amount))


def lerp_hex(c1: str, c2: str, t: float) -> str:
    h1, h2 = c1.lstrip("#"), c2.lstrip("#")
    r = int(h1[0:2], 16) + t * (int(h2[0:2], 16) - int(h1[0:2], 16))
    g = int(h1[2:4], 16) + t * (int(h2[2:4], 16) - int(h1[2:4], 16))
    b = int(h1[4:6], 16) + t * (int(h2[4:6], 16) - int(h1[4:6], 16))
    return "#{:02x}{:02x}{:02x}".format(int(r), int(g), int(b))


def hue_dist(h1: float, h2: float) -> float:
    """Angular distance between two hues (both in [0,1])."""
    d = abs(h1 - h2)
    return min(d, 1.0 - d)


def shift_hue(color: str, target_h: float) -> str:
    """Return color with hue replaced by target_h, preserving S and V."""
    _, s, v = hex_to_hsv(color)
    return hsv_to_hex(target_h, s, v)


def assign_by_hue(accents: list[str]) -> dict[str, str]:
    """Assign 6 extracted colors to 7 gruvbox accent names by nearest hue.
    One name is always derived via hue-shift of its nearest neighbour."""
    targets = [
        ("red",    0.0 / 360),
        ("orange", 30.0 / 360),
        ("yellow", 60.0 / 360),
        ("green",  120.0 / 360),
        ("aqua",   180.0 / 360),
        ("blue",   240.0 / 360),
        ("purple", 300.0 / 360),
    ]
    color_hues = [(c, hex_to_hsv(c)[0]) for c in accents]
    available = list(color_hues)
    assigned: dict[str, str] = {}

    for name, target_h in targets:
        if not available:
            break
        best = min(available, key=lambda ch: hue_dist(ch[1], target_h))
        assigned[name] = best[0]
        available.remove(best)

    # Derive missing name(s) by hue-shifting the nearest already-assigned color
    for name, target_h in targets:
        if name not in assigned:
            nearest_color = min(
                assigned.values(),
                key=lambda c: hue_dist(hex_to_hsv(c)[0], target_h),
            )
            assigned[name] = shift_hue(nearest_color, target_h)

    return assigned


def mix_hue(c1: str, c2: str, ratio: float = 0.5) -> str:
    """Blend two colors by averaging their hues and interpolating S/V."""
    h1, s1, v1 = hex_to_hsv(c1)
    h2, s2, v2 = hex_to_hsv(c2)
    dh = h2 - h1
    if dh > 0.5:
        dh -= 1.0
    if dh < -0.5:
        dh += 1.0
    hh = (h1 + dh * ratio) % 1.0
    s = s1 * (1 - ratio) + s2 * ratio
    v = v1 * (1 - ratio) + v2 * ratio
    return hsv_to_hex(hh, s, v)


def main() -> None:
    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} <wallpaper_path> <output_scheme_path>", file=sys.stderr)
        sys.exit(1)

    wallpaper = str(Path(sys.argv[1]).resolve())
    output = sys.argv[2]

    # Generate palette with pywal (exit code may be non-zero if wallpaper daemon
    # is unavailable, but colors.json is still written — that's all we need)
    subprocess.run(
        ["wal", "-i", wallpaper, "--backend", "colorthief", "-q"],
        check=False,
    )

    # Read extracted colors
    cache_colors = Path.home() / ".cache" / "wal" / "colors.json"
    with open(cache_colors) as f:
        data = json.load(f)

    c = [data["colors"][f"color{i}"] for i in range(16)]

    # === Map 16 pywal colors → 31 gruvbox colors ===
    bg     = c[0]
    bg_h   = darken(bg, 0.15)
    bg_s   = lighten(bg, 0.05)
    bg0    = bg
    bg1    = lerp_hex(bg0, c[8], 0.3)
    bg2    = lerp_hex(bg0, c[8], 0.6)
    bg3    = c[8]
    bg4    = lighten(c[8], 0.10)

    gray0  = lerp_hex(c[8], c[7], 0.33)
    gray1  = lerp_hex(c[8], c[7], 0.66)
    gray2  = c[7]

    fg     = c[15]
    fg0    = c[15]
    fg1    = lerp_hex(c[7], c[15], 0.80)
    fg2    = lerp_hex(c[7], c[15], 0.60)
    fg3    = lerp_hex(c[7], c[15], 0.40)
    fg4    = c[7]

    dark_accents = assign_by_hue(c[1:7])
    dark_red    = dark_accents["red"]
    dark_green  = dark_accents["green"]
    dark_yellow = dark_accents["yellow"]
    dark_blue   = dark_accents["blue"]
    dark_purple = dark_accents["purple"]
    dark_aqua   = dark_accents["aqua"]
    dark_orange = dark_accents["orange"]

    bright_accents = assign_by_hue(c[9:15])
    red    = bright_accents["red"]
    green  = bright_accents["green"]
    yellow = bright_accents["yellow"]
    blue   = bright_accents["blue"]
    purple = bright_accents["purple"]
    aqua   = bright_accents["aqua"]
    orange = bright_accents["orange"]

    colors = {
        "bg":          bg,
        "bg_h":        bg_h,
        "bg_s":        bg_s,
        "bg0":         bg0,
        "bg1":         bg1,
        "bg2":         bg2,
        "bg3":         bg3,
        "bg4":         bg4,
        "gray0":       gray0,
        "gray1":       gray1,
        "gray2":       gray2,
        "fg":          fg,
        "fg0":         fg0,
        "fg1":         fg1,
        "fg2":         fg2,
        "fg3":         fg3,
        "fg4":         fg4,
        "dark_red":    dark_red,
        "dark_green":  dark_green,
        "dark_yellow": dark_yellow,
        "dark_blue":   dark_blue,
        "dark_purple": dark_purple,
        "dark_aqua":   dark_aqua,
        "dark_orange": dark_orange,
        "red":         red,
        "green":       green,
        "yellow":      yellow,
        "blue":        blue,
        "purple":      purple,
        "aqua":        aqua,
        "orange":      orange,
        "white":       "#ffffff",
        "black":       "#000000",
        "kitty_fg":    fg,
        "accent":         orange,
        "btop_lines":     orange,
        "btop_dividers":  bg3,
        "btop_text":      gray2,
        "btop_proc":      fg,
        "btop_low":       dark_aqua,
        "btop_mid":       dark_yellow,
        "btop_high":      red,
        "cava_1":      red,
        "cava_2":      dark_red,
        "cava_3":      orange,
        "cava_4":      yellow,
        "logo_color":  orange,
        "tty_clock_color": "1",
        "cmatrix_color":   "green",
        "waybar_bg":           bg2,
        "waybar_bright":       fg4,
        "waybar_empty_button": bg3,
        "rofi_bg":       bg1,
        "rofi_fg":       fg,
        "rofi_selected": fg,
        "rmpc_bg":     bg,
        "rmpc_fg":     fg,
        "rmpc_accent": orange,
        "rmpc_border": bg3,
        "yazi_bg":       bg,
        "yazi_fg":       fg,
        "yazi_selected": orange,
        "yazi_cwd":      blue,
    }

    basename = Path(wallpaper).name
    lines = [
        f"# Colors generated from {basename} on {date.today()}",
        f"# Edit any hex value, then run: scheme-apply.sh {wallpaper}",
        f'wallpaper="{wallpaper}"',
        "",
    ]

    groups = [
        ("# Background variants", ["bg", "bg_h", "bg_s"]),
        ("# Background shades", ["bg0", "bg1", "bg2", "bg3", "bg4"]),
        ("# Grays", ["gray0", "gray1", "gray2"]),
        ("# Foreground shades", ["fg0", "fg1", "fg2", "fg3", "fg4"]),
        ("# Main foreground alias", ["fg"]),
        ("# Dark (muted) accents", ["dark_red", "dark_green", "dark_yellow", "dark_blue", "dark_purple", "dark_aqua", "dark_orange"]),
        ("# Vivid (bright) accents", ["red", "green", "yellow", "blue", "purple", "aqua", "orange"]),
        ("# Constants", ["white", "black", "kitty_fg"]),
        ("# Main accent", ["accent"]),
        ("# Btop UI", ["btop_lines", "btop_dividers", "btop_text", "btop_proc"]),
        ("# Btop gradient (low → high)", ["btop_low", "btop_mid", "btop_high"]),
        ("# Cava gradient (bottom → top)", ["cava_1", "cava_2", "cava_3", "cava_4"]),
        ("# Fastfetch logo", ["logo_color"]),
        ("# Terminal colors", ["tty_clock_color", "cmatrix_color"]),
        ("# Waybar colors", ["waybar_bg", "waybar_bright", "waybar_empty_button"]),
        ("# Rofi colors", ["rofi_bg", "rofi_fg", "rofi_selected"]),
        ("# Rmpc colors", ["rmpc_bg", "rmpc_fg", "rmpc_accent", "rmpc_border"]),
        ("# Yazi colors", ["yazi_bg", "yazi_fg", "yazi_selected", "yazi_cwd"]),
    ]

    for comment, keys in groups:
        lines.append(comment)
        for k in keys:
            lines.append(f'{k}="{colors[k]}"')
        lines.append("")

    Path(output).parent.mkdir(parents=True, exist_ok=True)
    with open(output, "w") as f:
        f.write("\n".join(lines))

    print(f"Scheme written to {output}")


if __name__ == "__main__":
    main()
