#!/bin/bash
set -euo pipefail

DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
# shellcheck source=SCRIPTDIR/../../scripts/lib/distro.sh
. "$DIR/../../scripts/lib/distro.sh"

# Source Code Pro with icons for nvim. Nerd Fonts renames it to SauceCodePro.
# The Mono variant keeps icons one cell wide, which terminals need.
family='SauceCodePro Nerd Font Mono'

if is_wsl; then
	echo "On WSL the terminal runs on Windows: install $family there and pick it in Windows Terminal." >&2
	exit 1
fi

if ! fc-list : family | grep -qF "$family"; then
	dest="$HOME/.local/share/fonts/SauceCodeProNerdFont"
	mkdir -p "$dest"
	curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/SourceCodePro.tar.xz | tar -xJ -C "$dest"
	fc-cache -f "$dest"
fi

if gsettings list-schemas 2>/dev/null | grep -qx org.gnome.Ptyxis; then
	gsettings set org.gnome.Ptyxis use-system-font false
	gsettings set org.gnome.Ptyxis font-name "$family Medium 10"
fi
