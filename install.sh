#!/bin/sh

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

# Google https://www.ubuntuupdates.org/ppa/google_chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list'

# Microsoft
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

# Docker https://docs.docker.com/engine/install/ubuntu/
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install google-chrome-stable
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-compose
sudo apt-get install code
sudo apt-get install tmux
sudo apt-get install xclip
sudo apt-get install jq
sudo apt-get install httpie
sudo apt-get install python3-dev python3-pip python3-setuptools

sudo usermod -aG docker $USER
newgrp docker
