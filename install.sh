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

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

sudo pacman -S --noconfirm alacritty
sudo pacman -S --noconfirm ripgrep fd bat fzf # exa runiq ion watchexec
sudo pacman -S --noconfirm tmux htop python-pip
sudo pacman -S --noconfirm redshift rust-analyzer


# Brightness keys
sudo pacman -S --no-confirm xorg-xbacklight

# Sound managing
sudo pacman -S --no-confirm pa-applet pavucontrol

# Bluetooth
sudo pacman -S --no-confirm blueman pulseaudio-bluetooth

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
rustup component add rust-src #rust-analysis
pip install 'python-language-server[all]'

echo "Installation complete. Restart your computer"

