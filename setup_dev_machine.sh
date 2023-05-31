#!/usr/bin/env bash

brew installmaven gradle node@16 php thefuck yarn \
    mongosh openjdk@8 openjdk@17 speedtest-cli tokei \
    htop python@3.11 docker docker-compose vsce texlive latexindent

brew install go helm podman k9s kubectl minikube istioctl skaffold \
    docker-credential-helper openfortivpn mimirtool jq cloudfoundry/tap/cf-cli@8

# casks
brew install openvpn-connect firefox iterm2 gimp spotify vlc thunderbird nextcloud

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
