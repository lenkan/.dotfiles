#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

add_repo() {
	local gpg_url=$1
	local gpg_name=$2
	local source_file=$3
	local source_content=$4
	local gpgdir="/etc/apt/trusted.gpg.d"

	if [[ ! -f "$gpgdir/$gpg_name" ]]; then
		mkdir -p "$DIR/tmp"
		curl -fsSL "$gpg_url" | gpg --dearmor >"$DIR/tmp/$gpg_name"
		sudo install -o root -g root -m 644 "$DIR/tmp/$gpg_name" "$gpgdir"
	fi

	[[ -f "$source_file" ]] && return 0

	local domain
	domain=$(printf '%s' "$source_content" | grep -oP 'https://[^/\s]+' | sed 's|https://||')
	if [[ -n "$domain" ]] && grep -rql "$domain" /etc/apt/sources.list.d/ 2>/dev/null; then
		echo "Source for $domain already configured, skipping."
		return 0
	fi

	printf '%s\n' "$source_content" | sudo tee "$source_file" >/dev/null
}

sudo rm -rf /var/cache/snapd/
sudo apt-get autoremove --purge --ignore-missing snapd gnome-software-plugin-snap || true
rm -fr ~/snap
sudo apt-mark hold snapd

sudo apt-get update
sudo apt-get install -y \
	ca-certificates \
	apt-transport-https \
	curl \
	git \
	gnupg \
	lsb-release

arch=$(dpkg --print-architecture)
gpgdir="/etc/apt/trusted.gpg.d"
dist=$(lsb_release -cs)

add_repo \
	"https://cli.github.com/packages/githubcli-archive-keyring.gpg" "githubcli.gpg" \
	/etc/apt/sources.list.d/github-cli.list \
	"deb [arch=$arch signed-by=$gpgdir/githubcli.gpg] https://cli.github.com/packages stable main"
add_repo \
	"https://packages.microsoft.com/keys/microsoft.asc" "packages.microsoft.gpg" \
	/etc/apt/sources.list.d/vscode.list \
	"deb [arch=$arch signed-by=$gpgdir/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main"
add_repo \
	"https://packages.microsoft.com/keys/microsoft.asc" \
	"packages.microsoft.gpg" \
	/etc/apt/sources.list.d/azure-cli.list \
	"deb [arch=$arch signed-by=$gpgdir/packages.microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $dist main"
add_repo \
	"https://download.docker.com/linux/ubuntu/gpg" \
	"docker.gpg" \
	/etc/apt/sources.list.d/docker.list \
	"deb [arch=$arch signed-by=$gpgdir/docker.gpg] https://download.docker.com/linux/ubuntu $dist stable"
add_repo \
	"https://packages.cloud.google.com/apt/doc/apt-key.gpg" \
	"cloud.google.gpg" \
	/etc/apt/sources.list.d/google-cloud-sdk.list \
	"deb [arch=$arch signed-by=$gpgdir/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main"

sudo apt-get update
sudo apt-get install -y \
	vim \
	tmux \
	xclip \
	jq \
	httpie \
	gh \
	shellcheck \
	zip \
	unzip \
	shfmt \
	python3-dev \
	python3-pip \
	python3-setuptools \
	xdg-utils \
	keychain \
	gnome-keyring \
	libsecret-1-0
