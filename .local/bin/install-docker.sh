#!/bin/bash
set -euo pipefail

if grep -qi microsoft /proc/sys/kernel/osrelease 2>/dev/null; then
	echo "Detected WSL — install Docker Desktop on Windows instead of the Linux package."
	exit 0
fi

arch=$(dpkg --print-architecture)
gpgdir="/etc/apt/trusted.gpg.d"

if [[ ! -f "$gpgdir/docker.gpg" ]]; then
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor | sudo tee "$gpgdir/docker.gpg" >/dev/null
fi
if [[ ! -f /etc/apt/sources.list.d/docker.list ]]; then
	echo "deb [arch=$arch signed-by=$gpgdir/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
fi

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
