#!/bin/bash

# Get the absolute path of the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. $SCRIPT_DIR/../utils.sh

filename=$(basename "$BASH_SOURCE")
pkg_name="${filename%.*}"

if [ "$(systemd-detect-virt)" = "kvm" ]; then
    printf "\n"
    info "===================="
    if dpkg -l qemu-guest-agent 2>/dev/null | grep -q '^ii'; then
        success "Guest Agent already installed."
    else
        sudo_checkers "apt-get install qemu-guest-agent -y"
    fi
    info "===================="
fi