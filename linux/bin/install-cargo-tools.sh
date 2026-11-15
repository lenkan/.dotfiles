#!/bin/bash
set -euo pipefail

DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
"$DIR/install-rust.sh"

# shellcheck source=/dev/null
. "$HOME/.cargo/env"
# Skips tools that are up to date, updates the rest
cargo install --locked sd fastmod
