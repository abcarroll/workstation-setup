#!/bin/sh
PACMAN_CMD=$(cat /proc/$PPID/cmdline | tr '\0' ' ' | cut -d' ' -f2)

echo "[$(date)] Pre-Transaction snapshot initiated by pacman command: $PACMAN_CMD" | tee -a /var/log/pacman-snapshots.log

# Capture package list
pacman -Qqe > /tmp/pacman-hook-data
sudo cp /tmp/pacman-hook-data /tmp/pacman-hook-data.pre

COMMENT="Pre-transaction: ${PACMAN_COMMAND}"
if [ -r "/media/system/extra/mksnap" ]; then
  /media/system/extra/mksnap / -c "${COMMENT}" --suffix "arch-txn-pre"
else
  printf "Sorry, mksnap doesn't exist where I expect it!\n"
fi  

exit 0
