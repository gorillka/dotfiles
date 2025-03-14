#!/bin/bash

# Get the absolute path of the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. $SCRIPT_DIR/../utils.sh

filename=$(basename "$BASH_SOURCE")
pkg_name="${filename%.*}"
target_dir=/tmp/$pkg_name

install_lazygit() {
    if [ -d "$target_dir" ]; then
        rm -rf "${target_dir}/**/*.*"
    else
        mkdir -p $target_dir
    fi

    lazygit_version=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep "tag_name" | awk '{print substr($2, 3, length($2)-4) }')
    case $(uname -m) in
        x86_64|amd64)
            core_arch="x86_64"
            ;;
        arm*|aarch*)
            core_arch="arm64"
            ;;
        *)
            warning "Unknown architecture $(uname -m)"
            exit 1
    esac
    curl -Lo $target_dir/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${lazygit_version}/lazygit_${lazygit_version}_Linux_${core_arch}.tar.gz"
    tar -xzf "${target_dir}/lazygit.tar.gz" -C $target_dir
    sudo_checkers "install $target_dir/lazygit -D -t /usr/local/bin"
    sudo_checkers "rm -rf $target_dir"
}

if [ "$(basename "$0")" = "$(basename "${BASH_SOURCE[0]}")" ]; then
    printf "\n"
    info "===================="
    info "Installing $pkg_name..."
    install_lazygit
    success "$pkg_name installed"
    info "===================="
fi