#!/bin/sh

if [ -z "${INST_ROOT}" ]; then 
  printf "You need to specify INST_ROOT, which should be where you'd like to install the operating system to, in order to continue.\n" >&2
  exit 1
fi

echo "INSTALL ROOT=${INST_ROOT}"
sleep 5

sudo pacstrap -cP "${INST_ROOT}" base linux linux-firmware arch-install-scripts btrfs-progs e2fsprogs os-prober networkmanager


# util-linux grub procps-ng efibootmgr btrfs-progs e2fsprogs dosfstools xfsprogs ntfs-3g os-prober lvm2 cryptsetup freetype2 os-prober networkmanager sudo rsync
# pacman -S --noconfirm grub os-prober lzop mtools freetype2 efibootmgr
