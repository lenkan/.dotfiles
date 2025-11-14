#!/bin/bash
set -e

arch=$(dpkg --print-architecture)
gpgdir="/etc/apt/trusted.gpg.d"
dist=$(lsb_release -cs)

install_gpg() {
    url=$1
    name=$2

    if [[ -z $url || -z $name ]]; then
        echo "Usage: install_gpg <url> <name>"
        return 1
    fi

    mkdir -p tmp
    out="tmp/$name"

    if [[ -f "$gpgdir/$name" ]]; then
        echo "GPG key $name already exists, skipping download."
        return 0
    fi

    wget -qO- "$url" | gpg --dearmor >"$out"
    sudo install -o root -g root -m 644 "$out" "$gpgdir"
}

install_gpg "https://cli.github.com/packages/githubcli-archive-keyring.gpg" "githubcli.gpg"
install_gpg "https://packages.microsoft.com/keys/microsoft.asc" "packages.microsoft.gpg"
install_gpg "https://download.docker.com/linux/ubuntu/gpg" "docker.gpg"
install_gpg "https://downloads.1password.com/linux/keys/1password.asc" "1password.gpg"

echo "deb [arch=$arch signed-by=$gpgdir/githubcli.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list
echo "deb [arch=$arch signed-by=$gpgdir/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
echo "deb [arch=$arch signed-by=$gpgdir/packages.microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $dist main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
echo "deb [arch=$arch signed-by=$gpgdir/docker.gpg] https://download.docker.com/linux/ubuntu $dist stable" | sudo tee /etc/apt/sources.list.d/docker.list
echo "deb [arch=$arch signed-by=$gpgdir/1password.gpg] https://downloads.1password.com/linux/debian/$arch stable main" | sudo tee /etc/apt/sources.list.d/1password.list

sudo apt update
