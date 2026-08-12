#!/bin/bash
set -euo pipefail

DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
# shellcheck source=lib.sh
. "$DIR/lib.sh"

case "$DISTRO_FAMILY" in
debian)
	arch=$(dpkg --print-architecture)
	gpgdir="/etc/apt/trusted.gpg.d"

	if [[ ! -f "$gpgdir/packages.microsoft.gpg" ]]; then
		curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee "$gpgdir/packages.microsoft.gpg" >/dev/null
	fi
	if [[ ! -f /etc/apt/sources.list.d/vscode.list ]]; then
		echo "deb [arch=$arch signed-by=$gpgdir/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
	fi
	;;
fedora)
	sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
	if [[ ! -f /etc/yum.repos.d/vscode.repo ]]; then
		sudo tee /etc/yum.repos.d/vscode.repo >/dev/null <<-'EOF'
			[code]
			name=Visual Studio Code
			baseurl=https://packages.microsoft.com/yumrepos/vscode
			enabled=1
			autorefresh=1
			gpgcheck=1
			gpgkey=https://packages.microsoft.com/keys/microsoft.asc
		EOF
	fi
	;;
*)
	echo "Unsupported distro family: $DISTRO_FAMILY" >&2
	exit 1
	;;
esac

pkg_update
pkg_install code
