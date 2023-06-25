## Setup
- Linux (Ubuntu/Debian)
   ```shell
   curl https://raw.githubusercontent.com/sripwoud/sripwoud/master/configs/ubuntu/setup.sh | sh
   ```
- MacOS:
   ```shell
   curl https://raw.githubusercontent.com/sripwoud/sripwoud/master/configs/common/setup.sh | sh &&\
   curl https://raw.githubusercontent.com/sripwoud/sripwoud/master/configs/mac/setup.sh | sh
   ```

1. Config git
2. [zsh](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)
3. [oh my zsh](https://github.com/ohmyzsh/ohmyzsh#basic-installation)  
  Plugins:  
    - [fira code font ligatures](https://github.com/tonsky/FiraCode/wiki/Linux-instructions#installing-with-a-package-manager)
    - [spaceship prompt](https://github.com/spaceship-prompt/spaceship-prompt#-installation)
    - [zsh syntax highlighting](https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md#oh-my-zsh)
    - [asdf](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/asdf#installation)
      - Configure Iterm2: settings > profile > text > font > fira code
      - Configure PyCharm: settings > editor > font > fira code. Enable ligatures.
4. [Brave](https://brave.com/linux/#debian-ubuntu-mint)
5. [Rust](https://www.rust-lang.org/tools/install): `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`  
   (Linux only) Install deps (GNU Compiler Collection, [openSSL]([openSSL](https://docs.rs/openssl/latest/openssl/#automatic)) required to build/install common crates (eg [sqlx-cli](https://github.com/launchbadge/sqlx/tree/main/sqlx-cli)):  
   `sudo apt install build-essential pkg-config libssl-dev`
6. [Docker](https://docs.docker.com/engine/install/ubuntu/)  
   Post install:
     - [add `$USER` to `docker` group](https://docs.docker.com/engine/install/linux-postinstall/)
     - [Grant permissions for process and file levels](https://intellij-support.jetbrains.com/hc/en-us/community/posts/360000172139-Docker-Unix-TCP-socket-with-unix-var-run-docker-sock-Permission-Denied)
7. [Flatpak](https://flatpak.org/setup/Ubuntu)
8. [GitHub CLI](https://github.com/cli/cli/blob/trunk/docs/install_linux.md)
9. Install [Dasel](https://github.com/TomWright/dasel)
10. [PyCharm](https://www.jetbrains.com/pycharm/download)  
    Install with [Jetbrains Toolbox App](https://www.jetbrains.com/de-de/toolbox-app/)
11. [Tresorit](https://tresorit.com/de/download)
     Need to install fuse manually: `sudo apt install fuse libfuse2`
12. Replace ubuntu software center by gnome center 
13. Make tilix default terminal
14. Restart
15. (After restart) Install flatpak apps
    - Discord
    - Spotify
    - Tutanota
    - DejaDup
16. Add gpg key
   ```shell
   gh auth refresh -s write:gpg_key
   gpg --armor --export mw@sripwoud.xyz | gh gpg-key add
   ```

