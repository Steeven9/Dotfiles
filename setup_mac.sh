#!/usr/bin/env bash

# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install exa git glances maven gradle node@16 openssl php thefuck yarn zsh zsh-completions \
    zsh-syntax-highlighting tldr fd topgrade mongosh openjdk@8 openjdk@17 speedtest-cli tokei \
    htop python@3.11 docker docker-compose vsce curl texlive latexindent

# casks
brew install openvpn-connect firefox iterm2 gimp spotify vlc thunderbird nextcloud

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# powerline fonts
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts

# gpg keys
# gpg --import {PRIVATE_KEY}
# gpg --import {PUBLIC_KEY}
# gpg --edit-key {KEY} trust quit

# git config
git config --global commit.gpgsign true
git config --global gpg.format ssh
cat ~/.ssh/id_ed25519.pub | xargs -0 git config --global user.signingkey
git config --global user.email stefano.taille@gmail.com
git config --global user.name "Stefano Taillefert"
