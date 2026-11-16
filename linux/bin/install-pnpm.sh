#!/bin/bash
set -euo pipefail

# Check the standalone binary, not `command -v pnpm`, so a corepack shim doesn't count
if [ ! -x "${PNPM_HOME:-$HOME/.local/share/pnpm}/bin/pnpm" ]; then
	curl --proto '=https' --tlsv1.2 -fsSL https://get.pnpm.io/install.sh | PNPM_NO_MODIFY_PATH=1 sh -
fi
