#!/bin/sh

PACMAN_CMD=$(cat /proc/$PPID/cmdline | tr '\0' ' ' | cut -d' ' -f2)

echo "[$(date)] Post-Transaction snapshot initiated by pacman command: $PACMAN_CMD" | tee -a /var/log/pacman-snapshots.log

COMMENT="Post-transaction: ${PACMAN_COMMAND}"
/media/system/extra/mksnap / -c "${COMMENT}" --suffix "arch-txn-post"

exit 
