#!/bin/bash

set -e

install_homebrew() {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # will especially install git
  curl -fsS https://raw.githubusercontent.com/sripwoud/sripwoud/main/configs/mac/brew | xargs brew install
}

get_mac_config_files() {
  for file in .gitconfig .zshenv .zshrc; do
    curl -o "$HOME/$file" -fsS "$url/mac/$file"
  done

  curl -o "$HOME/.oh-my-zsh/custom/alias.zsh" -fsS "$url/mac/alias.zsh"
}

main() {
  local url=https://raw.githubusercontent.com/sripwoud/sripwoud/main/configs

  install_homebrew

  # oh my zsh
  sudo curl -fsS "$url"/common/setup12.sh | sh
  get_mac_config_files
  # asdf, circom, foundry, config files, gpg setup, ssh setup
  sudo curl -fsS "$url"/common/setup22.sh | sh
}

main
