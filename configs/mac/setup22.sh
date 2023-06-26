#!/bin/bash

set -e
shopt -s extglob

install_fira_code_font() {
  curl -fsSL https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip -o /tmp/Fira_Code_v6.2.zip
  unzip /tmp/Fira_Code_v6.2.zip -d /tmp/Fira_Code_v6.2 >/dev/null
  cp /tmp/Fira_Code_v6.2/ttf/*.ttf ~/Library/Fonts/
  rm -rf /tmp/Fira_Code_v6.2.zip /tmp/Fira_Code_v6.2
}

get_extra_urls() {
  {
    echo "https://updates.signal.org/desktop/$(curl -s https://updates.signal.org/desktop/latest-mac.yml | dasel -r yaml 'files.[2].url')"
    curl -s https://api.github.com/repos/balena-io/etcher/releases/latest | dasel -r json 'assets.all().browser_download_url' | grep 'dmg"' | cut -d '"' -f 2
    curl -s https://api.github.com/repos/standardnotes/app/releases/latest | dasel -r json 'assets.all().browser_download_url' | grep 'x64.dmg"' | cut -d '"' -f 2
    curl -s -G "https://data.services.jetbrains.com/products/releases" -d "code=TBA" -d "latest=true" | dasel -r json "TBA.[0].downloads.mac.link" | tr -d '"'
  } >>/tmp/list
}

download_installers() {
  while read -r url; do
    wget --https-only --show-progress --content-disposition -nv -P /tmp/installers "$url"
  done </tmp/installers/list
}

get_installers() {
  mkdir -p /tmp/installers
  curl -fSL https://raw.githubusercontent.com/sripwoud/sripwoud/main/configs/mac/installers -o /tmp/installers/list
  get_extra_urls
  download_installers
}

install() {
  case "$1" in
  Docker.dmg)
    sudo hdiutil attach Docker.dmg
    sudo /Volumes/Docker/Docker.app/Contents/MacOS/install
    sudo hdiutil detach /Volumes/Docker
    ;;

  *.dmg)
    volume=$(sudo hdiutil attach "$1" | grep Volumes | cut -f 3)

    find "$volume" ! -name "$(printf "*\n*")" -name "*.app" -o -name "*.pkg" -maxdepth 1 > tmp

    while IFS= read -r app; do
      echo "installing $app" && install "$app"
    done < tmp

    rm tmp
    sudo hdiutil detach "$volume"
    ;;

  *.app)
    cp -R "$1" /Applications
    sudo xattr -rd com.apple.quarantine "/Applications/$(basename "$1")"
    ;;

  *.pkg)
    sudo installer -pkg "$1" -target /
    ;;

  *.zip)
    tempdir=$(mktemp -d)
    unzip "$1" -d "$tempdir" >/dev/null

    find "$tempdir" ! -name "$(printf "*\n*")" -name "*.app" -o -name "*.pkg" -maxdepth 1 > tmp

    while IFS= read -r app; do
      echo " installing $app" && install "$app"
    done < tmp

    rm tmp
    rm -rf "$tempdir"
    ;;

  esac
}

main() {
  install_fira_code_font

  get_installers
  for app in /tmp/installers/*(.app|.dmg|.pkg|.zip); do
    install "$app"
  done
  rm -rf /tmp/installers
}

main
