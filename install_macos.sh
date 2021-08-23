echo "- Applying custom MacOS defaults"

osascript -e 'tell application "System Preferences" to quit'

sudo -v

while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Disable startup chime
sudo nvram SystemAudioVolume=" "

defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

defaults write NSGlobalDomain AppleLanguages -array "en" "nl"
defaults write NSGlobalDomain AppleLocale -string "en_US@currency=EUR"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true
sudo systemsetup -settimezone "Europe/Brussels" > /dev/null

launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null

sudo pmset -a lidwake 1
sudo pmset -a autorestart 1
sudo systemsetup -setrestartfreeze on
sudo pmset -c sleep 0
sudo pmset -b sleep 5
sudo pmset -a standbydelay 86400
sudo pmset -a hibernatemode 0

defaults write com.apple.finder DisableAllAnimations -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist

/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist

defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder WarnOnEmptyTrash -bool false
chflags nohidden ~/Library && xattr -d com.apple.FinderInfo ~/Library

defaults write com.apple.finder FXInfoPanesExpanded -dict \
    General -bool true \
    OpenWith -bool true \
    Privileges -bool true

defaults write -g com.apple.mouse.scaling 13

defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock static-only -bool true
defaults write com.apple.dock launchanim -bool false
defaults write com.apple.dashboard mcx-disabled -bool true
defaults write com.apple.dock dashboard-in-overlay -bool true
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock showhidden -bool true
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock trash-full -boolean true

find "${HOME}/Library/Application Support/Dock" -name "*-*.db" -maxdepth 1 -delete

# Set top right corner to show desktop
defaults write com.apple.dock wvous-tr-corner -int 4
defaults write com.apple.dock wvous-tr-modifier -int 0

defaults write com.apple.terminal StringEncodings -array 4
defaults write com.googlecode.iterm2 PromptOnQuit -bool false
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true
defaults write com.apple.ActivityMonitor IconType -int 5
defaults write com.apple.ActivityMonitor ShowCategory -int 0
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

for app in "Activity Monitor" \
    "Address Book" \
    "Calendar" \
    "cfprefsd" \
    "Contacts" \
    "Dock" \
    "Finder" \
    "Google Chrome Canary" \
    "Google Chrome" \
    "Mail" \
    "Messages" \
    "Opera" \
    "Photos" \
    "Safari" \
    "SizeUp" \
    "Spectacle" \
    "SystemUIServer" \
    "Terminal" \
    "Transmission" \
    "Tweetbot" \
    "Twitter" \
    "iCal"; do
    killall "${app}" &> /dev/null
done

echo "Done. Note that some of these changes require a logout/restart to take effect."