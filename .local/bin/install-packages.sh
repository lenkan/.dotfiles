#!/bin/bash
set -euo pipefail

DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../../scripts" && pwd)"
# shellcheck source=SCRIPTDIR/../../scripts/lib/distro.sh
. "$DIR/lib/distro.sh"

case "$DOTFILES_FAMILY" in
debian) exec "$DIR/install-packages-ubuntu.sh" ;;
fedora) exec "$DIR/install-packages-fedora.sh" ;;
*) unsupported_distro ;;
esac
