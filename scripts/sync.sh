#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

for filename in "$DIR"/.*; do
  if [ ! -d "$filename" ]; then
    ln -svf "$filename" "$HOME/$(basename "$filename")"
  fi
done

# Copy .local/bin scripts
mkdir -p "$HOME/.local/bin"
for filename in "$DIR"/.local/bin/*; do
  if [ ! -d "$filename" ]; then
    ln -svf "$filename" "$HOME/.local/bin/$(basename "$filename")"
  fi
done
