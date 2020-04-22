#!/bin/sh

ZSH_DIR=$(dirname ${BASH_SOURCE[0]})

rm -rf "$HOME/.zim"
wget -nv -O - https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh

rm -rf "$HOME/.zimrc"
rm -rf "$HOME/.zshrc"

ln -s "$ZSH_DIR/zimrc" ~/.zimrc
ln -s "$ZSH_DIR/zshrc" ~/.zshrc

# Apply changes from zimrc
zsh -c 'source ~/.zim/zimfw.zsh install'
zsh -c 'source ~/.zim/zimfw.zsh uninstall'

