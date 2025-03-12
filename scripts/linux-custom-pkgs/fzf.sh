#!/bin/bash

# Get the absolute path of the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. $SCRIPT_DIR/../utils.sh

filename=$(basename "$BASH_SOURCE")
pkg_name="${filename%.*}"
target_dir=$HOME/.$pkg_name
git_url="https://github.com/junegunn/fzf.git"

install_repository_pkg $pkg_name $target_dir $git_url
$HOME/.fzf/install --no-key-bindings --no-completion --no-update-rc --no-zsh