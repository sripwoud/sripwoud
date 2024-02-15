export ZSH="$HOME/.oh-my-zsh"

# ZSH_THEME=""

plugins=(
  asdf
  compresspdfs
  cp
  dotenv
  gh
  git
  iphone
  sha256
  sudo
  ubuntu
  z
  zsh-autosuggestions
  zsh-syntax-highlighting
  )

source $ZSH/oh-my-zsh.sh

eval "$(starship init zsh)"
