#!/bin/bash
set -euo pipefail

DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
# shellcheck source=lib.sh
. "$DIR/lib.sh"

pkg_update
pkg_install curl unzip
rm -rf "$HOME/.nvm"

command -v fnm &>/dev/null || curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "$HOME/.local/bin" --skip-shell

"$HOME/.local/bin/fnm" install --lts
