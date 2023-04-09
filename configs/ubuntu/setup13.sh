set -e

main() {
  sudo apt install git -y
  sudo apt install zsh -y
  chsh -s "$(which zsh)"
}

main "$@"
