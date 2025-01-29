# for EFI
INSTALL_EFI="yes"
GRUB_EFI_DIRECTORY="/boot/efi"
GRUB_BOOTLOADER_ID="recovery"


sudo mkinitcpio -P && \
  sudo grub-install --target=x86_64-efi --efi-directory="${GRUB_EFI_DIRECTORY}" --bootloader-id="${GRUB_BOOTLOADER_ID}" && \
  sudo grub-mkconfig -o /boot/grub/grub.cfg