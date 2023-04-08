set -o errexit

get_extra_urls() {
	{
		echo "https://updates.signal.org/desktop/$(curl -s https://updates.signal.org/desktop/latest-mac.yml | dasel -r yaml 'files.[2].url')";
		curl -s https://api.github.com/repos/balena-io/etcher/releases/latest | dasel -r json 'assets.all().browser_download_url' | grep 'dmg"' | cut -d '"' -f 2;
		curl -s https://api.github.com/repos/standardnotes/app/releases/latest | dasel -r json 'assets.all().browser_download_url' | grep 'x64.dmg"' | cut -d '"' -f 2;
		curl -s -G "https://data.services.jetbrains.com/products/releases" -d "code=TBA" -d "latest=true" | dasel -r json "TBA.[0].downloads.mac.link" | tr -d '"'
	} >>/tmp/installers/list
}

download_installers() {
	while read -r url; do
		wget --https-only --show-progress --content-disposition -nv -P /tmp/installers "$url"
	done </tmp/installers/list
}

get_installers() {
	mkdir -p /tmp/installers
	curl -fSL https://raw.githubusercontent.com/3pwd/3pwd/mac/configs/mac/installers -o /tmp/installers/list
	get_extra_urls
	download_installers
}

function install_dmg {
    volume=$(sudo hdiutil attach "$1" | grep Volumes | cut -f 3)

    for app in "$volume"/*(.app|.pkg); do
      case $app in
        *.app) sudo cp -rf "$app" /Applications ;;
        *.pkg)
          sudo installer -pkg "$app" -target / ;;
      esac
    done

    sudo hdiutil detach "$volume"
    rm -rf "$1"
}

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

	get_installers

	for app in /tmp/installers/*(.tar.gz|.zip|.dmg); do
    case $app in
      *.dmg)
        install_dmg "$app" ;;
      *.tar.gz)
        tar -xzf "$app" -C /tmp >/dev/null ;;
      *.zip)
        unzip "$app" -d /tmp >/dev/null ;;
    esac
  done
}

main "$@"
