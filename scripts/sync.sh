#!/bin/bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." >/dev/null 2>&1 && pwd)"
# shellcheck source=SCRIPTDIR/lib/distro.sh
. "$DIR/scripts/lib/distro.sh"

if [ $# -gt 0 ]; then
	echo "Usage: sync.sh" >&2
	exit 1
fi

# link_into <destdir> <src>...
link_into() {
	local destdir="$1" target src
	shift
	mkdir -p "$destdir"
	for src in "$@"; do
		[ -e "$src" ] || continue
		target="$destdir/$(basename "$src")"
		if [ -e "$target" ] && [ ! -L "$target" ]; then
			echo "Skipping $target: exists and is not a symlink, remove it to link" >&2
			continue
		fi
		ln -svfn "$src" "$target"
	done
}

# [ -f ] is load-bearing: `.*` also matches .git and .local.
for filename in "$DIR"/.*; do
	if [ -f "$filename" ]; then
		ln -svf "$filename" "$HOME/$(basename "$filename")"
	fi
done

link_into "$HOME/.local/bin" "$DIR"/.local/bin/*

link_into "$HOME/.claude" "$DIR"/claude/*

# VS Code on WSL runs on the Windows side and won't follow symlinks across /mnt/c.
if is_wsl; then
	win_user=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')
	win_code="/mnt/c/Users/$win_user/AppData/Roaming/Code/User"
	if [ -d "$win_code" ]; then
		for filename in "$DIR"/Code/User/*.json; do
			cp -v "$filename" "$win_code/$(basename "$filename")"
		done
	else
		echo "Skipping VS Code sync: $win_code not found" >&2
	fi
else
	link_into "${XDG_CONFIG_HOME:-$HOME/.config}/Code/User" "$DIR"/Code/User/*.json
fi
