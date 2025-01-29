sudo rm /mnt/var/cache/pacman/pkg/*
sudo rm /media/base-recovery/live/recovery.squashfs
sudo mksquashfs /mnt/ /media/base-recovery/live/recovery.squashfs -comp xz -Xbcj x86 -keep-as-directory -noappend -e /mnt/proc /mnt/sys /mnt/dev /mnt/tmp /mnt/run /mnt/mnt /mnt/tmp 
