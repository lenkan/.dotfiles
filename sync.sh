#!/bin/sh
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

for filename in $DIR/.*; do
  if [ ! -d "$filename" ]; then
    ln -svf $filename ~/$(basename $filename)
  fi
done