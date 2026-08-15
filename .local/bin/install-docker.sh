#!/bin/bash
set -euo pipefail

curl -fsSL https://get.docker.com | sh

sudo usermod -aG docker "$USER"

# The convenience script leaves the service stopped on rpm-based distros.
if command -v systemctl >/dev/null 2>&1; then
	sudo systemctl enable --now docker
fi

echo "Log out and back in for the docker group to take effect."
