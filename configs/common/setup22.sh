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
main() {
  install_spaceship_prompt
  add_zsh_syntax_highlighting
  install_asdf # asdf is an oh my zsh plugin, and rust is included in asdf plugins
  install_foundry
  install_circom
  mkdir ~/.{pyenvs,vpn}
  get_common_config_files
  # TODO: gpg and ssh setup
}

main "$@"
