#!/bin/bash
set -euo pipefail

DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
# shellcheck source=lib.sh
. "$DIR/lib.sh"

if is_wsl; then
	echo "Detected WSL — install Docker Desktop on Windows instead of the Linux package."
	exit 0
fi

packages=(docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin)

case "$DISTRO_FAMILY" in
debian)
	arch=$(dpkg --print-architecture)
	gpgdir="/etc/apt/trusted.gpg.d"

	if [[ ! -f "$gpgdir/docker.gpg" ]]; then
		curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor | sudo tee "$gpgdir/docker.gpg" >/dev/null
	fi
	if [[ ! -f /etc/apt/sources.list.d/docker.list ]]; then
		echo "deb [arch=$arch signed-by=$gpgdir/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
	fi
	;;
fedora)
	if [[ ! -f /etc/yum.repos.d/docker-ce.repo ]]; then
		curl -fsSL https://download.docker.com/linux/fedora/docker-ce.repo | sudo tee /etc/yum.repos.d/docker-ce.repo >/dev/null
	fi
	;;
*)
	echo "Unsupported distro family: $DISTRO_FAMILY" >&2
	exit 1
	;;
esac

pkg_update
pkg_install "${packages[@]}"
