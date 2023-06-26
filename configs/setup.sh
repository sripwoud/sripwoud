#!/bin/bash

set -e

main() {
  local url="https://raw.githubusercontent.com/sripwoud/sripwoud/main/configs"
  if [[ "$OSTYPE" == "darwin"* ]]; then
    curl -fsS "$url/mac/setup.sh" | sh
  else
    curl -fsS "$url/ubuntu/setup.sh" | sh
  fi
}

main