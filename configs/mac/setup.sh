set -e

main() {
  for i in {1..3};do
    curl -fsS https://raw.githubusercontent.com/3pwd/3pwd/master/configs/common/setup"$i"3.sh | sh
  done
}

main "$@"
