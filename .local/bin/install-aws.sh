#!/bin/bash
set -euo pipefail

cd /tmp
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install --bin-dir ~/.local/bin --install-dir ~/.aws-cli --update
rm -rf awscliv2.zip aws
