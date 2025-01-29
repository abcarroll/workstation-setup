#!/bin/bash

# Define INST_ROOT - This should be set before running the script
INST_ROOT="$1"
SCRIPT_TO_RUN="temp-within-chroot.sh"

# Check if INST_ROOT is provided
if [[ -z "$INST_ROOT" ]]; then
    echo "Error: INST_ROOT must be specified."
    exit 1
fi

# Function to clean up temporary mount
cleanup() {
    if [[ -n "$TEMP_MOUNT" ]]; then
        echo "Cleaning up temporary mount: $TEMP_MOUNT"
        umount "$TEMP_MOUNT" &>/dev/null && rmdir "$TEMP_MOUNT" &>/dev/null
    fi
}

# Ensure cleanup on script exit or interruption
trap cleanup EXIT INT TERM

# Check if INST_ROOT is a mount point
MOUNT_INFO=$(findmnt -no SOURCE,TARGET "$INST_ROOT")
DEVICE=$(echo "$MOUNT_INFO" | awk '{print $1}')
MOUNTED_PATH=$(echo "$MOUNT_INFO" | awk '{print $2}')

if [[ -n "$MOUNTED_PATH" && "$MOUNTED_PATH" == "$INST_ROOT" ]]; then
    echo "INST_ROOT is an actual mount: $INST_ROOT"
    CHROOT_PATH="$INST_ROOT"
else
    echo "INST_ROOT is NOT an actual mount, resolving subvolume..."

    # Get the device where INST_ROOT resides
    DEVICE=$(findmnt -no SOURCE "$(dirname "$INST_ROOT")" | sed 's/\[.*\]//')

    # Get the subvolume name manually
    SUBVOL_NAME=$(btrfs subvolume show "$INST_ROOT" 2>/dev/null | awk -F'path: ' '/path:/ {print $2}')

    if [[ -z "$DEVICE" || -z "$SUBVOL_NAME" ]]; then
        echo "Error: Could not resolve device or subvolume for $INST_ROOT."
        exit 1
    fi

    echo "Resolved Device: $DEVICE"
    echo "Subvolume: $SUBVOL_NAME"

    # Create temporary mount point
    TEMP_MOUNT="/tmp/chroot_mount_$(basename "$INST_ROOT")"
    mkdir -p "$TEMP_MOUNT"

    # Mount the subvolume
    mount -o subvol="$SUBVOL_NAME" "$DEVICE" "$TEMP_MOUNT" || {
        echo "Error: Failed to mount subvolume."
        exit 1
    }

    CHROOT_PATH="$TEMP_MOUNT"
fi

cat 02.within-chroot.sh 03.within-chroot.sudo.sh > "$CHROOT_PATH/root/tmp-within-chroot.sh"
chmod +x "$CHROOT_PATH/root/tmp-within-chroot.sh"


# Run the chroot script
echo "Entering chroot: $CHROOT_PATH"
arch-chroot "$CHROOT_PATH" /bin/bash "/root/$SCRIPT_TO_RUN" || {
    echo "Error: Failed to execute script within chroot."
    exit 1
}

echo "Chroot script executed successfully."

