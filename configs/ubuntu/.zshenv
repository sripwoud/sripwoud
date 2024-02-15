export ZSH="$HOME/.oh-my-zsh"
export PNPM_HOME="$HOME/username/.local/share/pnpm"
export IMMICH_CONFIG_DIR="$HOME/.config/immich"

export PATH="/opt/bin:$PATH:/home/username/.foundry/bin"

case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"