set -e

install_flatpak_apps() {
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

  tmp_file=$(mktemp)
  curl -fsS "$url"/flatpakrefs >"$tmp_file"
  while read -r flatpakref; do
    flatpak install -y "$flatpakref"
  done <"$tmp_file"
  rm "$tmp_file"
}

install_jetbrains_toolbox() {
  filename=jetbrains-toolbox
  url=$(curl -sG "https://data.services.jetbrains.com/products/releases" -d "code=TBA" -d "latest=true" | dasel -r json "TBA.[0].downloads.linux.link" | tr -d '"')
  curl -o "$filename"_archive -fsSL "$url"
  tar xf "$filename"_archive --strip-components 1

  mkdir -p /opt/bin
  sudo mv $filename /opt/bin/$filename
  rm "$filename"_archive
}

install_nordvpn() {
  sh <(curl -sSf https://downloads.nordcdn.com/apps/linux/install.sh)
  #  usermod -aG nordvpn "$USER"
}

install_flyctl() {
  curl -L https://fly.io/install.sh | sh
}

fix_discord() {
  cat >"$HOME"/.var/app/com.discordapp.Discord/config/discord/settings.json <<EOF
{
  "SKIP_HOST_UPDATE": true,
  "MIN_WIDTH": 100,
  "MIN_HEIGHT": 100,
}
EOF
}

clean_up() {
  sudo apt remove apport apport-system
  sudo apt autoremove -y
  snap remove firefox snap-store
  sudo apt purge snapd
}

main() {
  local url=https://raw.githubusercontent.com/3pwd/3pwd/main/configs/ubuntu
  # Grant permissions for docker process and file levels
  sudo chmod a+rwx /var/run/docker.sock
  sudo chmod a+rwx /var/run/docker.pid

  get_ubuntu_config_files

  sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list

  curl -fsS https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmor --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list

  curl -fsS https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor --yes --output /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

  sudo apt update
  sudo apt install brave-browser virtualbox-6.1 vagrant -y
  install_flatpak_apps
  install_fira_code_font
  install_flyctl
  install_gh_cli
  install_nordvpn
  install_jetbrains_toolbox
  install_vagrant
  install_virtualbox

  clean_up

  sudo update-alternatives --config x-terminal-emulator

  echo "###### REBOOTING IN 5S #######"
  sleep 5
  reboot
}

main "$@"
