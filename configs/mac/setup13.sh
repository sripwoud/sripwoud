set -o errexit

install_homebrew() {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # will especially install git
  curl -fsS https://raw.githubusercontent.com/sripwoud/sripwoud/main/configs/mac/brew | xargs brew install
}
main() {
  install_homebrew
  sudo curl -fsS https://raw.githubusercontent.com/sripwoud/sripwoud/master/configs/common/setup.sh | sh
}

main "$@"
