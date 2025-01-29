
if [ -z "$INST_HOSTNAME" ]; then
  printf "You must set INST_HOSTNAME to continue with this script\n" >&2
  exit 1
fi

echo "Hostname is ${INST_HOSTNAME}\n"

sleep 5

# Set up locale
echo "Configuring locale..."
sed -i 's/^#\(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen
locale-gen

echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf
echo "Setting timezone to America/New_York..."
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc

# Enable case-insensitive tab completion
if ! grep "completion-ignore-case" /etc/inputrc; then   echo "set completion-ignore-case on" >> /etc/inputrc; fi
sed -i "s/#ParallelDownloads/ParallelDownloads/g" /etc/pacman.conf
echo 'arch-install' > /etc/hostname

# Set hostname
echo "Configuring hostname and hosts..."
echo "$INST_HOSTNAME" > /etc/hostname

cat <<EOT >> /etc/hosts
127.0.0.1   localhost
::1         localhost
127.0.1.1   $INST_HOSTNAME.localdomain $INST_HOSTNAME
EOT


echo "You still need to set the root password, and add any user accounts!"

