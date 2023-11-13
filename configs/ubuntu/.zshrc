zstyle ':omz:update' mode auto      # update automatically without asking
ENABLE_CORRECTION="true"

plugins=(
 asdf
 compresspdfs
 cp
 dotenv
 gcloud
 git
 gh
 history
 kubectl
 sha256
 sudo
 ubuntu # apt aliases
 z
 zsh-syntax-highlighting 
)

source $ZSH/oh-my-zsh.sh

eval "$(starship init zsh)"
