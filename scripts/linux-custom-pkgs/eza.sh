#!/bin/bash

# Get the absolute path of the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. $SCRIPT_DIR/../utils.sh

filename=$(basename "$BASH_SOURCE")
pkg_name="${filename%.*}"

update_eza_packages() {
    info "Setuping Linux packages..."
    sudo_checkers "mkdir -p /etc/apt/keyrings"
    sudo_checkers "rm -rf /etc/apt/keyrings/gierens.gpg"
    wget -qO /tmp/deb.asc https://raw.githubusercontent.com/eza-community/eza/main/deb.asc
    sudo_checkers "gpg --dearmor -o /etc/apt/keyrings/gierens.gpg /tmp/deb.asc"
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" > /tmp/gierens.list
    sudo_checkers "mv /tmp/gierens.list /etc/apt/sources.list.d/gierens.list"
    sudo_checkers "chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list"
    sudo_checkers "apt update"
    success "Success"
}

install_eza() {
    info "Install $pkg_name..."
    sudo_checkers "apt install -y $pkg_name"
    success "$pkg_name installed"
    info "Update $pkg_name..."
    sudo_checkers "apt upgrade -y $pkg_name"
    success "$pkg_name updated"
}

clean_eza() {
    info "Cleaning packages..."
    sudo_checkers "rm -rf /tmp/deb.asc"
    sudo_checkers "rm -rf /tmp/gierens.list"
    success "Success"
}

if [ "$(basename "$0")" = "$(basename "${BASH_SOURCE[0]}")" ]; then
    printf "\n"
    info "===================="
    case $1 in
        -c|--clean)
            clean_eza
            ;;
        *)
            update_eza_packages
            install_eza
            ;;
    esac
    info "===================="
fi