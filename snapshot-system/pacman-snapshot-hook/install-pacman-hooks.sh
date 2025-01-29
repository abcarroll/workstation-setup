#!/bin/bash
set +x

ROOT_SUBVOL="$1"

if [ "${ROOT_SUBVOL}" = "/" ]; then
  ROOT_SUBVOL=""
fi

sudo mkdir -pv "${ROOT_SUBVOL}/etc/pacman.d/hooks/"
sudo rm -v "${ROOT_SUBVOL}/etc/pacman.d/hooks/"mysnap.*.hook
sudo cp -v /media/system/extra/etc.pacman.d.hooks/mysnap.*.hook "${ROOT_SUBVOL}/etc/pacman.d/hooks/"

