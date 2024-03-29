#!/bin/sh

# Microsoft
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >./tmp/microsoft.gpg
sudo install -o root -g root -m 644 ./tmp/microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get install code
