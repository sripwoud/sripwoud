#!/bin/bash

set -e

install_starship_rs() {
  curl -sS https://starship.rs/install.sh | sh
}

install_omyzsh() {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

# TODO: install starship.rs https://starship.rs/guide/#%F0%9F%9A%80-installation

main() {
  install_starship_rs
  install_omyzsh
}

main
