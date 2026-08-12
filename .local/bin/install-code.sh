#!/bin/bash
set -euo pipefail

DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
# shellcheck source=lib.sh
. "$DIR/lib.sh"

case "$DISTRO_FAMILY" in
debian)
	apt_add_repo vscode https://packages.microsoft.com/keys/microsoft.asc \
		"https://packages.microsoft.com/repos/code stable main"
	;;
fedora)
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
esac

pkg_update
pkg_install code
