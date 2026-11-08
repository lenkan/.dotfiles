#!/bin/bash
set -euo pipefail

DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
# shellcheck source=SCRIPTDIR/../lib/distro.sh
. "$DIR/../lib/distro.sh"

# Nerd Fonts' Source Code Pro, for Alacritty's icons (Ghostty has them built in).
# Not the Mono variant: it shrinks icons to one cell.
family='SauceCodePro Nerd Font'

if is_wsl; then
	echo "On WSL the terminal runs on Windows: install $family there and pick it in Windows Terminal." >&2
	exit 1
fi

if fc-list : family | grep -qF "$family"; then
	echo "$family is already installed."
	exit 0
fi

dest="$HOME/.local/share/fonts/SauceCodeProNerdFont"
mkdir -p "$dest"
curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/SourceCodePro.tar.xz | tar -xJ -C "$dest"
fc-cache -f "$dest"
echo "Installed $family."
