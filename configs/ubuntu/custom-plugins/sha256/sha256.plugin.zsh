sha256() {
  error() {
    printf "%s\n" "$*"
  }

  local checksum="$1"
  local file_path="$2"

  [[ "$#" == 2 && "$checksum" =~ ^[[:alnum:]]+$ ]] || error "Usage: ${0##*/} <checksum> <path/to/file>"
  printf '%s %s\n' "$checksum" "$file_path" | sha256sum --check

}
