# A big bad workstation setup 

This is a bunch of scripts to setup a workstation.  You can use parts of it, or all of it.  If you use all of it, the final system will look like:

 - GPT partition table on a drive
   - UEFI and/or BIOS bootable
	 - A recovery OS, which is squashfs on ext2 
	 - A btrfs partition which contains
	   - another copy of the recovery OS
		 - as many OS's as you wish under subvolumes
		 - home directories as subvolumes (optional)
		 - some cache directories like `/var/cache/pacman`, `/var/cache/apt` (optional)
		 - a snapshot system which allows you to snapshot any of the subvolumes
	 - The recovery system:
	   - is Arch Linux
		 - has boot scripts to set the root password
		 - no root password is required for login through lightdm though
		 - has xfce4, and the basics on-board
	 - Arch Linux Installer
	   - Sets up pacman hooks to do subvol snaps before/after pacman txn's
		 - Does a bunch of other stuff
	 - Debian Installer
	   - Same
	 - Grub manager 

# Bugs

 
 - So, I think `pacstrap -P` (`-P` is Copy the host's pacman config to the target) is causing problems with the `mksnap` hooks.  I belive it is copying the hooks with pacstrap, and then the first time we use pacman after that, the `/media/system` mount doesn't exist on this system (in the chroot), and so it can't run the pacman hook, and causes `pacman` to fail indefinitely until the hooks are removed.  
