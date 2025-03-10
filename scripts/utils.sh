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