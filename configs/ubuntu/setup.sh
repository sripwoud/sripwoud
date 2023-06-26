#!/bin/bash

set -e

main() {
  for i in {1..3}; do
    curl -fsS https://raw.githubusercontent.com/sripwoud/sripwoud/main/configs/ubuntu/setup"$i"3.sh | sh
  done
}

main
