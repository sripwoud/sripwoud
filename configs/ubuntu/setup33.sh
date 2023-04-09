set -e

get_ubuntu_config_files() {
  for file in .gitconfig .zshenv .zshrc; do
    curl -o "$HOME/$file" -fsS "https://raw.githubusercontent.com/3pwd/3pwd/master/configs/mac/$file"
  done

  curl -o "$ZSH/custom/alias.zsh" -fsS "$url/ubuntu/alias.zsh"
}

install_flatpak_apps() {
  sudo apt install flatpak -y
  sudo apt install gnome-software-plugin-flatpak -y
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

  while read -r flatpakref; do
    flatpak install -y "$flatpakref"
  done < <(curl -fsS "$url/ubuntu/flatpakrefs")
}

install_fira_code_font() {
  sudo apt install fonts-firacode -y
  echo "    add ubuntu universe repository"
  sudo add-apt-repository universe
}

install_brave() {
  sudo apt install apt-transport-https curl -y &&
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg &&
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list &&
    sudo apt update &&
    sudo apt install brave-browser -y
}

install_gh_cli() {
  type -p curl >/dev/null || sudo apt install curl -y
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg &&
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg &&
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null &&
    sudo apt update &&
    sudo apt install gh -y
}

install_dasel() {
  sudo mkdir /opt/bin
  curl -o /opt/bin/dasel -sSfL https://github.com/TomWright/dasel/releases/latest/download/dasel_linux_amd64
  sudo chmod +x /opt/bin/dasel
}

install_jetbrains_toolbox() {
  filename=jetbrains-toobox
  url=$(curl -sSF -G "https://data.services.jetbrains.com/products/releases" -d "code=TBA" -d "latest=true" | dasel -r json "TBA.[0].downloads.linux.link" | tr -d '"')
  curl -o $filename -fsSL "$url"
  tar xf $filename --strip-components 1
  sudo mv $filename /opt/bin/filename
}

install_virtualbox() {
  curl -fsS https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmor --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
  sudo apt update && sudo apt install virtualbox-6.1 -y
}

install_vagrant() {
  curl -fsS https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor --yes --output /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
  sudo apt update && sudo apt install vagrant
}

install_nordvpn() {
  sh <(curl -sSf https://downloads.nordcdn.com/apps/linux/install.sh)
  usermod -aG nordvpn "$USER"
}

install_flyctl() {
  curl -L https://fly.io/install.sh | sh
}

clean_up() {
  sudo apt remove apport apport-system
  sudo apt autoremove -y
  snap remove firefox snap-store
  sudo apt purge snapd
}

main() {
  # Grant permissions for docker process and file levels
  sudo chmod a+rwx /var/run/docker.sock
  sudo chmod a+rwx /var/run/docker.pid

  get_ubuntu_config_files
  install_brave
  install_dasel
  install_flatpak_apps
  install_fira_code_font
  install_flyctl
  install_gh_cli
  install_nordvpn
  install_jetbrains_toolbox
  install_vagrant
  install_virtualbox

  clean_up

  curl -fsS https://raw.githubusercontent.com/3pwd/3pwd/master/configs/ubuntu/apt | sudo xargs apt install -y
  sudo update-alternatives --config x-terminal-emulator

  echo "###### REBOOTING IN 5S #######"
  sleep 5
  reboot
}

main "$@"
