#!/bin/bash

# Get the absolute path of the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. $SCRIPT_DIR/../utils.sh

filename=$(basename "$BASH_SOURCE")
pkg_name="${filename%.*}"

printf "\n"
info "===================="
info "Install $pkg_name..."
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
sudo_checkers "mv $HOME/.local/bin/zoxide /usr/local/bin"
success "$pkg_name installed"
info "===================="