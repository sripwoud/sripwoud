#!/bin/bash

set -e

main() {
  local url="https://raw.githubusercontent.com/sripwoud/sripwoud/main/configs"
  if [[ "$OSTYPE" == "darwin"* ]]; then
    curl -fsS "$url/macos/setup.sh" | sh
  else
    curl -fsS "$url/manjaro/setup.sh" | sh
  fi
}

main