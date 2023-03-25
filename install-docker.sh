#!/bin/sh

filename=docker-desktop-4.17.0-amd64.deb
rm -r "tmp/$filename"
wget -P tmp/ "https://desktop.docker.com/linux/main/amd64/$filename"
sudo apt install "./tmp/$filename"
