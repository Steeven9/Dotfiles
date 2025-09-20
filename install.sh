#!/usr/bin/env bash
# usage: ./install.sh
# passing -s directly skips installation

if [[ ! -d "${HOME}/.config" ]]; then
    mkdir "${HOME}/.config"
fi

# configs
ln -s -f "${PWD}/.bash_aliases" ~/.bash_aliases
ln -s -f "${PWD}/.p10k.zsh" ~/.p10k.zsh
ln -s -f "${PWD}/topgrade.toml" ~/.config/topgrade.toml
ln -s -f "${PWD}/.zshrc" ~/.zshrc
ln -s -f "${PWD}/.tmux.conf" ~/.tmux.conf
if [[ -f "${PWD}/.extra_aliases" ]]; then
    ln -s -f "${PWD}/.extra_aliases" ~/.extra_aliases
fi
if [[ -d "${PWD}/../Scripts" ]]; then
    sudo ln -s -f "${PWD}/../Scripts/tmuxer.sh" /usr/local/bin/tmuxer
fi

echo "Symlink creation complete."

if [[ $1 == "-s" ]]; then
    exit 0
fi

read -p "Install tools? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]; then
    exit 0
fi

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo apt update
    sudo apt install -y nala
    sudo nala install -y apt-transport-https ca-certificates gnupg \
        curl build-essential procps file zsh git eza fzf zsh-syntax-highlighting
    sudo timedatectl set-timezone Europe/Zurich
    sudo nala upgrade -y
fi

# Homebrew
if [[ ! -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    sudo locale-gen "en_US.UTF-8"
elif [[ $(sysctl -n machdep.cpu.brand_string) =~ "Apple" ]]; then
    # Apple silicon
    eval "$(/opt/homebrew/bin/brew shellenv)"
    brew install font-fira-code-nerd-font git curl btop eza fzf zsh-completions \
        zsh-syntax-highlighting topgrade
    # touch ID for sudo
    sed -e 's/^#auth/auth/' /etc/pam.d/sudo_local.template | sudo tee /etc/pam.d/sudo_local
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # Intel Macs
    eval "$(/usr/local/bin/brew shellenv)"
else
    echo "Unknown OS type: {$OSTYPE}"
    exit -1
fi

# https://superuser.com/a/1819754
read -p "Install Mac BT sleep fix? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    brew install blueutil sleepwatcher
    echo '#!/bin/bash 
    /opt/homebrew/bin/blueutil -p 0' >>~/.sleep
    echo '#!/bin/bash 
    /opt/homebrew/bin/blueutil -p 1' >>~/.wakeup
    chmod +x ~/.sleep ~/.wakeup
    brew services start sleepwatcher
fi

# Proxmox VM - install tools
read -p "Is this a Proxmox VM? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo nala install -y qemu-guest-agent
fi

read -p "Is this a dev machine? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # nvm
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    brew install mongosh php tldr
    brew unlink node
fi

# git config
git config --global commit.gpgsign true
git config --global gpg.format ssh
git config --global pull.rebase true
git config --global --add --bool push.autoSetupRemote true
cat ~/.ssh/id_ed25519.pub | xargs -0 git config --global user.signingkey
git config --global user.email stefano.taille@gmail.com
git config --global user.name "Stefano Taillefert"

read -p "Install work stuff? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    brew install go helm k9s podman kubectl minikube terraform \
        docker-credential-helper openfortivpn jq yq cloudfoundry/tap/cf-cli@8 keepassxc
fi

read -p "Install casks? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    brew install openvpn-connect discord \
        iterm2 spotify vlc raycast
fi

read -p "Install Docker Engine? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    rm get-docker.sh
fi

# oh-my-zsh and zsh
RUNZSH=no && sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

echo
echo "All done!"
