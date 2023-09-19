#!/usr/bin/env bash

if [[ ! -d "$HOME/.config" ]]; then
    mkdir "$HOME/.config"
fi

# configs
ln -s -f $PWD/.bash_aliases ~/.bash_aliases
ln -s -f $PWD/.p10k.zsh ~/.p10k.zsh
ln -s -f $PWD/topgrade.toml ~/.config/topgrade.toml
ln -s -f $PWD/.zshrc ~/.zshrc
if [[ -f $PWD/.extra_aliases ]]; then
    ln -s -f $PWD/.extra_aliases ~/.extra_aliases
fi
echo "Symlink creation complete."

# setup
read -p "Install ubuntu tools? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sh setup_ubuntu.sh
fi

read -p "Install basic tools? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sh setup_basic.sh
fi

read -p "Install dev tools? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sh setup_dev_machine.sh
fi
