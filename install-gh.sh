#!/bin/sh

cd tmp
version=2.20.2
filename=gh_"$version"_linux_386.deb
wget "https://github.com/cli/cli/releases/download/v$version/$filename"
sudo dpkg -i $filename
