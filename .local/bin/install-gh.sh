#!/bin/bash
set -euo pipefail

DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
# shellcheck source=lib.sh
. "$DIR/lib.sh"

case "$DISTRO_FAMILY" in
debian)
	apt_add_repo githubcli https://cli.github.com/packages/githubcli-archive-keyring.gpg \
		"https://cli.github.com/packages stable main"
	;;
fedora)
	yum_add_repo_url gh-cli https://cli.github.com/packages/rpm/gh-cli.repo
	;;
esac

pkg_update
pkg_install gh
