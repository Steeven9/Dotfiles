#!/usr/bin/env bash

# Install tools
sudo apt update
sudo apt install -y apt-transport-https ca-certificates gnupg cifs-utils nala

# Updates
sudo nala upgrade --purge

# Misc
sudo timedatectl set-timezone Europe/Zurich
sudo aa-remove-unknown

# Only if Proxmox VM
read -p "Is this a Proxmox VM? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo nala install -y qemu-guest-agent
fi

# Only if Proxmox LXC
read -p "Is this a Proxmox LXC? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo adduser steeven
    sudo usermod -aG sudo steeven
fi
