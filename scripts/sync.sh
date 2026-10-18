#!/bin/bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." >/dev/null 2>&1 && pwd)"
# shellcheck source=SCRIPTDIR/../linux/lib/distro.sh
. "$DIR/linux/lib/distro.sh"

if [ $# -gt 0 ]; then
	echo "Usage: sync.sh" >&2
	exit 1
fi

# Platform directories to link, in order
if [ "$(uname -s)" = Darwin ]; then
	platforms=(macos)
elif is_wsl; then
	platforms=(linux wsl)
else
	platforms=(linux)
fi

linked_dirs=()

# link_into <destdir> <src>...
link_into() {
	local destdir="$1" target src
	shift
	linked_dirs+=("$destdir")
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
# .gitignore is this repo's own, not a global one.
for filename in "$DIR"/.*; do
	name="${filename##*/}"
	if [ -f "$filename" ] && [ "$name" != .gitignore ]; then
		ln -svf "$filename" "$HOME/$name"
	fi
done

config="${XDG_CONFIG_HOME:-$HOME/.config}"

link_into "$HOME/.local/bin" "$DIR"/bin/*
# Ghostty reads ~/.config/ghostty on macOS too
link_into "$config" "$DIR"/nvim "$DIR"/ghostty
link_into "$config/opencode/skills" "$DIR"/opencode/skills/*

# Each platform links its bin/ and may add a sync.sh for anything else
for platform in "${platforms[@]}"; do
	link_into "$HOME/.local/bin" "$DIR/$platform"/bin/*
	# shellcheck source=/dev/null
	[ -f "$DIR/$platform/sync.sh" ] && . "$DIR/$platform/sync.sh"
done

# Remove links into this repo whose target was moved or deleted
prune() {
	local link
	for link in "$@"; do
		if [ -L "$link" ] && [ ! -e "$link" ]; then
			case "$(readlink "$link")" in
			"$DIR"/*) rm -v "$link" ;;
			esac
		fi
	done
}

prune "$HOME"/.*
for dir in "${linked_dirs[@]}"; do
	prune "$dir"/*
done
