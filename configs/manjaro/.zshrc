export ZSH="$HOME/.oh-my-zsh"

# ZSH_THEME=""

plugins=(
  compresspdfs
  cp
  gh
  git
  iphone
  sha256
  sudo
  z
  zsh-autosuggestions
  )

source $ZSH/oh-my-zsh.sh

eval "$(starship init zsh)"
