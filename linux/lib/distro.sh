# shellcheck shell=bash
# Source, don't execute. Sourcing /etc/os-release also leaks NAME/VERSION/ID
# into the caller — avoid those names in scripts that source this.

if [ -r /etc/os-release ]; then
	# shellcheck disable=SC1091
	. /etc/os-release
fi

DOTFILES_ID="${ID:-unknown}"

# shellcheck disable=SC2034 # read by the scripts that source this
case " ${ID:-} ${ID_LIKE:-} " in
*" fedora "* | *" rhel "*) DOTFILES_FAMILY=fedora ;;
*" debian "* | *" ubuntu "*) DOTFILES_FAMILY=debian ;;
*) DOTFILES_FAMILY=unknown ;;
esac

is_wsl() {
	[ -n "${WSL_DISTRO_NAME:-}" ] || grep -qi microsoft /proc/version 2>/dev/null
}

unsupported_distro() {
	echo "Unsupported distro: $DOTFILES_ID (need a debian- or fedora-family system)" >&2
	exit 1
}

# add_apt_repo <list-name> <keyring-name> <key-url> <repo-url> <suite> [component...]
# Keyring is named separately because several repos share one vendor key.
# Argument order matches add_rpm_repo: names, then key URL, then repo URL.
add_apt_repo() {
	local list="$1" key_name="$2" key_url="$3" repo_url="$4" suite="$5"
	shift 5
	local keyring="/etc/apt/keyrings/$key_name.gpg"

	sudo install -d -m 0755 /etc/apt/keyrings
	if [ ! -f "$keyring" ]; then
		curl -fsSL "$key_url" | sudo gpg --dearmor -o "$keyring"
		sudo chmod go+r "$keyring"
	fi

	echo "deb [arch=$(dpkg --print-architecture) signed-by=$keyring] $repo_url $suite $*" |
		sudo tee "/etc/apt/sources.list.d/$list.list" >/dev/null
}

# add_rpm_repo <repo-name> <display-name> <key-url> <repo-url>
add_rpm_repo() {
	local name="$1" display="$2" gpgkey="$3" baseurl="$4"

	sudo rpm --import "$gpgkey"
	sudo tee "/etc/yum.repos.d/$name.repo" >/dev/null <<-EOF
		[$name]
		name=$display
		baseurl=$baseurl
		enabled=1
		gpgcheck=1
		gpgkey=$gpgkey
	EOF
}
