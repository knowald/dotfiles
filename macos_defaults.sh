#!/bin/bash
# macOS system defaults. Review before running - changes are system-wide.
# Apply with `./macos_defaults.sh` or `just defaults`. Some settings need a
# logout/restart to take effect. Affected apps are restarted at the end.
set -e

echo "Applying macOS defaults..."

# ===================
# Keyboard
# ===================
# Fast key repeat (lower is faster); disable press-and-hold accent popup
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 15
defaults write -g ApplePressAndHoldEnabled -bool false
# Disable automatic text "corrections" that get in the way of code
defaults write -g NSAutomaticCapitalizationEnabled -bool false
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

# ===================
# Finder
# ===================
defaults write com.apple.finder AppleShowAllExtensions -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"  # search current folder
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# Do not write .DS_Store on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# ===================
# Screenshots
# ===================
mkdir -p "$HOME/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Screenshots"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true

# ===================
# Dock
# ===================
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock mru-spaces -bool false  # do not auto-rearrange Spaces

# ===================
# Trackpad
# ===================
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write -g com.apple.mouse.tapBehavior -int 1

# ===================
# Misc UI
# ===================
# Expand save and print panels by default
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
defaults write -g PMPrintingExpandedStateForPrint -bool true
# Save to disk (not iCloud) by default
defaults write -g NSDocumentSaveNewDocumentsToCloud -bool false

echo "Restarting affected apps..."
for app in Finder Dock SystemUIServer; do
    killall "$app" >/dev/null 2>&1 || true
done

echo "Done. Some changes require a logout or restart to fully apply."
