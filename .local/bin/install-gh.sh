#!/bin/bash
set -euo pipefail

DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
# shellcheck source=lib.sh
. "$DIR/lib.sh"

case "$DISTRO_FAMILY" in
debian)
	arch=$(dpkg --print-architecture)
	gpgdir="/etc/apt/trusted.gpg.d"

	if [[ ! -f "$gpgdir/githubcli.gpg" ]]; then
		curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor | sudo tee "$gpgdir/githubcli.gpg" >/dev/null
	fi
	if [[ ! -f /etc/apt/sources.list.d/github-cli.list ]]; then
		echo "deb [arch=$arch signed-by=$gpgdir/githubcli.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
	fi
	;;
fedora)
	if [[ ! -f /etc/yum.repos.d/gh-cli.repo ]]; then
		curl -fsSL https://cli.github.com/packages/rpm/gh-cli.repo | sudo tee /etc/yum.repos.d/gh-cli.repo >/dev/null
	fi
	;;
*)
	echo "Unsupported distro family: $DISTRO_FAMILY" >&2
	exit 1
	;;
esac

pkg_update
pkg_install gh
