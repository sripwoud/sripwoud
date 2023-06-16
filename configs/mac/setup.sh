set -e

main() {
  for i in {1..3}; do
    curl -fsS https://raw.githubusercontent.com/sripwoud/sripwoud/master/configs/mac/setup"$i"3.sh | sh
  done
}

main "$@"
