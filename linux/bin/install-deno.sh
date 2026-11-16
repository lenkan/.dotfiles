#!/bin/bash
set -euo pipefail

command -v deno &>/dev/null || curl --proto '=https' --tlsv1.2 -fsSL https://deno.land/install.sh | sh -s -- -y --no-modify-path
