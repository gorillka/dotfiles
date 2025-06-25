#!/bin/bash

if docker info > /dev/null 2>&1; then
    printf "\n"
    info "===================="
    curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
    info "===================="
fi