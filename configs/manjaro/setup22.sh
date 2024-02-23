#!/bin/bash

set -e

get_manjaro_config_files() {
  for file in .gitconfig .gitignore .zshenv .zshrc; do
    curl -o "$HOME/$file" -fsS "$url/manjaro/$file"
  done

  wget -o "$ZDOTDIR/alias" "$url/manjaro/alias"
}

#get_appimage_url_from_github() {
#  local org_repo=$1
#  gh api \
#    -H "Accept: application/vnd.github+json" \
#    -H "X-GitHub-Api-Version: 2022-11-28" \
#    /repos/"$org_repo"/releases |
#    dasel -r json "[0].assets.all().browser_download_url" |
#    grep -E "\.AppImage\"$" |
#    tr -d '"'
#}

#install_appimage() {
#  local identifier=$1
#  if [[ $identifier == "https"* ]]; then
#    url=$identifier
#  else
#    url=$(get_appimage_url_from_github "$identifier")
#  fi
#  wget "$url" 2>&1 | tee wget.log
#  app=$(grep -oP "(?<=Saving to: ‘).*(?=.AppImage’)" wget.log)
#  ail-cli integrate "$app.AppImage"
#}

install_joplin () {
  wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash
}

install_apps() {
  #for cli in ail cargo pamac;do
  for cli in cargo pamac;do
    tmp_file=$(mktemp)
    wget -O "$tmp_file" "$url/manjaro/apps/$cli"

    while read -r app; do
      case $cli in
      #ail)
      #  install_appimage "$app"
      #  ;;
      cargo)
        cargo install "$app"
        ;;
      pamac)
       pamac install "$app"
        ;;
      esac

    done <"$tmp_file"
    rm "$tmp_file"
  done
}

install_jetbrains_toolbox() {
  filename=jetbrains-toolbox
  url=$(curl -sG "https://data.services.jetbrains.com/products/releases" -d "code=TBA" -d "latest=true" | dasel -r json "TBA.[0].downloads.linux.link" | tr -d '"')
  curl -o "$filename"_archive -fsSL "$url"
  tar xf "$filename"_archive --strip-components 1

  mkdir -p /opt/bin
  sudo mv $filename /opt/bin/$filename
  rm "$filename"_archive

  # increase inotify watches limit
  # https://youtrack.jetbrains.com/articles/IDEA-A-2/Inotify-Watches-Limit-Linux
  sudo echo "fs.inotify.max_user_watches = 524288" >/etc/sysctl.d/idea.conf
  sudo sysctl -p --system

  # after pycharm install
  # sudo ln -s ~/.local/share/JetBrains/toolbox/scripts/pycharm /opt/bin/pycharm
}

install_nordvpn() {
  pacmac build nordvpn-bin
  sudo usermod -aG nordvpn "$USER"
}

install_keybase() {
  curl --remote-name https://prerelease.keybase.io/keybase_amd64.deb
  sudo apt install ./keybase_amd64.deb -y
  rm keybase_amd64.deb
  # FIXME: this installs keybase using the deprecated keyring
  # needs to do
  # sudo apt-key list
  # sudo apt-key export <keylast8digits> | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/keybase.gpg
  # sudo apt-key del <keylast8digits>
}

install_joplin_cli() {
  NPM_CONFIG_PREFIX=~/.local/bin/joplin-bin npm install -g joplin
  ln -s ~/.local/bin/joplin-bin/joplin "$HOME"/.local/bin
}


main() {
  local url=https://raw.githubusercontent.com/sripwoud/sripwoud/main/configs

  # asdf, foundry, config ssh & gpg
  sudo curl -fsS "$url"/common/setup.sh | sh
  get_manjaro_config_files
  ###### FIXME
  local arch
  arch=$(dpkg --print-architecture)
  local release
  release=$(lsb_release -cs)
  # Grant permissions for docker process and file levels
  sudo chmod a+rwx /var/run/docker.sock
  sudo chmod a+rwx /var/run/docker.pid

  curl -fsS https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmor --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg
  echo "deb [arch=$arch signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian $release contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list

  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor --yes --output /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [arch=$arch signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $release main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

  curl -fsSL https://swupdate.openvpn.net/repos/openvpn-repo-pkg-key.pub | sudo gpg --dearmor --yes --output /usr/share/keyrings/openvpn-repo-pkg-keyring.gpg
  echo "deb [arch=$arch signed-by=/usr/share/keyrings/openvpn-repo-pkg-keyring.gpg] https://swupdate.openvpn.net/community/openvpn3/repos $release main" | sudo tee /etc/apt/sources.list.d/openvpn3.list

  sudo apt update
  sudo apt install brave-browser virtualbox-6.1 vagrant -y
  install_flatpak_apps
  install_fira_code_font
  install_nordvpn
  install_jetbrains_toolbox
  install_vagrant
  install_virtualbox

  # setup gnome keyring to save ssh passphrases
  systemctl --user enable --now gcr-ssh-agent.socket

  echo "###### REBOOTING IN 5S #######"
  sleep 5
  reboot
}

main
