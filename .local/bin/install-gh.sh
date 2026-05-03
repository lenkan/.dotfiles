#!/bin/bash
set -euo pipefail

arch=$(dpkg --print-architecture)
gpgdir="/etc/apt/trusted.gpg.d"

if [[ ! -f "$gpgdir/githubcli.gpg" ]]; then
	curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor | sudo tee "$gpgdir/githubcli.gpg" >/dev/null
fi
if [[ ! -f /etc/apt/sources.list.d/github-cli.list ]]; then
	echo "deb [arch=$arch signed-by=$gpgdir/githubcli.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
fi

sudo apt-get update
sudo apt-get install -y gh
