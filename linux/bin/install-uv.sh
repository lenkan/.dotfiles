#!/bin/bash
set -euo pipefail

command -v uv &>/dev/null || curl --proto '=https' --tlsv1.2 -LsSf https://astral.sh/uv/install.sh | sh -s -- --no-modify-path
