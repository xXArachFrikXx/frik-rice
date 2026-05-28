#!/bin/bash
# =============================================================================
# Music Transfer Script
# =============================================================================
# Copies the music library from your old machine to this one via rsync over SSH.
# Run this AFTER the main install.sh has finished.
#
# Usage:
#   bash transfer-music.sh <old-machine-ip>
#   bash transfer-music.sh 192.168.1.50
#
# The old machine must be:
#   - Powered on and reachable on the network
#   - Running SSH (sudo systemctl start sshd)
#   - Have the same username (Frik), or edit OLD_USER below
#
# rsync will show progress and skip files already transferred,
# so you can safely re-run if the transfer is interrupted.
# =============================================================================

OLD_IP="$1"
OLD_USER="${2:-Frik}"              # Username on the old machine (default: Frik)
OLD_MUSIC_DIR="/home/$OLD_USER/Music/"   # Music location on old machine
NEW_MUSIC_DIR="$HOME/Music/"             # Music location on this machine

# ── Validate input ────────────────────────────────────────────────────────────
if [[ -z "$OLD_IP" ]]; then
    echo "Usage: bash transfer-music.sh <old-machine-ip> [username]"
    echo ""
    echo "Example: bash transfer-music.sh 192.168.1.50"
    echo "         bash transfer-music.sh 192.168.1.50 Frik"
    echo ""
    echo "To find the old machine's IP, run on the old machine:"
    echo "  ip addr show | grep 'inet '"
    exit 1
fi

echo "==> Transferring music from $OLD_USER@$OLD_IP:$OLD_MUSIC_DIR"
echo "    → $NEW_MUSIC_DIR"
echo ""
echo "    This may take a long time for large libraries."
echo "    You can safely Ctrl+C and re-run — rsync skips already-copied files."
echo ""

# Create destination
mkdir -p "$NEW_MUSIC_DIR"

# rsync flags:
#   -a  = archive mode (preserves permissions, timestamps, symlinks)
#   -v  = verbose (show each file)
#   -h  = human-readable sizes
#   --progress = show transfer progress per file
#   --ignore-existing = skip files that already exist on this machine
rsync -avh --progress --ignore-existing \
    "$OLD_USER@$OLD_IP:$OLD_MUSIC_DIR" \
    "$NEW_MUSIC_DIR"

echo ""
echo "==> Transfer complete!"
echo "    Run 'mpc update' or open rmpc and press U to refresh the MPD library."
