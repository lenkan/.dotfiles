#!/bin/bash
set -euo pipefail

arch=$(dpkg --print-architecture)
gpgdir="/etc/apt/trusted.gpg.d"

if [[ ! -f "$gpgdir/packages.microsoft.gpg" ]]; then
	curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee "$gpgdir/packages.microsoft.gpg" >/dev/null
fi
if [[ ! -f /etc/apt/sources.list.d/azure-cli.list ]]; then
	echo "deb [arch=$arch signed-by=$gpgdir/packages.microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/azure-cli.list >/dev/null
fi

sudo apt-get update
sudo apt-get install -y azure-cli
