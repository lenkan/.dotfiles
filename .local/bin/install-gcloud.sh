#!/bin/bash
set -euo pipefail

DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
# shellcheck source=lib.sh
. "$DIR/lib.sh"

case "$DISTRO_FAMILY" in
debian)
	arch=$(dpkg --print-architecture)
	gpgdir="/etc/apt/trusted.gpg.d"

	if [[ ! -f "$gpgdir/cloud.google.gpg" ]]; then
		curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor | sudo tee "$gpgdir/cloud.google.gpg" >/dev/null
	fi
	if [[ ! -f /etc/apt/sources.list.d/google-cloud-sdk.list ]]; then
		echo "deb [arch=$arch signed-by=$gpgdir/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list >/dev/null
	fi
	;;
fedora)
	if [[ ! -f /etc/yum.repos.d/google-cloud-sdk.repo ]]; then
		sudo tee /etc/yum.repos.d/google-cloud-sdk.repo >/dev/null <<-'EOF'
			[google-cloud-cli]
			name=Google Cloud CLI
			baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el9-x86_64
			enabled=1
			gpgcheck=1
			repo_gpgcheck=0
			gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
		EOF
	fi
	;;
*)
	echo "Unsupported distro family: $DISTRO_FAMILY" >&2
	exit 1
	;;
esac

pkg_update
pkg_install google-cloud-cli
