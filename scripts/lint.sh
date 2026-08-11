#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

files=(
	"$root"/.bash_aliases
	"$root"/.bash_profile
	"$root"/.bash_prompt
	"$root"/.bashrc
	"$root"/scripts/*.sh
	"$root"/.local/bin/*
)

echo "==> shellcheck"
shellcheck "${files[@]}"

echo "==> shfmt"
shfmt --diff "${files[@]}"

echo "All checks passed."
