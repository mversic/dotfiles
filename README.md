# Dotfiles

## Contents

+ [Initial Setup and Installation](#initial-setup-and-installation)
+ [ZSH Setup](#zsh-setup)
+ [Vim and Neovim Setup](#vim-and-neovim-setup)
+ [Fonts](#fonts)
+ [Tmux](#tmux-configuration)

## Initial Setup and Installation

### Backup
Before installation configuration files are automatically backed up into `~/dotfiles_bak` directory.

### Installation

```
   git clone https://github.com/nicknisi/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ./install.sh
```

`install.sh` will initialize all submodules in this repository. Then, it will install all symbolic links into your home directory. Every file with a `.symlink` extension will be linked to the home directory with a `.` in front of it. As an example, `zshrc.symlink` will be symlinked in the home directory as `~/.zshrc`. Additionally, all files in the `$DOTFILES/config` directory will be symlinked to the `~/.config/` directory for applications that follow the [XDG base directory specification](http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html), such as neovim.

## ZSH Setup

ZSH configuration resides in the `zshrc.symlink` file. Summary of configuration in this file:

* set the `EDITOR` to nvim
* Load any `~/.terminfo` setup
* Setup ZIM lightweight framework
* Fast and minimal prompt with git-info and suspended jobs number shown

## Vim and Neovim Setup

[Neovim](https://neovim.io/) is a compatible drop-in refactor of vim without BDFL. Neovim uses the [XDG base directory specification](http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html) which means it's configuration is defined in `~/.config/nvim/init.vim`. I consider performance of the editor to be of great concern so therefore configuration of nvim is kept minimal without super-fancy looks and other eye-candy or unrequired bloat.

## Tmux Configuration

Tmux is configured in [~/.tmux.conf](tmux/tmux.conf.symlink), and in [tmux/theme.sh](tmux/theme.conf), which defines colores used(solarized) the layout of tmuxline. Tmux is automatically started when starting terminal with an initial vertical split
