# Grant permissions for docker process and file levels
sudo chmod a+rwx /var/run/docker.sock
sudo chmod a+rwx /var/run/docker.pid

# Flatpak
sudo apt install flatpak -y
sudo apt install gnome-software-plugin-flatpak -y
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# GitHub CLI
type -p curl >/dev/null || sudo apt install curl -y
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg &&
	sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg &&
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null &&
	sudo apt update &&
	sudo apt install gh -y

# Dasel
sudo mkdir /opt/bin
curl -o /opt/bin/dasel -sSfL https://github.com/TomWright/dasel/releases/latest/download/dasel_linux_amd64
sudo chmod +x /opt/bin/dasel

# Jetbrains Toolbox App
filename=jetbrains-toobox
url=$(curl -sSF -G "https://data.services.jetbrains.com/products/releases" -d "code=TBA" -d "latest=true" | dasel -r json "TBA.[0].downloads.linux.link" | tr -d '"')
curl -o $filename -fsSL "$url"
tar xf $filename --strip-components 1
sudo mv $filename /opt/bin/filename

# VirtualBox
curl -fsS https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmor --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
sudo apt update && sudo apt install virtualbox-6.1

# Vagrant
curl -fsS https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor --yes --output /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vagrant

# Tresorit
sudo curl -fsSL https://installer.tresorit.com/tresorit_installer.run | sh

# Foundry
curl -L https://foundry.paradigm.xyz | bash
source "$HOME"/.zshrc
foundryup

# NordVPN
sh <(curl -sSf https://downloads.nordcdn.com/apps/linux/install.sh)
usermod -aG nordvpn "$USER"

# Remove crash reporting system
sudo apt remove apport apport-system

# Remove snaps
snap remove firefox snap-store
sudo apt purge snapd

# circom
cd ~/Downloads
git clone https://github.com/iden3/circom.git
cd circom
cargo build --release
cargo install --path circom
cd ~
rm -rf ~/Downloads/circom

# gcloud cli
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt-get update && sudo apt-get install google-cloud-cli google-cloud-sdk-gke-gcloud-auth-plugin

# flyctl
curl -L https://fly.io/install.sh | sh

# Some other tools/utils
sudo apt install -y \
	chrome-gnome-shell \
	gnome-control-center \
	gnome-software \
	gnome-tweaks \
	kubectl \
	ripgreprsync \
	xsel \
	tilix \
	tree \
	unar \
	xdg-desktop-portal-gtk # required to open links in flatpak apps (eg discord chat links)

sudo update-alternatives --config x-terminal-emulator

# Global config files/folders
url="https://raw.githubusercontent.com/3pwd/3pwd/master/configs"

for file in .default-npm-packages .gitignore .npmrc .prettierignore .prettierrc.yaml; do
	curl -o "$HOME/$file" -fsS "$url/common/$file"
done

for file in .gitconfig .zshenv .zshrc; do
	curl -o "$HOME/$file" -fsS "$url/ubuntu/$file"
done

curl -o "$ZSH/custom/alias.zsh" -fsS "$url/ubuntu/alias.zsh"

mkdir ~/.pyenvs

echo "###### REBOOTING IN 5S #######"
sleep 5
reboot
