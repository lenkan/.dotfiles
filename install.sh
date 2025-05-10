#!/bin/sh

if [ ! -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
    echo "Not on WSL!"
else
    echo "On WSL!"
fi


sudo rm -rf /var/cache/snapd/
sudo apt autoremove --purge snapd gnome-software-plugin-snap
rm -fr ~/snap
sudo apt-mark hold snapd

sudo apt-get update
sudo apt-get install \
	vim \
	git \
	curl \
	ca-certificates \
	gnupg \
	lsb-release \
	apt-transport-https

sudo apt-get update
sudo apt-get install tmux
sudo apt-get install xclip
sudo apt-get install jq
sudo apt-get install httpie
sudo apt-get install python3-dev python3-pip python3-setuptools

