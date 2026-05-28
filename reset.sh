#!/bin/bash
# =============================================================================
# Frik's System Reset Script
# =============================================================================
# Strips this machine back to a minimal Arch base — removes all desktop
# software and user configs so install.sh can set everything up from scratch.
# Use this instead of reinstalling Arch.
#
# IMPORTANT: Run this from a TTY, NOT from inside Hyprland.
#   Switch to a TTY: press Ctrl+Alt+F2, log in, then run this script.
#   Running it from within a Hyprland session can cause crashes mid-removal.
#
# Usage:
#   bash reset.sh           — interactive (asks for confirmation first)
#   bash reset.sh --dry-run — show what would happen without changing anything
#
# After this script finishes, run:
#   bash install.sh
# =============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

section() { echo -e "\n${BOLD}${BLUE}==> $1${NC}"; }
ok()      { echo -e "  ${GREEN}[✓]${NC} $1"; }
skip()    { echo -e "  ${YELLOW}[~]${NC} $1"; }
info()    { echo -e "  ${CYAN}[-]${NC} $1"; }
err()     { echo -e "  ${RED}[✗]${NC} $1"; }

DRY_RUN=false
for arg in "$@"; do
    [[ "$arg" == "--dry-run" ]] && DRY_RUN=true
done

run() {
    if $DRY_RUN; then
        echo -e "  ${YELLOW}[dry]${NC} would run: $*"
    else
        "$@"
    fi
}

# =============================================================================
# Preflight checks
# =============================================================================

if [[ "$EUID" -eq 0 ]]; then
    err "Don't run as root. The script will sudo when needed."
    exit 1
fi

# Warn if running inside a Hyprland session — strongly discouraged
if [[ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]]; then
    echo ""
    echo -e "${BOLD}${RED}  !! You are currently inside a Hyprland session. !!${NC}"
    echo -e "${RED}  Removing packages while the desktop is running can crash it.${NC}"
    echo -e "${YELLOW}  Switch to a TTY first: press Ctrl+Alt+F2, log in, then re-run.${NC}"
    echo ""
fi

# =============================================================================
# Confirmation
# =============================================================================
echo ""
echo -e "${BOLD}${RED}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${RED}║  WARNING: This removes most installed packages and configs. ║${NC}"
echo -e "${BOLD}${RED}║  The system will be reduced to a minimal Arch base.         ║${NC}"
echo -e "${BOLD}${RED}║  Run install.sh afterward to set everything back up.        ║${NC}"
echo -e "${BOLD}${RED}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

if $DRY_RUN; then
    echo -e "${YELLOW}  DRY RUN MODE — no changes will be made${NC}\n"
else
    echo -ne "  Type ${BOLD}yes${NC} to continue, anything else to cancel: "
    read -r confirm
    if [[ "$confirm" != "yes" ]]; then
        echo "Aborted."
        exit 0
    fi
fi

# =============================================================================
# Build the keep list
# =============================================================================
section "Building keep list"

# We keep everything in the 'base' and 'base-devel' package groups, plus
# the essentials listed below. Everything else gets removed.
declare -A KEEP

# The 'base' metapackage (bash, coreutils, systemd, glibc, etc.)
while IFS= read -r pkg; do
    KEEP["$pkg"]=1
done < <(pacman -Sgq base 2>/dev/null)

# 'base-devel' (gcc, make, fakeroot, binutils — needed to build AUR packages)
while IFS= read -r pkg; do
    KEEP["$pkg"]=1
done < <(pacman -Sgq base-devel 2>/dev/null)

# Critical extras that must survive
for pkg in \
    linux linux-firmware linux-headers \
    grub efibootmgr os-prober \
    networkmanager iproute2 iputils \
    sudo openssh \
    git curl wget nano \
    pciutils usbutils \
    amd-ucode intel-ucode; do   # keep both — one just won't be installed
    KEEP["$pkg"]=1
done

info "Keeping ${#KEEP[@]} essential packages"

