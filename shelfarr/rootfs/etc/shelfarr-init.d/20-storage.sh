#!/usr/bin/env bash
# Uses env exported by 00-options.sh (PUID, PGID, AUDIOBOOKS_PATH, EBOOKS_PATH, DOWNLOADS_PATH).

# Persistent DB/storage in addon_config (/config); migrate existing image data once.
mkdir -p /config/storage
if [ -d /rails/storage ] && [ ! -L /rails/storage ]; then
  cp -an /rails/storage/. /config/storage/ 2>/dev/null || true
  rm -rf /rails/storage
fi
ln -sfn /config/storage /rails/storage

# Libraries on /share; symlink the in-container mount points to the configured paths.
mkdir -p "$AUDIOBOOKS_PATH" "$EBOOKS_PATH" "$DOWNLOADS_PATH"
ln -sfn "$AUDIOBOOKS_PATH" /audiobooks
ln -sfn "$EBOOKS_PATH"     /ebooks
ln -sfn "$DOWNLOADS_PATH"  /downloads

# Permissions so the dropped PUID/PGID user can write.
chown -R "${PUID:-0}:${PGID:-0}" /config/storage 2>/dev/null || true
chown -R "${PUID:-0}:${PGID:-0}" "$AUDIOBOOKS_PATH" "$EBOOKS_PATH" "$DOWNLOADS_PATH" 2>/dev/null || true
