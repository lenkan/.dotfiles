#!/bin/bash
set -euo pipefail

DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
# shellcheck source=SCRIPTDIR/../../scripts/lib/distro.sh
. "$DIR/../../scripts/lib/distro.sh"

case "$DOTFILES_FAMILY" in
fedora)
	add_rpm_repo vscode "Visual Studio Code" \
		https://packages.microsoft.com/keys/microsoft.asc \
		https://packages.microsoft.com/yumrepos/vscode
	sudo dnf install -y code
	;;
debian)
	add_apt_repo vscode microsoft \
		https://packages.microsoft.com/keys/microsoft.asc \
		https://packages.microsoft.com/repos/code stable main
	sudo apt-get update
	sudo apt-get install -y code
	;;
*) unsupported_distro ;;
esac
