#!/usr/bin/env bash
#### SkyLab Helper Installation Script by ####
#### Gorilka (https://github.com/gorillka) ####

safe_source() {
    local url="$1"
    local content

    content=$(curl -fsSL "$url")

    if [ $? -eq 0 ]; then
        eval "$content"
    else
        echo "ERROR: $url" >&2
        return 1
    fi
}

# Clear screen and pause briefly for user experience
clear && sleep 1

# Load core functionality functions from remote repository
safe_source "https://raw.githubusercontent.com/gorillka/dotfiles/${PROFILE:-main}/misc/core.func"
safe_source "https://raw.githubusercontent.com/gorillka/dotfiles/${PROFILE:-main}/misc/msg.func"

# Load build-related functions from remote repository
safe_source "https://raw.githubusercontent.com/gorillka/dotfiles/${PROFILE:-main}/misc/build.func"

# Load additional utility functions from remote repository
safe_source "https://raw.githubusercontent.com/gorillka/dotfiles/${PROFILE:-main}/misc/tools.func"
safe_source "https://raw.githubusercontent.com/gorillka/dotfiles/${PROFILE:-main}/misc/install.func"

# Initialize core functions
load_core_func
# Initialize build functions
load_build_func
# # Execute the main installation process
pre_install
