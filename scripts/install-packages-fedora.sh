#!/bin/bash
set -euo pipefail

# The Fedora WSL image is built from the container rootfs, so it lacks things a
# normal install has: procps-ng, hostname, which, diffutils, tar, findutils,
# ncurses (tput, used by .bash_prompt), and any locale beyond C.
sudo dnf install -y \
	ShellCheck \
	bat \
	bubblewrap \
	ca-certificates \
	curl \
	diffutils \
	findutils \
	gh \
	git \
	glibc-langpack-en \
	gnupg2 \
	hostname \
	httpie \
	jq \
	keychain \
	ncurses \
	procps-ng \
	python3-devel \
	python3-pip \
	python3-setuptools \
	shfmt \
	socat \
	tar \
	tmux \
	unzip \
	vim-enhanced \
	which \
	wl-clipboard \
	xclip \
	xdg-utils \
	zip
