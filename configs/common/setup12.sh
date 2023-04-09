set -o errexit

install_omyzsh() {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}


main() {
  install_omyzsh
}

main "$@"
