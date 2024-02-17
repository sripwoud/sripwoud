export ZSH="$HOME/.oh-my-zsh"

# zstyle ':omz:update' mode disabled  # disable automatic updates
zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time


ENABLE_CORRECTION="true"

plugins=(
  asdf
  cp
  dotenv
  git
  last-working-dir
  macos
  sudo
  z
  zsh-autosuggestions
  zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# key binds: move cursor not previous/next word
bindkey "^[^[[D" backward-word # ??? + ???
bindkey "^[^[[C" forward-word  # ??? + ???

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/sripwoud/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/sripwoud/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/sripwoud/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/sripwoud/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

eval "$(starship init zsh)"
