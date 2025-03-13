#!/bin/bash

# Get the absolute path of the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. $SCRIPT_DIR/utils.sh
. $SCRIPT_DIR/brew-install-custom.sh

update_macOS_system_defaults() {
    printf "\n"
    info "===================="
    info "OSX System Defaults"

    ./$SCRIPT_DIR/osx-defaults.sh

    info "Adding .hushlogin file to suppress 'last login' message in terminal..."
    touch ~/.hushlogin
    info "===================="
}

run_mas_apps() {
    # Check if mas is installed
    if ! command -v mas &>/dev/null; then
        error "mas is not installed. Please install mas first."
        exit 1
    fi

    mas_file="$SCRIPT_DIR/../dependencies/mas-apps"
    if [ ! -f $mas_file ]; then
        error "masidfile not found"
        return 1
    fi

    info "Installing App Store apps..."
    while read -r line; do
        mas_info=$(mas info $line)
        info "Installing..."
        echo $mas_info
        mas install $line
        success "Installed"
    done < "$mas_info"
}

if [ "$(basename "$0")" = "$(basename "${BASH_SOURCE[0]}")" ]; then
    run_brew_bundle
    run_mas_apps
    update_macOS_system_defaults
fi