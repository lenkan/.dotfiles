#!/bin/bash
set -euo pipefail

DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
# shellcheck source=lib.sh
. "$DIR/lib.sh"

case "$DISTRO_FAMILY" in
debian)
	apt_add_repo google-cloud-sdk https://packages.cloud.google.com/apt/doc/apt-key.gpg \
		"https://packages.cloud.google.com/apt cloud-sdk main"
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
esac

pkg_update
pkg_install google-cloud-cli
