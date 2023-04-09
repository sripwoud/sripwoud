# Git
sudo apt install git -y
curl https://github.com/web-flow.gpg | gpg --import

# Zsh
sudo apt install zsh -y
echo "Make zsh default shell"
chsh -s "$(which zsh)"

# Oh My Zsh
echo "Install oh my zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
