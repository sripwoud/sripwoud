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

  # asdf, foundry, config ssh & gpg
  sudo curl -fsS "$url"/common/setup.sh | sh
  get_manjaro_config_files
}

main
