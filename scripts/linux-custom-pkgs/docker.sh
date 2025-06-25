#!/bin/bash

# Get the absolute path of the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. $SCRIPT_DIR/../utils.sh

target_dir=/tmp/$pkg_name
filename=$(basename "$BASH_SOURCE")
pkg_name="${filename%.*}"

install_lazydocker() {
    # allow specifying different destination directory
    DIR="${DIR:-"/usr/local/bin"}"

    # map different architecture variations to the available binaries
    ARCH=$(uname -m)
    case $ARCH in
        i386|i686) ARCH=x86 ;;
        armv6*) ARCH=armv6 ;;
        armv7*) ARCH=armv7 ;;
        aarch64*) ARCH=arm64 ;;
    esac

    # prepare the download URL
    GITHUB_LATEST_VERSION=$(curl -L -s -H 'Accept: application/json' https://github.com/jesseduffield/lazydocker/releases/latest | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')
    GITHUB_FILE="lazydocker_${GITHUB_LATEST_VERSION//v/}_$(uname -s)_${ARCH}.tar.gz"
    GITHUB_URL="https://github.com/jesseduffield/lazydocker/releases/download/${GITHUB_LATEST_VERSION}/${GITHUB_FILE}"

    # install/update the local binary
    curl -L -o lazydocker.tar.gz $GITHUB_URL
    tar xzvf lazydocker.tar.gz lazydocker
    sudo_checkers "install -Dm 755 lazydocker -t "$DIR""
    sudo_checkers "rm lazydocker lazydocker.tar.gz"
}

install_docker() {
    printf "\n"
    info "===================="
    sh <(curl -sSL https://get.docker.com)
    LATEST=$(curl -sL https://api.github.com/repos/docker/compose/releases/latest | grep '"tag_name":' | cut -d'"' -f4)
    DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
    mkdir -p $DOCKER_CONFIG/cli-plugins
    curl -sSL https://github.com/docker/compose/releases/download/$LATEST/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
    chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
    install_lazydocker
    info "===================="
}

if command -v docker >/dev/null 2>&1; then
    success "Docker already install."
    if command -v lazydocker >/dev/null 2>&1; then
        success "lazydocker already install."
    else
        if ask_yes_no "Do you want to install lazydocker?"; then
            install_lazydocker
        fi
    fi
else
    if ask_yes_no "Do you want to install $pkg_name?"; then
        install_docker
    fi
fi