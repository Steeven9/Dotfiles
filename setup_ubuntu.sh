#!/usr/bin/env bash

# Updates
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y

# Install tools
sudo apt install -y apt-transport-https ca-certificates gnupg cifs-utils

# Misc
sudo timedatectl set-timezone Europe/Zurich
sudo aa-remove-unknown

# Only if Proxmox VM
read -p "Is this a Proxmox VM? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo apt install -y qemu-guest-agent
fi

# Only if Proxmox LXC
read -p "Is this a Proxmox LXC? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo adduser steeven
    sudo usermod -aG sudo steeven
fi
