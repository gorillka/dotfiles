#!/bin/bash

default_color=$(tput sgr 0)
red="$(tput setaf 1)"
yellow="$(tput setaf 3)"
green="$(tput setaf 2)"
blue="$(tput setaf 4)"

info() {
    printf "%s==> %s%s\n" "$blue" "$1" "$default_color"
}

success() {
    printf "%s==> %s%s\n" "$green" "$1" "$default_color"
}

error() {
    printf "%s==> %s%s\n" "$red" "$1" "$default_color"
}

warning() {
    printf "%s==> %s%s\n" "$yellow" "$1" "$default_color"
}

getCurrentOSType() {
    osType=$(uname)
    case "$osType" in
            "Darwin")
            {
                echo "OSX"
            } ;;
            "Linux")
            {
                # If available, use LSB to identify distribution
                if [ -f /etc/lsb-release -o -d /etc/lsb-release.d ]; then
                    distro=$(gawk -F= '/^NAME/{print $2}' /etc/os-release)
                else
                    distro=$(ls -d /etc/[A-Za-z]*[_-][rv]e[lr]* | grep -v "lsb" | cut -d'/' -f3 | cut -d'-' -f1 | cut -d'_' -f1)
                fi
                echo $distro | tr 'a-z' 'A-Z'
            } ;;
            *)
            {
                error "Unsupported OS, exiting"
                exit 1
            } ;;
    esac
}

update_repository() {
    name=$1
    target_dir=$2

    warning "Repository $name already exists, updating..."
    cd $target_dir
    git checkout master
    git branch backup-branch
    git fetch --all
    git reset --hard origin/main
    git pull
}

install_repository_pkg() {
    pkg_name=$1
    target_dir=$2
    git_url=$3

    printf "\n"
    info "===================="
    if [ -d $target_dir ]; then
        info "Update $pkg_name..."
        update_repository $pkg_name $target_dir
        success "$pkg_name updated"
    else
        info "Install $pkg_name..."
        git clone --depth 1 $git_url $target_dir
        success "$pkg_name installed"
    fi
    info "===================="
}

sudo_checkers() {
    if [ $USER = "root" ]; then
        $1
    else
        sudo --validate
        sudo $1
    fi
}

ask_yes_no() {
    while true; do
        read -rp "$1 (yes/no/y/n): " answer
        case "${answer,,}" in
            yes|y)
                return 0
                ;;
            no|n)
                return 1
                ;;
            *)
                echo "Please answer yes(y) or no(n)."
                ;;
        esac
    done
}