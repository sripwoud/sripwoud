#!/bin/bash

set -e

post_docker_install() {
  # Grant permissions for docker process and file levels
  sudo chmod a+rwx /var/run/docker.sock
  sudo chmod a+rwx /var/run/docker.pid
}

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

install_joplin_gui () {
  wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash
}

install_joplin_cli() {
  NPM_CONFIG_PREFIX=~/.local/bin/joplin-bin npm install -g joplin
  ln -s ~/.local/bin/joplin-bin/joplin "$HOME"/.local/bin
}

install_apps() {
  sudo sed -i 's/#EnableAUR/EnableAUR/' /etc/pamac.conf
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
       sudo pamac install --no-confirm "$app"
        ;;
      esac

    done <"$tmp_file"
    rm "$tmp_file"
  done
}

install_nordvpn() {
  pamac install nordvpn-bin
  sudo usermod -aG nordvpn "$USER"
}

install_foundry() {
  curl -L https://foundry.paradigm.xyz | bash
  source "ZDOTDIR/.zshenv"
  foundryup
}

main() {
  #post_docker_install
  local url=https://raw.githubusercontent.com/sripwoud/sripwoud/main/configs

  # asdf, foundry, config ssh & gpg
  sudo curl -fsS "$url"/common/setup.sh | sh
  
  get_manjaro_config_files

  install_apps
  install_joplin_gui
  install_joplin_cli
  
  sudo pamac remove --no-confirm firefox
  
  # setup gnome keyring to save ssh passphrases
  systemctl --user enable --now gcr-ssh-agent.socket
  
  mkdir .log
  touch .log/cron.log
  # todo: define backup script, set up crontab to run it, setup logrotate config file, setup crontab to run logrotate 
  echo "###### REBOOTING IN 5S #######"
  sleep 5
  reboot
}

main
