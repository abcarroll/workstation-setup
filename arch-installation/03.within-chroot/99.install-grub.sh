#!/bin/sh

# for i386-pc
INSTALL_LEGACY=""
GRUB_DEVICE="/dev/sdb"
GRUB_BOOT_DIRECTORY="/boot"

# for EFI
INSTALL_EFI="yes"
GRUB_EFI_DIRECTORY="/boot/efi"
GRUB_BOOTLOADER_ID="arbox"


if [ ! -d "${GRUB_EFI_DIRECTORY}" ]; then
  printf "EFI Directory '%s' is not a directory.\n" "${GRUB_EFI_DIRECTORY}"
  mkdir -pv "${GRUB_EFI_DIRECTORY}"
  exit 1
fi

# If it's EFI ... we need to use findmnt to ensure that the grub EFI device is mounted, then we need to make sure it's vfat.

sudo mkinitcpio -P && \
  sudo grub-install --target=x86_64-efi --efi-directory="${GRUB_EFI_DIRECTORY}" --bootloader-id="${GRUB_BOOTLOADER_ID}" && \
  sudo grub-mkconfig -o /boot/grub/grub.cfg

#sudo grub-install --target=i386-pc --boot-directory=/boot /dev/sda && \
