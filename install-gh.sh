#!/bin/sh

version=2.20.2
filename=gh_"$version"_linux_386.deb
wget -P tmp/ "https://github.com/cli/cli/releases/download/v$version/$filename"
sudo dpkg -i "tmp/$filename"
