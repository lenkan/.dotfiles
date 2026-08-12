#!/bin/bash
set -euo pipefail

DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
# shellcheck source=lib.sh
. "$DIR/lib.sh"

case "$DISTRO_FAMILY" in
debian)
	apt_add_repo azure-cli https://packages.microsoft.com/keys/microsoft.asc \
		"https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main"
	;;
fedora)
	if [[ ! -f /etc/yum.repos.d/azure-cli.repo ]]; then
		sudo tee /etc/yum.repos.d/azure-cli.repo >/dev/null <<-'EOF'
			[azure-cli]
			name=Azure CLI
			baseurl=https://packages.microsoft.com/yumrepos/azure-cli
			enabled=1
			gpgcheck=1
			gpgkey=https://packages.microsoft.com/keys/microsoft.asc
		EOF
	fi
	;;
esac

pkg_update
pkg_install azure-cli
