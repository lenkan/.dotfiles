#!/bin/bash
set -euo pipefail

DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
# shellcheck source=SCRIPTDIR/../../scripts/lib/distro.sh
. "$DIR/../../scripts/lib/distro.sh"

# Builds Ghostty from source into ~/.local, per https://ghostty.org/docs/install/build.
# Each Ghostty release needs one exact Zig version (table on that page): bump both together.
ghostty_version=1.3.1
zig_version=0.15.2

# Public keys from ghostty.org/docs/install/build and ziglang.org/download
ghostty_key=RWQlAjJC23149WL2sEpT/l0QKy7hMIFhYdQOFy0Z7z7PbneUgvlsnYcV
zig_key=RWSGOq2NVecA2UPNdBUZykf1CCb147pkmdtYxgb3Ti+JO/wCYvhbAb/U

if [ "$DOTFILES_FAMILY" != fedora ] || is_wsl; then
	echo "Only for desktop Fedora. Elsewhere, install Ghostty with your package manager: https://ghostty.org/docs/install/binary" >&2
	exit 1
fi

if "$HOME/.local/bin/ghostty" +version 2>/dev/null | grep -qF "$ghostty_version"; then
	echo "Ghostty $ghostty_version is already installed."
	exit 0
fi

# Not dnf's zig: it is usually the wrong version
sudo dnf install -y gtk4-devel gtk4-layer-shell-devel libadwaita-devel gettext minisign

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
cd "$work"

download() {
	curl -fsSLO "$1"
	curl -fsSLO "$1.minisig"
	minisign -Vqm "$(basename "$1")" -P "$2"
	tar -xf "$(basename "$1")"
}

zig_dir="zig-$(uname -m)-linux-$zig_version"
download "https://ziglang.org/download/$zig_version/$zig_dir.tar.xz" "$zig_key"
download "https://release.files.ghostty.org/$ghostty_version/ghostty-$ghostty_version.tar.gz" "$ghostty_key"

cd "ghostty-$ghostty_version"
"$work/$zig_dir/zig" build -p "$HOME/.local" -Doptimize=ReleaseFast

echo "Installed $("$HOME/.local/bin/ghostty" +version | head -1). It shows up in the app launcher after logging out and in."
