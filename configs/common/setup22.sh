set -e

install_spaceship_prompt() {
  git clone https://github.com/spaceship-prompt/spaceship-prompt.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship-prompt" --depth=1
  ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship.zsh-theme"
}

add_zsh_syntax_highlighting() {
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
}

install_asdf() {
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf
  touch ~/.tool-versions

  tmp_file=$(mktemp)
  curl -fsS https://raw.githubusercontent.com/sripwoud/sripwoud/main/configs/common/asdf-plugins >"$tmp_file"
  while read -r line; do
    args=("$line")
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
  for file in .default-npm-packages .gitignore .npmrc .prettierignore .prettierrc.yaml; do
    curl -o "$HOME/$file" -fsS "https://raw.githubusercontent.com/sripwoud/sripwoud/master/configs/common/$file"
  done

  mkdir -p "$ZSH_CUSTOM"/plugins/sha256
  curl -o "$ZSH_CUSTOM"/plugins/sha256/sha256.plugin.zsh -fsS "https://raw.githubusercontent.com/sripwoud/sripwoud/master/configs/common/sha256.zsh"
}

config_gpg() {
  gpg --full-generate-key --allow-freeform-uid --expert
  gpg --list-secret-keys --keyid-format LONG

  read -r -p "Enter the gpg key ID: " key_id
  git config --global user.signingkey "$key_id"

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
  get_common_config_files
  install_asdf # asdf is an oh my zsh plugin, and rust is included in asdf plugins
  install_foundry
  install_circom
  mkdir ~/.{pyenvs,vpn}
  gh auth login
  gh auth refresh -s write:gpg_key
  config_gpg
  config_ssh
}

main "$@"
