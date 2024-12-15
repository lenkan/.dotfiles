#!/bin/sh

wget https://go.dev/dl/go1.23.4.linux-amd64.tar.gz
rm -rf ~/.local/go
rm ~/.local/bin/go
rm ~/.local/bin/gofmt

tar -C ~/.local -xzf go1.23.4.linux-amd64.tar.gz
ln -s ~/.local/go/bin/go ~/.local/bin/go
ln -s ~/.local/go/bin/gofmt ~/.local/bin/gofmt

