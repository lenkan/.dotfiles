#!/bin/sh

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor >./tmp/docker.gpg
sudo install -o root -g root -m 644 ./tmp/docker.gpg /etc/apt/trusted.gpg.d/

arch=$(dpkg --print-architecture)
filename=docker-desktop-4.26.1-amd64.deb
release=$(. /etc/os-release && echo "$VERSION_CODENAME")

echo "deb [arch="$arch" signed-by=/etc/apt/trusted.gpg.d/docker.gpg] https://download.docker.com/linux/ubuntu $release stable" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get update

rm -r "tmp/$filename"
wget -P tmp/ "https://desktop.docker.com/linux/main/amd64/$filename"
sudo apt install "./tmp/$filename"
