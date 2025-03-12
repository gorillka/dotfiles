#!/bin/bash

# Get the absolute path of the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. $SCRIPT_DIR/../utils.sh

filename=$(basename "$BASH_SOURCE")
pkg_name="${filename%.*}"
target_dir=/tmp/$pkg_name

update_yazi_packages() {
    info "Updating Linux packages..."
    sudo_checkers "apt install -y gcc make ffmpeg 7zip jq poppler-utils ripgrep imagemagick"
}

setup_rust() {
    info "Setup Rust toolchain..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
}

install_yazi() {
    info "Install yazi..."
    git clone https://github.com/sxyazi/yazi.git $target_dir
    cd $target_dir
    export PATH="$HOME/.cargo/bin:$PATH"
    cargo build --release --locked
    sudo_checkers "mv target/release/yazi target/release/ya /usr/local/bin/"
}

clear_yazi() {
    sudo_checkers "rm -rf $target_dir"
    rustup self uninstall -y
    sudo_checkers "apt remove -y gcc make"
}

if [ "$(basename "$0")" = "$(basename "${BASH_SOURCE[0]}")" ]; then
    update_yazi_packages
    setup_rust
    install_yazi
    clear_yazi
fi