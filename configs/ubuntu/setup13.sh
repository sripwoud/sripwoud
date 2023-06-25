#!/bin/bash

set -e

install_apt_pkgs() {
  sudo add-apt-repository universe # required for fira-code font
  sudo add-apt-repository ppa:appimagelauncher-team/stable
  sudo apt update
  curl -fsS "$url"/ubuntu/apt | sudo xargs apt install -y
}

get_ubuntu_config_files() {
  for file in .gitconfig .zshenv .zshrc; do
    curl -o "$HOME/$file" -fsS "$url/ubuntu/$file"
  done

  curl -o "$HOME/.oh-my-zsh/custom/alias.zsh" -fsS "$url/ubuntu/alias.zsh"
}

main() {
  local url=https://raw.githubusercontent.com/sripwoud/sripwoud/master/configs
  install_apt_pkgs

  chsh -s "$(which zsh)"

  # oh my zsh
  sudo curl -fsS "$url"/common/setup12.sh | sh
  get_ubuntu_config_files
  # asdf, circom, foundry, config files, gpg setup, ssh setup
  sudo curl -fsS "$url"/common/setup22.sh | sh
}

main "$@"
