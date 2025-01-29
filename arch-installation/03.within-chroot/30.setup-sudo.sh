#!/bin/bash


pacman -S sudo
# Ensure groups exist
groupadd -f sudo
groupadd -f wheel
echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/group-wheel
echo "%sudo ALL=(ALL) ALL" > /etc/sudoers.d/group-sudo
chmod 0440 /etc/sudoers.d/group-wheel /etc/sudoers.d/group-sudo
