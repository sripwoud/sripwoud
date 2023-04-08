{
	echo "https://updates.signal.org/desktop/$(curl -s https://updates.signal.org/desktop/latest-mac.yml | dasel -r yaml 'files.[2].url')"
	curl -s https://api.github.com/repos/balena-io/etcher/releases/latest | dasel -r json 'assets.all().browser_download_url' | grep 'dmg"' | cut -d '"' -f 2
	curl -s https://api.github.com/repos/standardnotes/app/releases/latest | dasel -r json 'assets.all().browser_download_url' | grep 'x64.dmg"' | cut -d '"' -f 2
	curl -s -F -G "https://data.services.jetbrains.com/products/releases" -d "code=TBA" -d "latest=true" | dasel -r json "TBA.[0].downloads.linux.link" | tr -d '"'
} >>installers
