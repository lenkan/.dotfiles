#!/bin/bash
set -euo pipefail

DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
# shellcheck source=SCRIPTDIR/../lib/distro.sh
. "$DIR/../lib/distro.sh"

case "$DOTFILES_FAMILY" in
debian) exec "$DIR/../lib/install-packages-ubuntu.sh" ;;
fedora) exec "$DIR/../lib/install-packages-fedora.sh" ;;
*) unsupported_distro ;;
esac
