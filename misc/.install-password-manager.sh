#!/bin/sh

# exit immediately if password-manager-binary is already in $PATH
type bw >/dev/null 2>&1 && exit

source $(dirname "${BASH_SOURCE[0]}")/.helper.sh

__get_latest_version() {
    local latestVersion
    if command -v curl >/dev/null 2>&1; then
        latestVersion="$(curl -sL https://api.github.com/repos/bitwarden/clients/releases | grep '"tag_name": "cli-v' -m 1 | cut -d'"' -f4 | cut -d v -f2)"
    elif command -v wget >/dev/null 2>&1; then
        latestVersion="$(wget -qO https://api.github.com/repos/bitwarden/clients/releases | grep '"tag_name": "cli-v' -m 1 | cut -d'"' -f4 | cut -d v -f2)"
    else
        echo "Unable to find curl or wget."
        exit 1
    fi

    echo "$latestVersion"
}

__get_latest_version_path() {
    local latestVersion=$1
    local sourceUrl
    case "$(uname -s)" in
        Darwin)
            sourceUrl="https://github.com/bitwarden/clients/releases/download/cli-v${latestVersion}/bw-macos-${latestVersion}.zip"
            ;;
        Linux)
            sourceUrl="https://github.com/bitwarden/clients/releases/download/cli-v${latestVersion}/bw-linux-${latestVersion}.zip"
            ;;
        *)
            echo "unsupported OS"
            exit 1
            ;;
        esac

    echo "$sourceUrl"
}

install_latel_version() {
    local latestVersion=$(__get_latest_version)
    local sourceUrl=$(__get_latest_version_path $latestVersion)
    local tmpDir=/tmp
    local name="${tmpDir}/bw-${latestVersion}.zip"

    if [ ! -f "$name" ]; then
        if command -v curl >/dev/null 2>&1; then
            curl -Lo $name $sourceUrl
        elif command -v wget >/dev/null 2>&1; then
            wget -p $name $sourceUrl
        else
            echo "Unable to find curl or wget."
            exit 1
        fi
    fi

    tar -xzf $name -C $tmpDir
    $SUDO install ${tmpDir}/bw /usr/local/bin
    rm $tmpDir/bw*
}

install_latel_version
