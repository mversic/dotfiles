#!/usr/bin/env bash

set -e

TMP_DIR="/tmp/fresh_install"

rm -rf "$TMP_DIR"
mkdir "$TMP_DIR"
cd "$TMP_DIR"

#----------------------------------------------------------------------------------------
# Install essential programs and applications
#----------------------------------------------------------------------------------------
sudo pacman -Syy

sudo pacman -S --noconfirm alacritty
sudo pacman -S --noconfirm ripgrep fd bat fzf # exa runiq ion watchexec
sudo pacman -S --noconfirm tmux htop python-pip
sudo pacman -S --noconfirm xsel i3-wm picom redshift

#----------------------------------------------------------------------------------------
# Install and configure neoVIM
#----------------------------------------------------------------------------------------
sudo pacman -S --noconfirm neovim ctags
sudo pacman -S --noconfirm python-pynvim

#----------------------------------------------------------------------------------------
# Colored git diff
#----------------------------------------------------------------------------------------
sudo wget -O /usr/local/bin/diff-so-fancy https://raw.githubusercontent.com/\
so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy
sudo chmod a+x /usr/local/bin/diff-so-fancy

#----------------------------------------------------------------------------------------
# Clean up && initialize
#----------------------------------------------------------------------------------------
cd ~/.dotfiles/
rm -rf $TMP_DIR
install/init.sh

# Optional
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup component add rls rust-src #rust-analysis
pip install 'python-language-server[all]'

echo "Installation complete. Restart your computer"

