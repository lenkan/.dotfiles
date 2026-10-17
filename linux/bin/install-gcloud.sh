#!/bin/bash
set -euo pipefail

case "$(uname -m)" in
x86_64) arch=x86_64 ;;
aarch64) arch=arm ;;
*)
	echo "Unsupported architecture: $(uname -m)" >&2
	exit 1
	;;
esac

install_dir="$HOME/.local/share"
sdk_dir="$install_dir/google-cloud-sdk"

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

curl -fsSL -o "$tmp/gcloud.tar.gz" \
	"https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-$arch.tar.gz"

mkdir -p "$install_dir"
rm -rf "$sdk_dir"
tar -xzf "$tmp/gcloud.tar.gz" -C "$install_dir"

"$sdk_dir/install.sh" --quiet --path-update false --command-completion false --usage-reporting false

mkdir -p "$HOME/.local/bin"
for bin in gcloud gsutil bq; do
	ln -svf "$sdk_dir/bin/$bin" "$HOME/.local/bin/$bin"
done
