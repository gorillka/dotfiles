#!/bin/bash

# Get the absolute path of the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. $SCRIPT_DIR/../utils.sh

filename=$(basename "$BASH_SOURCE")
pkg_name="${filename%.*}"
target_dir=$HOME/.local/share/fonts
file_extension="zip"

jetbrains_file_name="${pkg_name}.${file_extension}"

install_fonts() {
    printf "\n"
    info "===================="
    info "Install JetBrains fonts..."
    if ! ls "$target_dir"/"$pkg_name"* 1> /dev/null 2>&1; then
        if [ ! -d $target_dir ]; then
            info "Creating directory: $target_dir"
            mkdir -p "$target_dir"
        fi

        sudo_checkers "rm -rf $target_dir/*$pkg_name*.zi*"

        info "Getting $pkg_name version"
        jetbrains_font_version="$(wget -qO- "https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')"
        info "$jetbrains_font_version"
        wget -P "${target_dir}" "https://github.com/ryanoasis/nerd-fonts/releases/download/${jetbrains_font_version}/${jetbrains_file_name}"
        cd "${target_dir}"
        unzip -o "${jetbrains_file_name}"
        rm "${jetbrains_file_name}"
        fc-cache -fv
    else
        info "JetBrains fonts already installed"
    fi
}

if [ "$(basename "$0")" = "$(basename "${BASH_SOURCE[0]}")" ]; then
    install_fonts
fi

