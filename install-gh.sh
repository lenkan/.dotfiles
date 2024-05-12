#!/bin/sh

version=2.43.1
arch=$(dpkg --print-architecture)
filename="gh_"$version"_linux_"$arch".deb"
wget -P tmp/ "https://github.com/cli/cli/releases/download/v$version/$filename"
sudo dpkg -i "tmp/$filename"
