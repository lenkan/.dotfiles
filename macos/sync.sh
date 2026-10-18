# shellcheck shell=bash
# Sourced by scripts/sync.sh
# macOS ignores symlinked keyboard layouts
mkdir -p "$HOME/Library/Keyboard Layouts"
cp -v "$DIR/macos/Keyboard Layouts/"* "$HOME/Library/Keyboard Layouts/"
