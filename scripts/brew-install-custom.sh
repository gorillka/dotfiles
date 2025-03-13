#!/bin/bash

# Get the absolute path of the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. $SCRIPT_DIR/utils.sh

# Paths to the custom formulae and casks directories
FORMULAE_DIR="$SCRIPT_DIR/../dependencies/custom-formulae"
CASKS_DIR="$SCRIPT_DIR/../dependencies/custom-casks"

install_custom() { # Function to install custom formulas and casks
    package_name=$1
    is_cask=$2

    if $is_cask && [ -f "$CASKS_DIR/$package_name.rb" ]; then
        info "Installing custom cask: $package_name"
        brew install --force --cask "$CASKS_DIR/$package_name.rb"
    elif ! $is_cask && [ -f "$FORMULAE_DIR/$package_name.rb" ]; then
        info "Installing custom formula: $package_name"
        brew install "$FORMULAE_DIR/$package_name.rb"
    else
        error "File not found for package: $package_name"
        exit 1
    fi
}

show_install_custom_formulae_options() {
    info "Select an option:"
    echo "1) All"
    echo "2) One by one"
    echo "3) Skip"
}

read_install_custom_formulae_choice() {
    read -p "Pick an option (a number): " choice

    if ! [[ $choice =~ ^[0-9]+$ ]]; then
        warning "Please enter a valid option (a number)"
        read_install_custom_formulae_choice
    fi
}

handle_install_custom_formulae_choice() {
    custom_formulae=$1
    is_cask=$3

    case $choice in
        1)
            for formula in ${custom_formulae[@]}; do
                install_custom $formula $is_cask
            done
            ;;
        2)
        for formula in ${custom_formulae[@]}; do
            read -p "Install $formula? [y/n] " install

            if [ "$install" == "y" ]; then
                install_custom $formula $is_cask
            fi
        done
            ;;
        3)
            warning "Skiping..."
            ;;
        *)
            warning "Invalid option, please try again"
            show_install_custom_formulae_options
            read_install_custom_formulae_choice
            handle_install_custom_formulae_choice
            ;;
    esac
}

install_custom_module() {
    dir=$1
    is_cask=$2

    # Get the list of custom formulae from FORMULAe_DIR
    custom_module=()
    if [ -d "$dir" ]; then
        for file in "$dir"/*.rb; do
            [ -e "$file" ] || continue
            custom_module+=("$(basename "${file%.rb}")")
        done
    fi

    len=${#custom_module[@]}
    if [ $len -gt 0 ]; then
        if $is_cask; then
            info "List of custom casks:"
        else
            info "List of custom formulae:"
        fi

        formulae_count=1
        for formula in "${custom_module[@]}"; do
            echo "$formulae_count) $formula"
            formulae_count=$((formulae_count+1))
        done

        show_install_custom_formulae_options
        read_install_custom_formulae_choice
        handle_install_custom_formulae_choice $custom_module $is_cask
    fi
}

install_custom_formulae() {
    # Get the list of custom formulae from FORMULAe_DIR
    install_custom_module $FORMULAE_DIR false
}

install_custom_casks() {
    # Get the list of custom casks from CASKS_DIR
    install_custom_module $CASKS_DIR true
}

run_brew_bundle() {
    brewfile="$SCRIPT_DIR/../dependencies/Brewfile"
    if [ -f $brewfile ]; then
        # Run `brew bundle check`
        local check_output
        check_output=$(brew bundle check --file="$brewfile" 2>&1)

        # Check if "The Brewfile's dependencies are satisfied." is contained in the output
        if echo "$check_output" | grep -q "The Brewfile's dependencies are satisfied."; then
            warning "The Brewfile's dependencies are already satisfied."
        else
            info "Satisfying missing dependencies with 'brew bundle install'..."
            brew bundle install --file="$brewfile"
        fi
    else
        error "Brewfile not found"
        return 1
    fi
}

if [ "$(basename "$0")" = "$(basename "${BASH_SOURCE[0]}")" ]; then
    # Check if Homebrew is installed
    if ! command -v brew &>/dev/null; then
        error "Homebrew is not installed. Please install Homebrew first."
        exit 1
    fi
    install_custom_formulae
    install_custom_casks

    read -p "Install Brew bundle? [y/n] " install_bundle

    if [[ "$install_bundle" == "y" ]]; then
        run_brew_bundle
    fi
fi
