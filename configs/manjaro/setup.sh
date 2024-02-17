#!/bin/bash

set -e

main() {
  for i in {1..2}; do
    curl -fsS https://raw.githubusercontent.com/sripwoud/sripwoud/main/configs/manjaro/setup"$i"2.sh | sh
  done
}

main