# =============================================================================
# Remove AUR / foreign packages
# =============================================================================
section "AUR / foreign packages"

# pacman -Qm lists packages NOT from any official repo (i.e., AUR installs)
mapfile -t AUR_PKGS < <(pacman -Qmq 2>/dev/null)

if [[ ${#AUR_PKGS[@]} -eq 0 ]]; then
    skip "No AUR packages installed"
else
    info "Removing ${#AUR_PKGS[@]} AUR packages:"
    for pkg in "${AUR_PKGS[@]}"; do info "  $pkg"; done

    # -Rdd skips dependency checks — needed because AUR packages can depend
    # on each other in ways that confuse pacman's removal order check
    run sudo pacman -Rdd --noconfirm "${AUR_PKGS[@]}" 2>/dev/null || true
    ok "AUR packages removed"
fi

# =============================================================================
# Remove non-base explicitly installed packages
# =============================================================================
section "Non-base packages"

TO_REMOVE=()
while IFS= read -r pkg; do
    # Skip if this package is in our keep list
    [[ -n "${KEEP[$pkg]}" ]] && continue
    TO_REMOVE+=("$pkg")
    info "will remove: $pkg"
done < <(pacman -Qqe 2>/dev/null)

if [[ ${#TO_REMOVE[@]} -eq 0 ]]; then
    skip "Already at minimal install"
else
    info "Removing ${#TO_REMOVE[@]} packages..."
    # -Rns: remove package + any unneeded deps it pulled in
    # fall back to -Rdd if there are dependency conflicts
    run sudo pacman -Rns --noconfirm "${TO_REMOVE[@]}" 2>/dev/null || \
    run sudo pacman -Rdd --noconfirm "${TO_REMOVE[@]}" 2>/dev/null || true
    ok "Packages removed"
fi

# =============================================================================
# Remove orphaned dependencies
# =============================================================================
section "Orphaned dependencies"

# Orphans = installed as deps but no longer needed by anything
mapfile -t ORPHANS < <(pacman -Qtdq 2>/dev/null)

if [[ ${#ORPHANS[@]} -eq 0 ]]; then
    skip "No orphans"
else
    info "Removing ${#ORPHANS[@]} orphaned packages..."
    run sudo pacman -Rns --noconfirm "${ORPHANS[@]}" 2>/dev/null || true
    ok "Orphans removed"
fi

# =============================================================================
# Wipe user config directories
# =============================================================================
section "User config directories"

# These will all be recreated by install.sh — no need to back them up
# since the repo contains everything.
CONFIG_DIRS=(
    "$HOME/.config/hypr"
    "$HOME/.config/kitty"
    "$HOME/.config/waybar"
    "$HOME/.config/rofi"
    "$HOME/.config/cava"
    "$HOME/.config/matugen"
    "$HOME/.config/btop"
    "$HOME/.config/wlogout"
    "$HOME/.config/swaync"
    "$HOME/.config/rmpc"
    "$HOME/.config/mpd"
    "$HOME/.config/fastfetch"
    "$HOME/.config/starship.toml"
    "$HOME/.oh-my-zsh"
)

for target in "${CONFIG_DIRS[@]}"; do
    if [[ -e "$target" || -L "$target" ]]; then
        info "Removing $target"
        run rm -rf "$target"
    fi
done

# Home dotfiles installed by install.sh
for f in "$HOME/.zshrc"; do
    if [[ -e "$f" || -L "$f" ]]; then
        info "Removing $f"
        run rm -f "$f"
    fi
done

ok "Config directories cleared"

# =============================================================================
# Done
# =============================================================================
echo ""
echo -e "${BOLD}${GREEN}══════════════════════════════════════════${NC}"
echo -e "${BOLD}${GREEN}  Reset complete!${NC}"
echo -e "${BOLD}${GREEN}══════════════════════════════════════════${NC}"
echo ""
echo -e "  Now run: ${CYAN}bash install.sh${NC}"
echo ""
