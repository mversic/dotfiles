#!/bin/sh

set -e

DOTFILES=$HOME/.dotfiles

command_exists() {
    type "$1" > /dev/null 2>&1
}

#echo "Initializing submodule(s)"
#echo "=============================="
#git submodule update --init --recursive

echo -e "\n\nSettign up ZSH shell"
echo "=============================="
if ! command_exists zsh; then
    echo "ZSH not found. Installing ZSH:"
    sudo pacman -Sy --noconfirm zsh
fi
if ! [[ $SHELL =~ .*zsh.* ]]; then
    echo "Setting ZSH as default shell:"
    chsh --shell $(which zsh)
    echo "To use new shell restart session"
fi

##############################
## Configuration
##############################
echo -e "\n\nLinking configuration files"
echo "=============================="

$DOTFILES/zsh/init.sh
$DOTFILES/tmux/init.sh
$DOTFILES/git/init.sh

for config in "$DOTFILES"/config/*; do
    target=$HOME/.config/$( basename $config )

    if [ -e "$target" ]; then
        rm -rf $target
    fi

    ln -s $config $target
done

# Install neovim plugins
nvim +PluginInstall +UpdateRemotePlugins +qall

echo "Done. Reload your terminal."

