#!/bin/bash
set -euo pipefail

sudo apt update && sudo apt install -y curl unzip
command -v fnm &>/dev/null || curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "$HOME/.local/bin" --skip-shell

"$HOME/.local/bin/fnm" install --lts
