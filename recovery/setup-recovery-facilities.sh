#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root" >&2
    exit 1
fi

set -e  # Exit immediately if a command exits with a non-zero status

# Step 1: Prompt for root password at early boot
passwd root

echo "Root password set successfully."

# Step 2: Configure LightDM for automatic root login
LIGHTDM_CONF="/etc/lightdm/lightdm.conf"

if [ -f "$LIGHTDM_CONF" ]; then
    sed -i 's/^#?autologin-user=.*/autologin-user=root/' "$LIGHTDM_CONF"
else
    echo "[Seat:*]" > "$LIGHTDM_CONF"
    echo "autologin-user=root" >> "$LIGHTDM_CONF"
fi

systemctl enable lightdm.service

echo "LightDM configured for automatic root login."

# Step 3: Enable root login on TTY without a password
PAM_FILE="/etc/pam.d/login"

if ! grep -q "^auth\s\+sufficient\s\+pam_permit.so" "$PAM_FILE"; then
    echo "auth       sufficient   pam_permit.so" >> "$PAM_FILE"
fi

echo "Root login on TTY without a password enabled."

# Step 4: Ensure agetty allows root login without a password
GETTY_OVERRIDE="/etc/systemd/system/getty@tty1.service.d/override.conf"
mkdir -p "$(dirname "$GETTY_OVERRIDE")"
echo "[Service]" > "$GETTY_OVERRIDE"
echo "ExecStart=" >> "$GETTY_OVERRIDE"
echo "ExecStart=-/sbin/agetty --noclear --autologin root %I $TERM" >> "$GETTY_OVERRIDE"

systemctl daemon-reexec

echo "TTY configured for automatic root login."

echo "Setup complete. Reboot to apply changes."

