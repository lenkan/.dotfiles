#!/bin/bash
set -euo pipefail

# Hold j/k in vs code
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 15
