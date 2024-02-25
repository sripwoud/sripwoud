export ASDF_DIR=~/.config/asdf
export DOOMDIR=~/.config/doom
export EDITOR=emacs
export GPG_TTY=$(tty)
export PATH=~/.config/emacs/bin:$PATH
# need to enable gcr-ssh-agent too: systemctl --user enable --now gcr-ssh-agent.socket
# all ssh keys in ~/.ssh will be added automatically, no need to ssh-add ~/.ssh/mykey mnanually
export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/gcr/ssh
export ZDOTDIR=~/.config/zsh

