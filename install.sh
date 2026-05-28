#!/bin/bash
# =============================================================================
# Frik's System Install Script
# =============================================================================
# Sets up a complete copy of this system on a fresh Arch Linux install.
#
# What it does (in order):
#   1. Installs yay (AUR helper) if missing
#   2. Installs all packages from packages/pacman.txt and packages/aur.txt
#      — skips packages that are already installed
#   3. Links config files from this repo into ~/.config/
#   4. Copies wallpapers to ~/Wallpapers/
#   5. Installs the SDDM login screen theme
#   6. Sets up Zsh + Oh My Zsh + Starship prompt
#   7. Applies the snow-winter color theme via matugen
#   8. Prints next steps (music transfer, monitor setup, etc.)
#
# Usage:
#   ./install.sh           — full install
#   ./install.sh --dry-run — show what would happen without doing it
#
# Requirements: Fresh Arch Linux install, internet connection, sudo access
# =============================================================================

set -e  # Stop immediately on any error

# ── Terminal colors for pretty output ────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'  # Reset / No Color

# ── Paths ─────────────────────────────────────────────────────────────────────
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"  # Absolute path to this repo
CONFIGS="$REPO/configs/.config"                        # Source configs directory
HOME_FILES="$REPO/home"                                # Source home dotfiles (~/.zshrc etc.)
WALLPAPERS_SRC="$REPO/wallpapers"                      # Source wallpapers
WALLPAPERS_DST="$HOME/Wallpapers"                      # Where wallpapers live on the system
SDDM_THEME_SRC="$REPO/sddm/theme"                     # Source SDDM theme files
SDDM_THEME_DST="/usr/share/sddm/themes/YoRHa-sddm-theme"  # System SDDM theme location

# ── Argument parsing ──────────────────────────────────────────────────────────
DRY_RUN=false
for arg in "$@"; do
    [[ "$arg" == "--dry-run" ]] && DRY_RUN=true
done

# ── Helper functions ──────────────────────────────────────────────────────────

# Print a section header
section() { echo -e "\n${BOLD}${BLUE}==> $1${NC}"; }

# Print success
ok()   { echo -e "  ${GREEN}[✓]${NC} $1"; }

# Print skipped
skip() { echo -e "  ${YELLOW}[~]${NC} $1"; }

# Print info
info() { echo -e "  ${CYAN}[-]${NC} $1"; }

# Print error
err()  { echo -e "  ${RED}[✗]${NC} $1"; }

# Run a command unless in dry-run mode
run() {
    if $DRY_RUN; then
        echo -e "  ${YELLOW}[dry]${NC} would run: $*"
    else
        "$@"
    fi
}

# Check if a package is installed (works for both pacman and AUR packages)
is_installed() {
    pacman -Qi "$1" &>/dev/null
}

# =============================================================================
# 0. Preflight checks
# =============================================================================
section "Preflight checks"

if [[ "$EUID" -eq 0 ]]; then
    err "Do not run this script as root. It will sudo when needed."
    exit 1
fi
ok "Not running as root"

if ! ping -c 1 archlinux.org &>/dev/null; then
    err "No internet connection detected. Please connect and retry."
    exit 1
fi
ok "Internet connection OK"

$DRY_RUN && echo -e "\n${YELLOW}  DRY RUN MODE — no changes will be made${NC}"

# =============================================================================
# 1. Install yay (AUR helper)
# =============================================================================
section "AUR helper (yay)"

if command -v yay &>/dev/null; then
    skip "yay already installed"
else
    info "Installing yay from AUR..."
    run sudo pacman -S --needed --noconfirm git base-devel
    run git clone https://aur.archlinux.org/yay.git /tmp/yay-install
    run bash -c "cd /tmp/yay-install && makepkg -si --noconfirm"
    run rm -rf /tmp/yay-install
    ok "yay installed"
fi

# =============================================================================
# 2. Install packages from official repos
# =============================================================================
section "Official repo packages (pacman)"
info "Checking $(wc -l < "$REPO/packages/pacman.txt") packages..."

