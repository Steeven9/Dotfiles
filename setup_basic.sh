#!/usr/bin/env bash

# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Unknown OS type: {$OSTYPE}"
fi

brew install exa git glances thefuck zsh zsh-completions \
    zsh-syntax-highlighting tldr fd topgrade curl htop

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# powerline fonts
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
sh install.sh
cd ..
rm -rf fonts
