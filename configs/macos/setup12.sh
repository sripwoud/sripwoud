#!/bin/bash

set -e

install_homebrew() {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # will especially install git
  curl -fsS https://raw.githubusercontent.com/sripwoud/sripwoud/main/configs/mac/brew | xargs brew install
}

# TODO: replace by powerlevel10k
install_starship_rs() {
  curl -sS https://starship.rs/install.sh | sh
}

install_omyzsh() {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

add_zsh_syntax_highlighting() {
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${$HOME/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
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
  install_omyzsh
  install_starship_rs
  add_zsh_syntax_highlighting
  get_mac_config_files
  # asdf, circom, foundry, config files, gpg setup, ssh setup
  sudo curl -fsS "$url"/common/setup22.sh | sh
}

main
