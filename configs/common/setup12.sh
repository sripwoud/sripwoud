#!/bin/bash

set -e

install_starship_rs() {
  curl -sS https://starship.rs/install.sh | sh
}

install_omyzsh() {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

main() {
  install_starship_rs
  install_omyzsh
}

main
