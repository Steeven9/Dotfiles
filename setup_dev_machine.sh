#!/usr/bin/env bash

brew install maven gradle php \
    mongosh openjdk@17 speedtest-cli tokei \
    python docker docker-compose

read -p "Install work stuff? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    brew install go helm k9s podman kubectl minikube istioctl skaffold terraform \
        docker-credential-helper openfortivpn mimirtool jq yq cloudfoundry/tap/cf-cli@8 \
        sops pre-commit tsh
    brew install samuong/alpaca/alpaca
    brew services start alpaca
    helm plugin install https://github.com/jkroepke/helm-secrets
fi

read -p "Install casks? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    brew install openvpn-connect firefox discord jellyfin-media-player \
        iterm2 gimp spotify vlc raycast keepassxc
fi

# nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# git config
git config --global commit.gpgsign true
git config --global gpg.format ssh
git config --global pull.rebase true
git config --global --add --bool push.autoSetupRemote true
cat ~/.ssh/id_ed25519.pub | xargs -0 git config --global user.signingkey
git config --global user.email stefano.taille@gmail.com
git config --global user.name "Stefano Taillefert"
