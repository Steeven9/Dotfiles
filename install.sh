#!/usr/bin/env bash
set -euo pipefail

# usage: ./install.sh [-s]
#  -s - directly skips installation

TOPGRADE_VERSION=17.9.0
# note: must be both in apt and brew
COMMON_DEPS=(lsd fzf git curl zsh-syntax-highlighting)

# switch to directory for relative paths
cd "$(dirname "$0")"

echo "Linking files..."
mkdir -p "${HOME}/.config"

# configs
ln -sfv "${PWD}/.bash_aliases" ~/.bash_aliases
ln -sfv "${PWD}/.p10k.zsh" ~/.p10k.zsh
ln -sfv "${PWD}/.zshrc" ~/.zshrc
if [[ -f "${PWD}/.extra_aliases" ]]; then
    ln -sfv "${PWD}/.extra_aliases" ~/.extra_aliases
fi

# application-specific
ln -sfv "${PWD}/.tmux.conf" ~/.tmux.conf
ln -sfv "${PWD}/topgrade.toml" ~/.config/topgrade.toml
if [[ ! -d ~/.config/lsd ]]; then
    ln -sfv "${PWD}/lsd" ~/.config/lsd
fi
if [[ ! -d ~/.config/k9s ]]; then
    ln -sfv "${PWD}/k9s" ~/.config/k9s
fi

# extra binaries
if [[ ! -d "${PWD}/../Scripts" ]]; then
    git clone https://github.com/Steeven9/Scripts.git ../Scripts
fi
# note to future self: don't combine in one if, both need to happen
if [[ -d "${PWD}/../Scripts" ]]; then
    sudo ln -sfv "${PWD}/../Scripts/tmuxer.sh" /usr/local/bin/tmuxer
fi

echo "Symlink creation complete."

if [[ ${1:-} == "-s" ]]; then
    exit 0
fi

read -p "Install tools? (y/n) " -n 1 -r
echo
if [[ "${REPLY}" =~ ^[Nn]$ ]]; then
    exit 0
fi

if [[ "${OSTYPE}" == "linux-gnu"* ]]; then
    sudo apt update
    sudo apt install -y "${COMMON_DEPS[@]}" apt-transport-https ca-certificates gnupg \
        build-essential procps file zsh chrony unattended-upgrades ufw fail2ban

    sudo dpkg-reconfigure unattended-upgrades
    sudo timedatectl set-timezone Europe/Zurich
    sudo locale-gen "en_US.UTF-8"

    arch=$(dpkg --print-architecture)
    curl -fLO "https://github.com/topgrade-rs/topgrade/releases/download/v${TOPGRADE_VERSION}/topgrade_${TOPGRADE_VERSION}_${arch}.deb"
    sudo dpkg -i "topgrade_${TOPGRADE_VERSION}_${arch}.deb"
    rm "topgrade_${TOPGRADE_VERSION}_${arch}.deb"

    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw allow ssh
    sudo ufw enable

    # sometimes on servers we don't want to install homebrew; ask
    if [[ ! -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
        read -p "Install Homebrew? (y/n) " -n 1 -r
        echo
        if [[ "${REPLY}" =~ ^[Yy]$ ]]; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        fi
    fi
fi

if [[ "${OSTYPE}" == "darwin"* ]]; then
    # if you have a mac you *need* brew
    if [[ ! -f "/opt/homebrew/bin/brew" ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    brew install "${COMMON_DEPS[@]}" font-fira-code-nerd-font \
        btop zsh-completions topgrade pinentry-mac mole

    # touch ID for sudo
    echo "Setting touch ID for sudo"
    sed -e 's/^#auth/auth/' /etc/pam.d/sudo_local.template | sudo tee /etc/pam.d/sudo_local

    git clone --depth=1 https://github.com/pkill37/linuxify.git /tmp/linuxify
    (cd /tmp/linuxify && ./linuxify install)
    rm -rf /tmp/linuxify
fi

# https://github.com/Steeven9/motd
read -p "Install custom MOTD? (y/n) " -n 1 -r
echo
if [[ "${REPLY}" =~ ^[Yy]$ ]]; then
    curl -L https://raw.githubusercontent.com/Steeven9/motd/refs/heads/main/scripts/install.sh >motd_install.sh
    sudo chmod +x motd_install.sh && sudo ./motd_install.sh
    rm motd_install.sh
fi

# https://superuser.com/a/1819754
read -p "Install Mac BT sleep fix? (y/n) " -n 1 -r
echo
if [[ "${REPLY}" =~ ^[Yy]$ ]]; then
    brew install blueutil sleepwatcher
    echo '#!/bin/bash 
    /opt/homebrew/bin/blueutil -p 0' >~/.sleep
    echo '#!/bin/bash 
    /opt/homebrew/bin/blueutil -p 1' >~/.wakeup
    chmod +x ~/.sleep ~/.wakeup
    brew services start sleepwatcher
fi

# Proxmox VM - install tools
read -p "Is this a VM? (y/n) " -n 1 -r
echo
if [[ "${REPLY}" =~ ^[Yy]$ ]]; then
    sudo apt install -y qemu-guest-agent
fi

read -p "Is this a dev machine? (y/n) " -n 1 -r
echo
if [[ "${REPLY}" =~ ^[Yy]$ ]]; then
    # nvm
    PROFILE=/dev/null bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.5/install.sh | bash'

    brew install mongosh php tldr gcc jq yq tmux tokei
fi

# git config
git config --global commit.gpgsign true
git config --global gpg.format ssh
git config --global pull.rebase true
git config --global --add --bool push.autoSetupRemote true
git config --global user.signingkey "$(cat ~/.ssh/id_ed25519.pub)"
echo "Reminder: set git config --global user.name and user.email manually"

read -p "Install work stuff? (y/n) " -n 1 -r
echo
if [[ "${REPLY}" =~ ^[Yy]$ ]]; then
    brew install go helm k9s podman kubectl minikube terraform displaylink \
        docker-credential-helper openfortivpn cloudfoundry/tap/cf-cli@8 keepassxc
fi

read -p "Install casks? (y/n) " -n 1 -r
echo
if [[ "${REPLY}" =~ ^[Yy]$ ]]; then
    brew install openvpn-connect discord \
        iterm2 spotify vlc raycast
fi

read -p "Install Docker Engine? (y/n) " -n 1 -r
echo
if [[ "${REPLY}" =~ ^[Yy]$ ]]; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker "${USER}"
    rm get-docker.sh
fi

read -p "Install oh-my-zsh? (y/n) " -n 1 -r
echo
if [[ "${REPLY}" =~ ^[Yy]$ ]]; then
    RUNZSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

read -p "Run updates? (y/n) " -n 1 -r
echo
if [[ "${REPLY}" =~ ^[Yy]$ ]]; then
    topgrade
fi

echo
echo "All done!"
