#!/bin/bash

# Get the absolute path of the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. $SCRIPT_DIR/../utils.sh

filename=$(basename "$BASH_SOURCE")
pkg_name="${filename%.*}"

if ask_yes_no "Do you want to install $pkg_name?"; then
    printf "\n"
    info "===================="
    sudo_checkers apt-get install qemu-guest-agent -y
    info "===================="
fi