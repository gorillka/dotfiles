#!/bin/bash

# Get the absolute path of the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. $SCRIPT_DIR/utils.sh

install_bootstrap_pkg() {
    for script in $SCRIPT_DIR/bootstrap/*.sh; do
        if [ -f $script ]; then
            chmod +x $script
            $script
        fi
    done
}

install_linux_pkgs() {
    chmod +x $SCRIPT_DIR/linux-install.sh
    $SCRIPT_DIR/linux-install.sh
}

install_osx_pkgs() {
    info "OSX test"
}

install_os_specific_pkgs() {
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
}

post_install() {
    chsh -s $(which zsh)
    exec zsh
}

update_symlinks() {
    printf "\n"
    info "===================="
    info "Symbolic Links"
    info "===================="

    chmod +x $SCRIPT_DIR/symlinks.sh
    $SCRIPT_DIR/symlinks.sh --delete --include-files
    $SCRIPT_DIR/symlinks.sh --create
}

if [ "$(basename "$0")" = "$(basename "${BASH_SOURCE[0]}")" ]; then
    install_bootstrap_pkg
    install_os_specific_pkgs
    update_symlinks
    post_install
fi