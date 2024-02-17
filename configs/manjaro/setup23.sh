#!/bin/bash

set -e

install_docker() {
  sudo mkdir -p /etc/apt/keyrings
  # FIXME
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
  sudo apt update
  sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
  # Add $USER to docker group
  sudo usermod -aG docker "$USER"
  newgrp docker

}
main() {
  install_docker
}

main
