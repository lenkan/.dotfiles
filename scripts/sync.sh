#!/bin/bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." >/dev/null 2>&1 && pwd)"

pull_wsl=0
for arg in "$@"; do
	case "$arg" in
		--pull-wsl) pull_wsl=1 ;;
		*) echo "Unknown option: $arg" >&2; exit 1 ;;
	esac
done

if [ "$pull_wsl" -eq 1 ]; then
	if ! grep -qi microsoft /proc/version 2>/dev/null; then
		echo "--pull-wsl only works on WSL" >&2
		exit 1
	fi
	win_user=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')
	win_code="/mnt/c/Users/$win_user/AppData/Roaming/Code/User"
	if [ ! -d "$win_code" ]; then
		echo "Windows VS Code dir not found: $win_code" >&2
		exit 1
	fi
	for filename in "$DIR"/Code/User/*.json; do
		cp -v "$win_code/$(basename "$filename")" "$filename"
	done
	exit 0
fi

for filename in "$DIR"/.*; do
	if [ -f "$filename" ]; then
		ln -svf "$filename" "$HOME/$(basename "$filename")"
	fi
done

# Copy .local/bin scripts
mkdir -p "$HOME/.local/bin"
for filename in "$DIR"/.local/bin/*; do
	if [ -f "$filename" ]; then
		ln -svf "$filename" "$HOME/.local/bin/$(basename "$filename")"
	fi
done

# On WSL, deploy VS Code user config to the Windows-side path. Symlinks across
# /mnt/c don't work for VS Code, so copy.
if grep -qi microsoft /proc/version 2>/dev/null; then
	win_user=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')
	win_code="/mnt/c/Users/$win_user/AppData/Roaming/Code/User"
	if [ -d "$win_code" ]; then
		for filename in "$DIR"/Code/User/*.json; do
			cp -v "$filename" "$win_code/$(basename "$filename")"
		done
	else
		echo "Skipping VS Code sync: $win_code not found" >&2
	fi
fi
