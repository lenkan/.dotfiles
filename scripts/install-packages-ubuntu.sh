#!/bin/bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=SCRIPTDIR/lib/distro.sh
. "$DIR/lib/distro.sh"

sudo apt-get update

sudo rm -rf /var/cache/snapd/
sudo apt-get autoremove --purge --ignore-missing snapd gnome-software-plugin-snap || true
rm -fr ~/snap
sudo apt-mark hold snapd

sudo apt-get install -y ca-certificates curl gnupg

# Ubuntu 24.04 ships gh 2.45; the GitHub repo tracks upstream.
add_apt_repo github-cli githubcli \
	https://cli.github.com/packages/githubcli-archive-keyring.gpg \
	https://cli.github.com/packages stable main

sudo apt-get update
sudo apt-get install -y \
	bat \
	bubblewrap \
	gh \
	git \
	httpie \
	jq \
	keychain \
	ncurses-term \
	python3-dev \
	python3-pip \
	python3-setuptools \
	shellcheck \
	shfmt \
	socat \
	tmux \
	unzip \
	vim \
	wl-clipboard \
	xclip \
	xdg-utils \
	zip

# Debian ships the bat binary as batcat. Symlink rather than alias so scripts
# and non-interactive shells see it too.
if ! command -v bat >/dev/null 2>&1 && command -v batcat >/dev/null 2>&1; then
	mkdir -p "$HOME/.local/bin"
	ln -svf "$(command -v batcat)" "$HOME/.local/bin/bat"
fi
