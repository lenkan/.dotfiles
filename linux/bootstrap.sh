#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
# shellcheck source=SCRIPTDIR/lib/distro.sh
. "$DIR/lib/distro.sh"

if [ "$DOTFILES_FAMILY" = unknown ]; then
	unsupported_distro
fi

"$DIR/../scripts/sync.sh"
"$DIR/bin/install-packages.sh"
