#!/bin/bash
# Fetches synced .lrc lyrics from lrclib.net for the current MPD song.
# Called by rmpc on_song_change. Mirrors the music dir structure in lyrics_dir.

LYRICS_DIR="$HOME/.config/rmpc/lyrics"

FILE=$(mpc current --format "%file%" 2>/dev/null)
[ -z "$FILE" ] && exit 0

LRC_PATH="$LYRICS_DIR/${FILE%.*}.lrc"
[ -f "$LRC_PATH" ] && exit 0  # already have it

ARTIST=$(mpc current --format "%artist%")
TITLE=$(mpc current --format "%title%")
ALBUM=$(mpc current --format "%album%")

urlencode() { python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" "$1"; }

RESPONSE=$(curl -s --max-time 5 \
    "https://lrclib.net/api/get?artist_name=$(urlencode "$ARTIST")&track_name=$(urlencode "$TITLE")&album_name=$(urlencode "$ALBUM")" \
    2>/dev/null)

LYRICS=$(echo "$RESPONSE" | jq -r '.syncedLyrics // .plainLyrics // empty' 2>/dev/null)
[ -z "$LYRICS" ] && exit 0

mkdir -p "$(dirname "$LRC_PATH")"
echo "$LYRICS" > "$LRC_PATH"
