#!/bin/bash

set -e

install_spaceship_prompt() {
  git clone https://github.com/spaceship-prompt/spaceship-prompt.git "${$HOME/.oh-my-zsh/custom}/themes/spaceship-prompt" --depth=1
  ln -s "${$HOME/.oh-my-zsh/custom}/themes/spaceship-prompt/spaceship.zsh-theme" "${$HOME/.oh-my-zsh/custom}/themes/spaceship.zsh-theme"
}

add_zsh_syntax_highlighting() {
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${$HOME/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
}

install_asdf() {
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf
  touch ~/.tool-versions

  tmp_file=$(mktemp)
  curl -fsS https://raw.githubusercontent.com/sripwoud/sripwoud/main/configs/common/asdf-plugins >"$tmp_file"

  while read -r line; do
    read -ra args <<< "$line"
    plugin=${args[0]}
    url=${args[1]}
    branch=${args[2]}

    [[ -n $url ]] && asdf plugin add "$plugin" "$url" | asdf plugin add "$plugin"
    [[ -n $branch ]] && asdf plugin update "$plugin" "$branch"
    asdf install "$plugin" latest
    asdf global "$plugin" latest
  done <"$tmp_file"

  rm "$tmp_file"
}

install_circom() {
  temp_dir=$(mktemp -d)
  git clone https://github.com/iden3/circom.git "$temp_dir"
  cd "$temp_dir"
  cargo build --release
  cargo install --path circom
  cd ~
  rm -rf "$temp_dir"
}

install_foundry() {
  curl -L https://foundry.paradigm.xyz | bash
  source "$HOME"/.zshrc
  foundryup
}

get_common_config_files() {
  for file in .default-npm-packages .npmrc; do
    if [[ "$OSTYPE" == "darwin"* ]]; then
      curl -o "$HOME/$file" -fsS "https://raw.githubusercontent.com/sripwoud/sripwoud/main/configs/mac/$file"
    else
      curl -o "$HOME/$file" -fsS "https://raw.githubusercontent.com/sripwoud/sripwoud/main/configs/ubuntu/$file"
    fi
  done

  mkdir -p "${$HOME/.oh-my-zsh/custom}"/plugins/sha256
  curl -o "${$HOME/.oh-my-zsh/custom}"/plugins/sha256/sha256.plugin.zsh -fsS "https://raw.githubusercontent.com/sripwoud/sripwoud/main/configs/common/sha256.zsh"
}

config_ssh() {
  gh auth login
  eval "$(ssh-agent -s)"

  if [[ "$OSTYPE" == "darwin"* ]]; then
    ssh-add --apple-use-keychain ~/.ssh/id_ed25519
    echo "Host github.com
     AddKeysToAgent yes
     UseKeychain yes
     IdentityFile ~/.ssh/id_ed25519" >>~/.ssh/config
  else
    ssh-add ~/.ssh/id_ed25519
  fi
}

config_gpg() {
  gh auth refresh -s write:gpg_key

  gpg --full-generate-key --allow-freeform-uid --expert
  gpg --list-secret-keys --keyid-format LONG

  read -r -p "Enter the gpg key ID: " key_id
  git config --global user.signingkey "$key_id"

  read -r -p "Enter title for gpg key on GitHub: " title
  gpg --armor --export "$key_id" | gh gpg-key add -t "$title"
  curl https://github.com/web-flow.gpg | gpg --import

  if [[ "$OSTYPE" == "darwin"* ]];then
    echo "pinentry-program $(which pinentry-mac)" >> ~/.gnupg/gpg-agent.conf
    gpgconf --kill gpg-agent
  fi
}

main() {
  install_spaceship_prompt
  add_zsh_syntax_highlighting
  get_common_config_files
  install_asdf # asdf is an oh my zsh plugin, and rust is included in asdf plugins
  install_foundry
  install_circom
  mkdir ~/{dev,cloud,.{pyenvs,vpn}}
  config_ssh
  config_gpg
}

main
