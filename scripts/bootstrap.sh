#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

if grep -qi microsoft /proc/version 2>/dev/null; then
	echo "On WSL!"
	echo "$(whoami) ALL=(ALL) NOPASSWD:ALL" | sudo tee "/etc/sudoers.d/$(whoami)" >/dev/null
	sudo passwd -d "$(whoami)"
	sudo tee /etc/wsl.conf >/dev/null <<-EOF
		[boot]
		systemd=true

		[network]
		hostname=${WSL_DISTRO_NAME}
		generateHosts=true

		[user]
		default=$(whoami)
	EOF

	# Keep Windows interop registered under systemd — systemd-binfmt rebuilds
	# binfmt_misc from *.conf files and otherwise drops the handler WSL set up.
	echo ':WSLInterop:M::MZ::/init:PF' | sudo tee /usr/lib/binfmt.d/WSLInterop.conf >/dev/null
	if [ ! -e /proc/sys/fs/binfmt_misc/WSLInterop ]; then
		echo ':WSLInterop:M::MZ::/init:PF' | sudo tee /proc/sys/fs/binfmt_misc/register >/dev/null
	fi
else
	echo "Not on WSL!"
fi

"$DIR/sync.sh"
"$DIR/../.local/bin/install-packages.sh"
