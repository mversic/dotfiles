#!/bin/sh

TMUX_DIR=$(dirname ${BASH_SOURCE[0]})

rm -rf "$HOME/.tmux.conf"
ln -s "$TMUX_DIR/tmux.conf" ~/.tmux.conf
