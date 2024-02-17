#!/bin/bash

set -e

get_manjaro_config_files() {
  for file in .gitconfig .gitignore .zshenv .zshrc; do
    curl -o "$HOME/$file" -fsS "$url/manjaro/$file"
  done

  curl -o "$ZSH_CUSTOM/alias.zsh" -fsS "$url/manjaro/alias.zsh"
}

main() {
  local url=https://raw.githubusercontent.com/sripwoud/sripwoud/main/configs

  chsh -s "$(which zsh)"

  # oh my zsh
  sudo curl -fsS "$url"/common/setup12.sh | sh
  get_manjaro_config_files
  # asdf, circom, foundry, config files, gpg setup, ssh setup
  sudo curl -fsS "$url"/common/setup22.sh | sh
}

main
