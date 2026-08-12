#!/bin/bash
set -euo pipefail

DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
# shellcheck source=lib.sh
. "$DIR/lib.sh"

if is_wsl; then
	echo "Detected WSL — install Docker Desktop on Windows instead of the Linux package."
	exit 0
fi

case "$DISTRO_FAMILY" in
debian)
	apt_add_repo docker https://download.docker.com/linux/ubuntu/gpg \
		"https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
	;;
fedora)
	yum_add_repo_url docker-ce https://download.docker.com/linux/fedora/docker-ce.repo
	;;
esac

pkg_update
pkg_install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
