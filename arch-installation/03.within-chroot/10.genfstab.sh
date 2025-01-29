
mount -o subvol= /dev/sdXx /media/system
mount -o subvol= /dev/sdXx /media/backup
mount -o subvol= /dev/sdXx /var/cache/pacman

genfstab -U / > /etc/fstab