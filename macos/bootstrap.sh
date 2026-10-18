#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

if [ "$(uname -s)" != Darwin ]; then
	echo "Not on macOS." >&2
	exit 1
fi

exec "$DIR/../scripts/sync.sh"
