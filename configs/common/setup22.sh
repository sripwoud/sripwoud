set -o errexit

install_circom() {
  tempdir=$(mktemp -d)
  git clone https://github.com/iden3/circom.git "$tempdir"
  cd tempdir
  cargo build --release
  cargo install --path circom
  cd ~
  rm -rf tempdir
}

install_foundry() {
  curl -L https://foundry.paradigm.xyz | bash
  source "$HOME"/.zshrc
  foundryup
}

install_asdf() {
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf
  touch ~/.tool-versions
  while read -r plugin; do
    asdf plugin-add "$plugin"
    asdf install "$plugin" latest
    asdf global "$plugin" latest
  done <"$(curl -fsS https://raw.githubusercontent.com/3pwd/3pwd/main/configs/common/asdf-plugins)"

}

get_common_config_files() {
  for file in .default-npm-packages .gitignore .npmrc .prettierignore .prettierrc.yaml; do
    curl -o "$HOME/$file" -fsS "https://raw.githubusercontent.com/3pwd/3pwd/master/configs/common/$file"
  done
}

add_zsh_syntax_highlighting() {
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
}

install_spaceship_prompt() {
  git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
  ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

}

config_gpg() {
  gpg --full-generate-key --allow-freeform-uid
  gpg --list-secret-keys --keyid-format LONG

  read -r -p "Enter the gpg key ID: " key_id
  read -r -p "Enter title for gpg key on GitHub: " title
  gpg --armor --export "$key_id" | gh gpg-key add -t "$title"
  curl https://github.com/web-flow.gpg | gpg --import
}

config_ssh() {
  read -r -p "Enter the email address for ssh key: " email
  ssh-keygen -t ed25519 -C "$email"
  eval "$(ssh-agent -s)"

  read -r -p "Enter the filename of your created ssh key: " ssh_filename

  if [[ "$OSTYPE" == "darwin"* ]]; then
    ssh-add --apple-use-keychain ~/.ssh/"$ssh_filename"
    echo "Host github.com
     AddKeysToAgent yes
     UseKeychain yes
     IdentityFile ~/.ssh/$ssh_filename" >>~/.ssh/config
  else
    ssh-add ~/.ssh/"$ssh_filename"
  fi

  read -r -p "Title for ssh key on GitHub: " title
  gh ssh-key add ~/.ssh/"$ssh_filename".pub -t "$title"
}

main() {
  install_spaceship_prompt
  add_zsh_syntax_highlighting
  install_asdf # asdf is an oh my zsh plugin, and rust is included in asdf plugins
  install_foundry
  install_circom
  mkdir ~/.{pyenvs,vpn}
  get_common_config_files
  gh auth login
  config_gpg
  config_ssh
}

main "$@"
