#!/bin/sh

mkdir -p tmp
sudo apt-get update
sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg

curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >./tmp/microsoft.gpg
sudo install -o root -g root -m 644 ./tmp/microsoft.gpg /etc/apt/trusted.gpg.d/
AZ_DIST=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_DIST main" | sudo tee /etc/apt/sources.list.d/azure-cli.list

sudo apt-get update
sudo apt-get install azure-cli
