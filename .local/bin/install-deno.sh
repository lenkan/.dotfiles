#!/bin/bash
set -euo pipefail

# --no-modify-path: .bashrc already puts ~/.deno/bin on PATH; the installer would
# otherwise append its own line to the rc files symlinked into this repo
command -v deno &>/dev/null || curl -fsSL https://deno.land/install.sh | sh -s -- -y --no-modify-path
