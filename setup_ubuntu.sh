#!/usr/bin/env bash

# Updates
sudo apt update
sudo apt upgrade -y

# Install tools
sudo apt install -y apt-transport-https ca-certificates gnupg webhook

# Misc
sudo timedatectl set-timezone Europe/Zurich
sudo aa-remove-unknown

# Only if Proxmox VM
sudo apt install -y qemu-guest-agent

# Only if Proxmox LXC
sudo adduser steeven
sudo usermod -aG sudo steeven
sudo usermod -aG docker steeven
