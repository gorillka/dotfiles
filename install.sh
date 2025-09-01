#!/usr/bin/env bash
#### SkyLab Helper Installation Script by ####
#### Gorilka (https://github.com/gorillka) ####

# Clear screen and pause briefly for user experience
# clear && sleep 1

source <(curl -fsSL https://raw.githubusercontent.com/gorillka/dotfiles/refs/heads/${PROFILE}/misc/core.func)
load_core_func

source <(curl -fsSL https://raw.githubusercontent.com/gorillka/dotfiles/refs/heads/${PROFILE}/misc/msg.func)

source <(curl -fsSL https://raw.githubusercontent.com/gorillka/dotfiles/refs/heads/${PROFILE}/misc/build.func)
load_build_func

source <(curl -fsSL https://raw.githubusercontent.com/gorillka/dotfiles/refs/heads/${PROFILE}/misc/install.func)
pre_install
