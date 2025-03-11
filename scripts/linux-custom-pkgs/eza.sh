#!/bin/bash

# Get the absolute path of the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. $SCRIPT_DIR/../utils.sh

update_eza_packages() {
    info "Updating Linux packages..."
    sudo_checkers "mkdir -p /etc/apt/keyrings"
    wget -qO /tmp/deb.asc https://raw.githubusercontent.com/eza-community/eza/main/deb.asc
    sudo_checkers "gpg --dearmor -oy /etc/apt/keyrings/gierens.gpg /tmp/deb.asc"
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" > /tmp/gierens.list
    sudo_checkers "mv /tmp/gierens.list /etc/apt/sources.list.d/gierens.list"
    sudo_checkers "chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list"
    sudo_checkers "apt update"
}

install_eza() {
    info "Install eza..."
    sudo_checkers "apt install -y eza"
}

if [ "$(basename "$0")" = "$(basename "${BASH_SOURCE[0]}")" ]; then
    update_eza_packages
    install_eza
fi