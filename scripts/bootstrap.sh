#!/bin/bash

# Get the absolute path of the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. $SCRIPT_DIR/utils.sh

run_bootstrap_scripts() {
    printf "\n"
    info "========================================"
    info "Install bootstrap packages..."
    info "========================================"
    for script in $SCRIPT_DIR/bootstrap/*.sh; do
        if [ -f $script ]; then
            $script $1
        fi
    done
    info "========================================"
    success "Bootstrap packages installed"
    info "========================================"
}

install_linux_pkgs() {
    $SCRIPT_DIR/linux-install.sh
}

install_osx_pkgs() {
    $SCRIPT_DIR/osx-install.sh
}

install_os_specific_pkgs() {
    osType=$(getCurrentOSType)
    printf "\n"
    info "========================================"
    info "Install packages for $osType..."
    info "========================================"
    case $(getCurrentOSType) in
        "OSX")
            install_osx_pkgs
            ;;
        "DEBIAN OS")
            install_linux_pkgs
            ;;
        *)
            ;;
    esac
    info "========================================"
    success "Packages for $osType installed"
    info "========================================"
}

update_symlinks() {
    printf "\n"
    info "===================="
    info "Symbolic Links"
    info "===================="

    cd "$HOME/.dotfiles"
    $SCRIPT_DIR/symlinks.sh -c -d -f -conf "$SCRIPT_DIR/../symlinks.conf"

    info "===================="
    success "Symbolic Links updated"
    info "===================="
}

bootstrap_clean() {
    printf "\n"
    info "===================="
    info "Cleaning..."
    info "===================="
    run_bootstrap_scripts -c
    info "===================="
    success "Cleaned"
    info "===================="
}

post_install() {
    chsh -s $(which zsh)
    exec zsh
}

if [ "$(basename "$0")" = "$(basename "${BASH_SOURCE[0]}")" ]; then
    run_bootstrap_scripts
    install_os_specific_pkgs
    update_symlinks
    bootstrap_clean

    info "===================="
    success "All installed"
    info "===================="

    post_install
fi