PACMAN_TO_INSTALL=()
while IFS= read -r pkg; do
    [[ -z "$pkg" || "$pkg" == \#* ]] && continue  # Skip empty lines and comments
    if is_installed "$pkg"; then
        skip "$pkg"
    else
        info "$pkg — will install"
        PACMAN_TO_INSTALL+=("$pkg")
    fi
done < "$REPO/packages/pacman.txt"

if [[ ${#PACMAN_TO_INSTALL[@]} -eq 0 ]]; then
    ok "All official packages already installed"
else
    info "Installing ${#PACMAN_TO_INSTALL[@]} missing packages..."
    run sudo pacman -S --needed --noconfirm "${PACMAN_TO_INSTALL[@]}"
    ok "Official packages installed"
fi

# =============================================================================
# 3. Install AUR packages
# =============================================================================
section "AUR packages (yay)"
info "Checking $(wc -l < "$REPO/packages/aur.txt") AUR packages..."

AUR_TO_INSTALL=()
while IFS= read -r pkg; do
    [[ -z "$pkg" || "$pkg" == \#* ]] && continue
    if is_installed "$pkg"; then
        skip "$pkg"
    else
        info "$pkg — will install"
        AUR_TO_INSTALL+=("$pkg")
    fi
done < "$REPO/packages/aur.txt"

if [[ ${#AUR_TO_INSTALL[@]} -eq 0 ]]; then
    ok "All AUR packages already installed"
else
    info "Installing ${#AUR_TO_INSTALL[@]} missing AUR packages..."
    run yay -S --needed --noconfirm "${AUR_TO_INSTALL[@]}"
    ok "AUR packages installed"
fi

# =============================================================================
# 4. Link config files
# =============================================================================
section "Config files"
info "Linking configs from $CONFIGS → ~/.config/"

mkdir -p "$HOME/.config"

# Each directory in configs/.config/ gets symlinked to ~/.config/<dir>
# If a real directory already exists there, it gets backed up first.
for src in "$CONFIGS"/*/; do
    dir="$(basename "$src")"
    dst="$HOME/.config/$dir"

    if [[ -L "$dst" ]]; then
        # Already a symlink — update it
        run ln -sfn "$src" "$dst"
        ok "Updated symlink: ~/.config/$dir"
    elif [[ -d "$dst" ]]; then
        # Real directory exists — back it up
        backup="${dst}.bak.$(date +%s)"
        run mv "$dst" "$backup"
        info "Backed up existing $dir to $backup"
        run ln -sfn "$src" "$dst"
        ok "Linked ~/.config/$dir"
    else
        run ln -sfn "$src" "$dst"
        ok "Linked ~/.config/$dir"
    fi
done

# Single-file configs (starship.toml, etc.)
for src in "$CONFIGS"/*.toml "$CONFIGS"/*.conf 2>/dev/null; do
    [[ -f "$src" ]] || continue
    fname="$(basename "$src")"
    run ln -sf "$src" "$HOME/.config/$fname"
    ok "Linked ~/.config/$fname"
done

# Home dotfiles (.zshrc, etc.)
section "Home dotfiles"
for src in "$HOME_FILES"/.*; do
    [[ -f "$src" ]] || continue
    fname="$(basename "$src")"
    dst="$HOME/$fname"
    if [[ -f "$dst" && ! -L "$dst" ]]; then
        run mv "$dst" "${dst}.bak.$(date +%s)"
        info "Backed up existing $fname"
    fi
    run ln -sf "$src" "$dst"
    ok "Linked ~/$fname"
done

# =============================================================================
# 5. Wallpapers
# =============================================================================
section "Wallpapers"
run mkdir -p "$WALLPAPERS_DST"
info "Copying $(ls "$WALLPAPERS_SRC" | wc -l) wallpapers to ~/Wallpapers/..."
run cp -n "$WALLPAPERS_SRC"/. "$WALLPAPERS_DST"/ 2>/dev/null || \
    run rsync -a --ignore-existing "$WALLPAPERS_SRC/" "$WALLPAPERS_DST/"
ok "Wallpapers in place"

# =============================================================================
# 6. SDDM login screen theme
# =============================================================================
section "SDDM login screen (YoRHa theme)"

if [[ -d "$SDDM_THEME_DST" ]]; then
    skip "YoRHa SDDM theme already installed"
else
    info "Installing YoRHa SDDM theme to $SDDM_THEME_DST..."
    run sudo cp -r "$SDDM_THEME_SRC" "$SDDM_THEME_DST"
    ok "SDDM theme installed"
fi

# Write the SDDM config to tell it to use YoRHa
SDDM_CONF="/etc/sddm.conf"
if grep -q "YoRHa" "$SDDM_CONF" 2>/dev/null; then
    skip "SDDM already configured to use YoRHa"
else
    info "Writing $SDDM_CONF..."
    run sudo cp "$REPO/sddm/sddm.conf" "$SDDM_CONF"
    ok "SDDM configured"
fi

# Enable sddm service so it starts on boot
if systemctl is-enabled sddm &>/dev/null; then
    skip "sddm service already enabled"
else
    run sudo systemctl enable sddm
    ok "sddm service enabled"
fi

# =============================================================================
# 7. Zsh setup
# =============================================================================
section "Shell (Zsh + Oh My Zsh + Starship)"

# Set Zsh as default shell
if [[ "$SHELL" == */zsh ]]; then
    skip "Zsh already default shell"
else
    info "Setting Zsh as default shell..."
    run chsh -s "$(which zsh)"
    ok "Default shell set to Zsh (takes effect on next login)"
fi

# Install Oh My Zsh if not present
if [[ -d "$HOME/.oh-my-zsh" ]]; then
    skip "Oh My Zsh already installed"
else
    info "Installing Oh My Zsh..."
    run sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    ok "Oh My Zsh installed"
fi

# Install Zsh plugins if missing
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

for plugin in zsh-autosuggestions zsh-syntax-highlighting; do
    plugin_dir="$ZSH_CUSTOM/plugins/$plugin"
    if [[ -d "$plugin_dir" ]]; then
        skip "Zsh plugin: $plugin"
    else
        info "Installing Zsh plugin: $plugin..."
        run git clone "https://github.com/zsh-users/$plugin" "$plugin_dir"
        ok "Installed $plugin"
    fi
done

# =============================================================================
# 8. Apply color theme (matugen)
# =============================================================================
section "Color theme (snow-winter preset)"

info "Running matugen to generate all app color files..."
info "This sets: kitty colors, waybar colors, rofi colors, btop theme, wlogout style, cava gradient"

if $DRY_RUN; then
    info "[dry] would run: ~/.config/hypr/scripts/apply-preset.sh snow-winter"
else
    if [[ -f "$HOME/.config/hypr/scripts/apply-preset.sh" ]]; then
        bash "$HOME/.config/hypr/scripts/apply-preset.sh" snow-winter 2>/dev/null || \
            err "Preset apply failed — run it manually after logging into Hyprland"
        ok "snow-winter theme applied"
    else
        err "apply-preset.sh not found — run it manually after setup"
    fi
fi

# =============================================================================
# 9. MPD music player setup
# =============================================================================
section "MPD (music player daemon)"

# Create the MPD music directory placeholder
run mkdir -p "$HOME/Music"

# Enable and start MPD user service
if systemctl --user is-enabled mpd &>/dev/null 2>&1; then
    skip "MPD user service already enabled"
else
    run systemctl --user enable mpd
    run systemctl --user start mpd
    ok "MPD service enabled and started"
fi

info "MPD is configured to read music from ~/Music/"
info "See docs/MUSIC.md for how to transfer your music library."

# =============================================================================
# Done!
# =============================================================================
echo ""
echo -e "${BOLD}${GREEN}══════════════════════════════════════════${NC}"
echo -e "${BOLD}${GREEN}  Install complete!${NC}"
echo -e "${BOLD}${GREEN}══════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}Next steps:${NC}"
echo ""
echo -e "  1. ${CYAN}Transfer your music${NC} (see docs/MUSIC.md):"
echo -e "     ${YELLOW}bash transfer-music.sh <old-machine-ip>${NC}"
echo ""
echo -e "  2. ${CYAN}Fix monitor layout${NC} in ~/.config/hypr/Modules/Monitors.lua"
echo -e "     — set your monitor names (run ${YELLOW}hyprctl monitors${NC} to see them)"
echo ""
echo -e "  3. ${CYAN}Log out and back in${NC} to Hyprland"
echo ""
echo -e "  4. ${CYAN}Press SUPER+W${NC} to pick a theme preset"
echo -e "     ${CYAN}Press SUPER+ALT+1${NC} to set up the homepage workspace"
echo ""
echo -e "  See ${CYAN}docs/KEYBINDS.md${NC} for all keyboard shortcuts."
echo ""
