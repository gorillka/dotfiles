#!/bin/bash

target_dir="$HOME/.dotfiles"

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

sudo_checkers() {
    if [ $USER = "root" ]; then
        $1
    else
        sudo --validate
        sudo $1
    fi
}

install_xcode() {
    info "Installing Apple's CLI tools (prerequisites for Git and Homebrew)..."
    if xcode-select -p >/dev/null; then
        warning "xcode is already installed"
    else
        xcode-select --install
        sudo --validate
        sudo xcodebuild -license accept
    fi
}

install_homebrew() {
    info "Installing Homebrew..."
    export HOMEBREW_CASK_OPTS="--appdir=/Applications"
    if hash brew &>/dev/null; then
        warning "Homebrew already installed"
    else
        sudo --validate
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
        echo >> $HOME/.bash_profile
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.bash_profile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
}

osx_prerequisites() {
    install_xcode
    install_homebrew
}

check_os_type() {
    printf "\n"
    info "========================================"
    info "Getting OS type..."
    osType=$(getCurrentOSType)
    success "OS type is $osType"
    info "========================================"
}

debian_prerequisites() {
    info "Update packages..."
    sudo_checkers "apt update"
    info "Upgrade packages..."
    sudo_checkers "apt -y upgrade"
    info "Installe prereauisites..."
    sudo_checkers "apt install -y git"
}

install_prerequisites() {
    printf "\n"
    info "========================================"
    info "Install prerequisites for $osType..."
    info "========================================"

    case $osType in
        "OSX")
            osx_prerequisites
            ;;
        "DEBIAN OS")
            debian_prerequisites
            ;;
        *)
            error "Unsupported OS, exiting"
            exit 1
    esac

    info "========================================"
    success "Prerequisites for $osType installed"
    info "========================================"
}

cloning_repository() {
    printf "\n"
    info "========================================"
    info "Cloning repository..."
    info "========================================"

    if [ ! -d "$target_dir" ]; then
        git clone https://github.com/gorillka/dotfiles.git $target_dir
    else
        warning "Repository dotfiles already exists, updating..."
        cd $target_dir
        git checkout master
        git fetch --all
        git reset --hard origin/master
        git pull
    fi

    info "========================================"
    success "Repository cloned"
    info "========================================"
}

run_bootstrap_script() {
    "${target_dir}/scripts/bootstrap.sh"
}

check_os_type
install_prerequisites
cloning_repository
run_bootstrap_script