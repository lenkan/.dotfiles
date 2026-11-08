# shellcheck shell=bash
# Sourced by scripts/sync.sh
link_into "$HOME/.claude" "$DIR"/claude/*
link_into "${XDG_CONFIG_HOME:-$HOME/.config}" "$DIR"/linux/alacritty
