export ZDOTDIR=~/.config/zsh
export PATH="/opt/bin:$PATH"
# need to enable gcr-ssh-agent: systemctl --user enable --now gcr-ssh-agent.socket
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"

export PNPM_HOME="$HOME/username/.local/share/pnpm"
export IMMICH_CONFIG_DIR="$HOME/.config/immich"

# export PATH="/opt/bin:$PATH:/home/username/.foundry/bin"
#
# case ":$PATH:" in
#   *":$PNPM_HOME:"*) ;;
#   *) export PATH="$PNPM_HOME:$PATH" ;;
# esac