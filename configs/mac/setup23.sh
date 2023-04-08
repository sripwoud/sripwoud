main() {
	# Fira Code Font
	curl -fsSL https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip -o /tmp/Fira_Code_v6.2.zip
	unzip /tmp/Fira_Code_v6.2.zip -d /tmp/Fira_Code_v6.2 >/dev/null
	cp /tmp/Fira_Code_v6.2/ttf/*.ttf ~/Library/Fonts/
	rm -rf /tmp/Fira_Code_v6.2.zip /tmp/Fira_Code_v6.2

	# Spaceship prompt
	git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
	ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

	# Zsh plugins
	# zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting

	# asdf
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf
	touch ~/.tool-versions
	while read -r plugin; do
		asdf plugin-add "$plugin"
		asdf install "$plugin" latest
		asdf global "$plugin" latest
	done <asdf-plugins

	sh get_installers.sh
}

main "$@"
