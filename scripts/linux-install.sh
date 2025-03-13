#!/bin/bash

# Get the absolute path of the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. $SCRIPT_DIR/utils.sh

install_linux_dependents() {
    printf "\n"
    info "===================="
    info "Install dependent packages..."
    info "===================="

    dependents="$SCRIPT_DIR/../dependencies/pkgs"
    if [ ! -f $dependents ]; then
        error "pkgs file not found: $dependents"
        return 1
    fi

    sudo_checkers "apt install $(grep -vE "^\s*#" $dependents  | tr "\n" " ") -y"

    info "===================="
    success "Dependent packages installed"
    info "===================="
}

run_linux_custom_scripts() {
    for script in $SCRIPT_DIR/linux-custom-pkgs/*.sh; do
        $script $1
    done
}

install_linux_custom_packages() {
    printf "\n"
    info "===================="
    info "Install custom packages..."
    info "===================="
    run_linux_custom_scripts
    info "===================="
    success "Custom packages installed..."
    info "===================="
}

post_install_linux() {
    sudo_checkers "ln -s /usr/bin/batcat /usr/local/bin/bat"
    sudo_checkers "ln -s /usr/lib/cargo/bin/fd /usr/local/bin/fd"
}

linux_clear() {
    run_linux_custom_scripts "-c"
    sudo_checkers "apt -y autoremove"
    sudo_checkers "apt -y autoclean"
}

if [ "$(basename "$0")" = "$(basename "${BASH_SOURCE[0]}")" ]; then
    install_linux_dependents
    install_linux_custom_packages
    post_install_linux
    linux_clear
fi