#!/usr/bin/env python3
"""Fill a template file with colors from a .colors scheme file.

Usage: fill-template.py <scheme_file> <template_file> <output_file>

Template syntax (same escaping as pywal):
  {color_name}       — substituted with the hex value (e.g. #dd1f30)
  {color_name.strip} — hex value without the leading # (e.g. dd1f30)
  {{                 — literal {
  }}                 — literal }
"""

import re
import sys
from pathlib import Path


def load_scheme(path: str) -> dict[str, str]:
    colors: dict[str, str] = {}
    with open(path) as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            if "=" not in line:
                continue
            key, _, val = line.partition("=")
            colors[key.strip()] = val.strip().strip('"').strip("'")
    return colors


def build_color_dict(scheme: dict[str, str]) -> dict[str, str]:
    """Add color0-color15 aliases and .strip variants."""
    d = dict(scheme)

    # color0-15 aliases so templates using the old pywal names keep working
    aliases = {
        "color0":  "bg",
        "color1":  "dark_red",
        "color2":  "dark_green",
        "color3":  "dark_yellow",
        "color4":  "dark_blue",
        "color5":  "dark_purple",
        "color6":  "dark_aqua",
        "color7":  "gray2",
        "color8":  "bg3",
        "color9":  "red",
        "color10": "green",
        "color11": "yellow",
        "color12": "blue",
        "color13": "purple",
        "color14": "aqua",
        "color15": "fg",
        "background": "bg",
        "foreground": "fg",
        "cursor":     "fg",
    }
    for alias, source in aliases.items():
        if alias not in d and source in d:
            d[alias] = d[source]

    # Add .strip and .fc variants for every existing key
    for key in list(d.keys()):
        d[key + ".strip"] = d[key].lstrip("#")
        d[key + ".fc"] = "{#" + d[key] + "}"  # fastfetch inline color: {##rrggbb}

    return d


def fill_template(template: str, colors: dict[str, str]) -> str:
    # Temporarily replace {{ and }} so they don't get matched as substitutions
    placeholder_open  = "\x00OPEN\x00"
    placeholder_close = "\x00CLOSE\x00"
    template = template.replace("{{", placeholder_open).replace("}}", placeholder_close)

    def replacer(m: re.Match) -> str:
        key = m.group(1)
        if key in colors:
            return colors[key]
        # Leave unknown placeholders unchanged (restore braces)
        return "{" + key + "}"

    result = re.sub(r"\{([^{}]+)\}", replacer, template)
    result = result.replace(placeholder_open, "{").replace(placeholder_close, "}")
    return result


def main() -> None:
    if len(sys.argv) != 4:
        print(
            f"Usage: {sys.argv[0]} <scheme_file> <template_file> <output_file>",
            file=sys.stderr,
        )
        sys.exit(1)

    scheme_path, template_path, output_path = sys.argv[1], sys.argv[2], sys.argv[3]

    scheme = load_scheme(scheme_path)
    colors = build_color_dict(scheme)

    with open(template_path) as f:
        template = f.read()

    result = fill_template(template, colors)

    Path(output_path).parent.mkdir(parents=True, exist_ok=True)
    with open(output_path, "w") as f:
        f.write(result)


if __name__ == "__main__":
    main()
