#!/bin/bash
set -euo pipefail

command -v deno &>/dev/null || curl -fsSL https://deno.land/install.sh | sh
