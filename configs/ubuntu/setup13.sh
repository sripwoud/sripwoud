#!/bin/bash

set -e

install_apt_pkgs() {
  sudo add-apt-repository universe # required for fira-code font
  curl -fsS "$url"/ubuntu/apt | sudo xargs apt install -y
}

get_ubuntu_config_files() {
  for file in .gitconfig .zshenv .zshrc; do
    curl -o "$HOME/$file" -fsS "$url/ubuntu/$file"
  done
}

main() {
  local url=https://raw.githubusercontent.com/3pwd/3pwd/master/configs
  install_apt_pkgs

  chsh -s "$(which zsh)"

  # oh my zsh, asdf, circom, foundry, config files, gpg setup, ssh setup
  sudo curl -fsS "$url"/common/setup.sh | sh

  curl -o "$HOME/.oh-my-zsh/custom/alias.zsh" -fsS "$url/alias.zsh"
}

main "$@"
