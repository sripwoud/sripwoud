set -o errexit

get_extra_urls() {
	{
		echo "https://updates.signal.org/desktop/$(curl -s https://updates.signal.org/desktop/latest-mac.yml | dasel -r yaml 'files.[2].url')";
		curl -s https://api.github.com/repos/balena-io/etcher/releases/latest | dasel -r json 'assets.all().browser_download_url' | grep 'dmg"' | cut -d '"' -f 2;
		curl -s https://api.github.com/repos/standardnotes/app/releases/latest | dasel -r json 'assets.all().browser_download_url' | grep 'x64.dmg"' | cut -d '"' -f 2;
		curl -s -G "https://data.services.jetbrains.com/products/releases" -d "code=TBA" -d "latest=true" | dasel -r json "TBA.[0].downloads.linux.link" | tr -d '"'
	} >>/tmp/installers/list
}

download_installers() {
	while read -r url; do
		wget --https-only --show-progress --content-disposition -nv -P /tmp/installers "$url"
	done </tmp/installers/list
}

main() {
	mkdir -p /tmp/installers
	curl -fSL https://raw.githubusercontent.com/3pwd/3pwd/mac/configs/mac/installers -o /tmp/installers/list
	get_extra_urls
	download_installers
}

main "$@"
