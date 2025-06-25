#!/bin/bash

# Get the absolute path of the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. $SCRIPT_DIR/../utils.sh

filename=$(basename "$BASH_SOURCE")
pkg_name="${filename%.*}"

if ask_yes_no "Do you want to install $pkg_name?"; then
    printf "\n"
    info "===================="
    sh <(curl -sSL https://get.docker.com)
    LATEST=$(curl -sL https://api.github.com/repos/docker/compose/releases/latest | grep '"tag_name":' | cut -d'"' -f4)
    DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
    mkdir -p $DOCKER_CONFIG/cli-plugins
    curl -sSL https://github.com/docker/compose/releases/download/$LATEST/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
    chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
    info "===================="
fi