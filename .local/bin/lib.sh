#!/bin/bash
# Shared helpers for the install-*.sh scripts. This file is meant to be sourced,
# not executed:
#
#   DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
#   # shellcheck source=lib.sh
#   . "$DIR/lib.sh"

# distro_family prints the packaging family for the running distro:
# "debian" (apt), "fedora" (dnf), or "unknown".
distro_family() {
	local ids
	# shellcheck disable=SC1091
	ids=$(. /etc/os-release 2>/dev/null && echo "${ID:-} ${ID_LIKE:-}")
	case " $ids " in
	*debian* | *ubuntu*) echo debian ;;
	*fedora* | *rhel* | *centos*) echo fedora ;;
	*) echo unknown ;;
	esac
}

# is_wsl succeeds when running under WSL.
is_wsl() {
	grep -qi microsoft /proc/version 2>/dev/null
}

# Resolve the family once so callers can branch on "$DISTRO_FAMILY".
DISTRO_FAMILY="${DISTRO_FAMILY:-$(distro_family)}"

# pkg_update refreshes the package metadata for the current family.
pkg_update() {
	case "$DISTRO_FAMILY" in
	debian) sudo apt-get update ;;
	fedora) sudo dnf -y makecache ;;
	*)
		echo "Unsupported distro family: $DISTRO_FAMILY" >&2
		return 1
		;;
	esac
}

# pkg_install installs the given packages for the current family.
pkg_install() {
	case "$DISTRO_FAMILY" in
	debian) sudo apt-get install -y "$@" ;;
	fedora) sudo dnf install -y "$@" ;;
	*)
		echo "Unsupported distro family: $DISTRO_FAMILY" >&2
		return 1
		;;
	esac
}

# apt_add_repo NAME KEY_URL REPO installs a dearmored signing key and a
# sources.list.d entry for an apt repo, skipping either step already in place.
# REPO is the deb line after the [options]: "<url> <suite> <components...>".
apt_add_repo() {
	local name="$1" key_url="$2" repo="$3"
	local keyring="/etc/apt/trusted.gpg.d/$name.gpg"
	local arch
	arch=$(dpkg --print-architecture)

	if [[ ! -f "$keyring" ]]; then
		curl -fsSL "$key_url" | gpg --dearmor | sudo tee "$keyring" >/dev/null
	fi
	if [[ ! -f "/etc/apt/sources.list.d/$name.list" ]]; then
		echo "deb [arch=$arch signed-by=$keyring] $repo" | sudo tee "/etc/apt/sources.list.d/$name.list" >/dev/null
	fi
}

# yum_add_repo_url NAME URL downloads a vendor-provided .repo file into
# /etc/yum.repos.d, once.
yum_add_repo_url() {
	local name="$1" url="$2"
	if [[ ! -f "/etc/yum.repos.d/$name.repo" ]]; then
		curl -fsSL "$url" | sudo tee "/etc/yum.repos.d/$name.repo" >/dev/null
	fi
}
