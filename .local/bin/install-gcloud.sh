#!/bin/bash
set -euo pipefail

arch=$(dpkg --print-architecture)
gpgdir="/etc/apt/trusted.gpg.d"

if [[ ! -f "$gpgdir/cloud.google.gpg" ]]; then
	curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor | sudo tee "$gpgdir/cloud.google.gpg" >/dev/null
fi
if [[ ! -f /etc/apt/sources.list.d/google-cloud-sdk.list ]]; then
	echo "deb [arch=$arch signed-by=$gpgdir/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list >/dev/null
fi

sudo apt-get update
sudo apt-get install -y google-cloud-cli
