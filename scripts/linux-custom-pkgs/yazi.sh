# #!/bin/bash

# # Get the absolute path of the directory where the script is located
# SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# . $SCRIPT_DIR/../utils.sh

# filename=$(basename "$BASH_SOURCE")
# pkg_name="${filename%.*}"
# target_dir=/tmp/$pkg_name

# update_yazi_packages() {
#     info "Updating Linux packages..."
#     sudo_checkers "apt install -y gcc make ffmpeg 7zip jq poppler-utils ripgrep imagemagick"
#     success "Success"
# }

# setup_rust() {
#     info "Setup Rust toolchain..."
#     curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
#     success "Success"
# }

# install_yazi() {
#     info "Install $pkg_name..."
#     git clone https://github.com/sxyazi/yazi.git $target_dir
#     cd $target_dir
#     export PATH="$HOME/.cargo/bin:$PATH"
#     cargo build --release --locked
#     sudo_checkers "mv target/release/yazi target/release/ya /usr/local/bin/"
#     success "$pkg_name installed"
# }

# clean_yazi() {
#     info "Cleaning $pkg_name..."
#     sudo_checkers "rm -rf $target_dir"
#     sudo_checkers "rm -rf $HOME/.restup"
#     sudo_checkers "rm -rf $HOME/.cargo"
#     rustup self uninstall -y
#     sudo_checkers "apt remove -y gcc make"
#     success "Cleaned"
# }

# if [ "$(basename "$0")" = "$(basename "${BASH_SOURCE[0]}")" ]; then
#     printf "\n"
#     info "===================="
#     case $1 in
#         -c|--clean)
#             clean_yazi
#             ;;
#         *)
#             update_yazi_packages
#             setup_rust
#             install_yazi
#             ;;
#     esac
#     info "===================="
# fi