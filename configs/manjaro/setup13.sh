#!/bin/bash

set -e

get_ubuntu_config_files() {
  for file in .gitconfig .gitignore .zshenv .zshrc; do
    curl -o "$HOME/$file" -fsS "$url/ubuntu/$file"
  done

  curl -o "$HOME/.oh-my-zsh/custom/alias.zsh" -fsS "$url/ubuntu/alias.zsh"
}

main() {
  local url=https://raw.githubusercontent.com/sripwoud/sripwoud/main/configs

  chsh -s "$(which zsh)"

  # oh my zsh
  sudo curl -fsS "$url"/common/setup12.sh | sh
  get_ubuntu_config_files
  # asdf, circom, foundry, config files, gpg setup, ssh setup
  sudo curl -fsS "$url"/common/setup22.sh | sh
}

main
