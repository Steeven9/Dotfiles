#!/usr/bin/env bash

# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    sudo apt -y install build-essential procps file zsh
elif [[ $(sysctl -n machdep.cpu.brand_string) =~ "Apple" ]]; then
    # Apple silicon
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # Intel Macs
    eval "$(/usr/local/bin/brew shellenv)"
else
    echo "Unknown OS type: {$OSTYPE}"
    exit -1
fi

brew install eza git thefuck zsh-completions \
    zsh-syntax-highlighting tldr fd topgrade curl btop

# https://superuser.com/a/1819754
read -p "Install Mac BT sleep fix? " -n 1 -r
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

# powerline fonts
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
sh install.sh
cd ..
rm -rf fonts

# oh-my-zsh and zsh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
RUNZSH=no && sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc
