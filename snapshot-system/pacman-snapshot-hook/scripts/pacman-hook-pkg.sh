#!/bin/sh

PACMAN_COMMAND=$(cat /proc/$PPID/cmdline | tr '\0' ' ')

PKG_FILE=$(mktemp)

# Capture package details
pacman -Qqe > "$PKG_FILE"
sudo cp "$PKG_FILE" /tmp/pacman-hook-data.pre

echo "[$(date)] Package-level snapshot triggered. Modified packages:" | tee -a /var/log/pacman-snapshots.log
diff /tmp/pacman-hook-data "$PKG_FILE" | tee -a /var/log/pacman-snapshots.log

mv "$PKG_FILE" /tmp/pacman-hook-data

cp "/tmp/pacman-hook-data" /tmp/pacman-hook-data.pkg-file.pkg

/media/system/extra/mksnap / -c "Package Level: ${PACMAN_COMMAND}" --suffix "arch-pkg"

exit 0
