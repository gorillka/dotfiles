#!/bin/bash

# Get the absolute path of the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. $SCRIPT_DIR/utils.sh

register_keyboard_shortcuts() {
    # Register CTRL+/ keyboard shortcut to avoid system beep when pressed
    info "Registering keyboard shortcuts..."
    mkdir -p "$HOME/Library/KeyBindings"
    cat >"$HOME/Library/KeyBindings/DefaultKeyBinding.dict" <<EOF
{
 "^\U002F" = "noop";
}
EOF
}

apply_osx_system_defaults() {
    info "Applying OSX system defaults..."

    # Set the default view style for folders without custom setting
    defaults write com.apple.finder "FXPreferredViewStyle" -string "Nlsv"

    # Keep folders on top when sorting by name
    defaults write com.apple.finder "_FXSortFoldersFirst" -bool "true"

    # Set whether folders shown in the Finder open in a new tab or
    # a new window when using ⌘ cmd+double-click, and which option is shown in the context menu.
    defaults write com.apple.finder "FinderSpawnTab" -bool "false"

    # Empty bin items after 30 days
    defaults write com.apple.finder "FXRemoveOldTrashItems" -bool "true"

    # Enable key repeats
    defaults write -g ApplePressAndHoldEnabled -bool false

    # Enable three finger drag
    defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true

    # Disable prompting to use new exteral drives as Time Machine volume
    defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

    # Hide external hard drives on desktop
    # defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false

    # Hide hard drives on desktop
    defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false

    # Hide removable media hard drives on desktop
    # defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

    # Hide mounted servers on desktop
    # defaults write com.apple.finder ShowMountedServersOnDesktop -bool false

    # Hide icons on desktop
    defaults write com.apple.finder CreateDesktop -bool false

    # Avoid creating .DS_Store files on network volumes
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

    # Show path bar
    defaults write com.apple.finder ShowPathbar -bool true

    # Show hidden files inside the finder
    defaults write com.apple.finder "AppleShowAllFiles" -bool true

    # Show Status Bar
    defaults write com.apple.finder "ShowStatusBar" -bool true

    # Do not show warning when changing the file extension
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

    # Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
    defaults write com.apple.screencapture type -string "png"

    # Change the default location of screenshots
    defaults write com.apple.screencapture location ~/Downloads

    # Set weekly software update checks
    # defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 7

    # Spaces span all displays
    defaults write com.apple.spaces "spans-displays" -bool false

    # Do not rearrange spaces automatically
    defaults write com.apple.dock "mru-spaces" -bool false

    # Choose the size of Finder sidebar icons
    defaults write NSGlobalDomain "NSTableViewDefaultSizeMode" -int 3

    # Set Dock autohide
    defaults write com.apple.dock "orientation" -string "left"
    defaults write com.apple.dock autohide -bool true
    defaults write com.apple.dock "tilesize" -float 64
    defaults write com.apple.dock "autohide-time-modifier" -float 1.5
    defaults write com.apple.dock "autohide-delay" -float 0
    defaults write com.apple.dock "show-recents" -bool "true"
    defaults write com.apple.dock "show-recent-count" -int 8
    defaults write com.apple.dock "minimize-to-application" -bool false
    defaults write com.apple.dock "scroll-to-open" -bool "true"

    # Rectangle
    # defaults write com.knollsoft.Rectangle curtainChangeSize -int 2
    defaults write com.knollsoft.Rectangle almostMaximizeHeight -float 1
    defaults write com.knollsoft.Rectangle almostMaximizeWidth -float 0.85

    # Rectangle custom window size with Shift + Alt + Ctrl + Cmd + N
    # defaults write com.knollsoft.Rectangle specified -dict-add keyCode -float 45 modifierFlags -float 1966379
    # defaults write com.knollsoft.Rectangle specifiedHeight -float 1055
    # defaults write com.knollsoft.Rectangle specifiedWidth -float 1876

    killall Dock
}

if [ "$(basename "$0")" = "$(basename "${BASH_SOURCE[0]}")" ]; then
    register_keyboard_shortcuts
    apply_osx_system_defaults
fi
