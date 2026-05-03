#!/bin/bash
set -euo pipefail

command -v uv &>/dev/null || curl -LsSf https://astral.sh/uv/install.sh | sh -s -- --no-modify-path
