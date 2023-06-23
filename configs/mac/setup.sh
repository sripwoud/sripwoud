set -e

main() {
  for i in {1..3}; do
    # TODO: fix, need to DL .zshrc file for mac before running e.g asdf install script so that asdf command is in PATH
    curl -fsS https://raw.githubusercontent.com/sripwoud/sripwoud/master/configs/mac/setup"$i"3.sh | sh
  done
}

main "$@"
