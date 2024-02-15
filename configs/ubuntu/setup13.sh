#!/bin/bash

set -e

add_ppa() {
  if ! grep -h "deb.*$1" /etc/apt/sources.list.d/* > /dev/null 2>&1;
   then
    echo "Adding ppa:$1"
    sudo add-apt-repository -y "ppa:$1"
    return 0
  else
    echo "ppa:$1 already exists"
    return 1
  fi
}

install_apt_pkgs() {
  add_ppa universe # required for fira-code font
  add_ppa ppa:appimagelauncher-team/stable
  sudo apt update
  curl -fsS "$url"/ubuntu/apt | sudo xargs apt install -y
}

get_ubuntu_config_files() {
  for file in .gitconfig .gitignore .zshenv .zshrc; do
    curl -o "$HOME/$file" -fsS "$url/ubuntu/$file"
  done

  curl -o "$HOME/.oh-my-zsh/custom/alias.zsh" -fsS "$url/ubuntu/alias.zsh"
}

main() {
  local url=https://raw.githubusercontent.com/sripwoud/sripwoud/main/configs
  install_apt_pkgs

  chsh -s "$(which zsh)"

  # oh my zsh
  sudo curl -fsS "$url"/common/setup12.sh | sh
  get_ubuntu_config_files
  # asdf, circom, foundry, config files, gpg setup, ssh setup
  sudo curl -fsS "$url"/common/setup22.sh | sh
}

main
