#!/usr/bin/env bash

brew install maven gradle php yarn \
    mongosh openjdk@17 speedtest-cli tokei \
    python docker docker-compose vsce oven-sh/bun/bun

read -p "Install work stuff? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    brew install go helm k9s podman kubectl minikube istioctl skaffold terraform \
        docker-credential-helper openfortivpn mimirtool jq yq cloudfoundry/tap/cf-cli@8
fi

# casks
read -p "Install casks? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    brew install openvpn-connect firefox discord jellyfin-media-player \
        iterm2 gimp spotify vlc thunderbird nextcloud
fi

# git config
git config --global commit.gpgsign true
git config --global gpg.format ssh
git config --global pull.rebase true
git config --global --add --bool push.autoSetupRemote true
cat ~/.ssh/id_ed25519.pub | xargs -0 git config --global user.signingkey
git config --global user.email stefano.taille@gmail.com
git config --global user.name "Stefano Taillefert"
