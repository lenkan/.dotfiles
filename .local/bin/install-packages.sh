#!/bin/bash
set -euo pipefail

DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
# shellcheck source=lib.sh
. "$DIR/lib.sh"

# Packages common to every distro, using each family's name for the package.
common=(
	ca-certificates
	curl
	git
	tmux
	xclip
	jq
	httpie
	zip
	unzip
	shfmt
	python3-pip
	python3-setuptools
	xdg-utils
	bubblewrap
	socat
	keychain
)

case "$DISTRO_FAMILY" in
debian)
	pkg_update

	# Ubuntu ships snap; rip it out so packages come from apt only.
	sudo rm -rf /var/cache/snapd/
	sudo apt-get autoremove --purge --ignore-missing snapd gnome-software-plugin-snap || true
	rm -fr ~/snap
	sudo apt-mark hold snapd

	pkg_install \
		"${common[@]}" \
		vim \
		apt-transport-https \
		gnupg \
		lsb-release \
		shellcheck \
		python3-dev
	;;
fedora)
	pkg_update

	pkg_install \
		"${common[@]}" \
		vim-enhanced \
		gnupg2 \
		ShellCheck \
		python3-devel
	;;
*)
	echo "Unsupported distro family: $DISTRO_FAMILY" >&2
	exit 1
	;;
esac
