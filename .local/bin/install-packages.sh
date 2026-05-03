#!/bin/bash
set -euo pipefail

sudo apt-get update

sudo rm -rf /var/cache/snapd/
sudo apt-get autoremove --purge --ignore-missing snapd gnome-software-plugin-snap || true
rm -fr ~/snap
sudo apt-mark hold snapd

sudo apt-get install -y \
	ca-certificates \
	apt-transport-https \
	curl \
	git \
	gnupg \
	lsb-release \
	vim \
	tmux \
	xclip \
	jq \
	httpie \
	shellcheck \
	zip \
	unzip \
	shfmt \
	python3-dev \
	python3-pip \
	python3-setuptools \
	xdg-utils \
	keychain
