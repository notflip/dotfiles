#!/bin/sh

DOTFILES=$HOME/.dotfiles
DOTLOCAL=$HOME/.local/share/dotfiles

echo "Let's get started..."

# Clone this repo
cd "$HOME" || exit
rm -rf "$DOTFILES"
git clone git@github.com:joshtronic/dotfiles.git "$DOTFILES"
cd "$DOTFILES" || exit

# Create default folders
mkdir -p $HOME/Code
mkdir -p $HOME/Syncthing

# Setup .symlink files
setup_symlinks() {
    echo "Setting up symlinks"

    for file in find -H "$DOTFILES" -maxdepth 3 -name '*.symlink' ; do
        target="$HOME/.$(basename "$file" '.symlink')"
        if [ -e "$target" ]; then
            echo "~${target#$HOME} already exists... Skipping."
        else
            echo "Creating symlink for $file"
            ln -s "$file" "$target"
        fi
    done
}

# Setup Homebrew and brewfile
setup_homebrew() {
    echo "Setting up Homebrew"

    if test ! "$(command -v brew)"; then
        echo "Homebrew not installed. Installing."
        # Run as a login shell (non-interactive) so that the script doesn't pause for user input
        curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash --login
    fi

    # install brew dependencies from Brewfile
    brew bundle
}

# Setup Shell
setup_shell() {
    echo "Configuring shell"

    [[ -n "$(command -v brew)" ]] && zsh_path="$(brew --prefix)/bin/zsh" || zsh_path="$(which zsh)"
    if ! grep "$zsh_path" /etc/shells; then
        echo "adding $zsh_path to /etc/shells"
        echo "$zsh_path" | sudo tee -a /etc/shells
    fi

    if [[ "$SHELL" != "$zsh_path" ]]; then
        chsh -s "$zsh_path"
        echo "default shell changed to $zsh_path"
    fi
}

# Setup VSCode
setup_vscode() {

    ln -sv $HOME/.dotfiles/vscode/settings.json $HOME/Library/Application\ Support/Code/User/settings.json
    ln -sv $HOME/.dotfiles/vscode/keybindings.json $HOME/Library/Application\ Support/Code/User/keybindings.json
    ln -sv $HOME/.dotfiles/vscode/snippets/ $HOME/Library/Application\ Support/Code/User/snippets

    cat ~/.dotfiles/vscode/extensions | while read extension
    do
        code --install-extension $extension --force
    done
}

# Go
setup_symlinks
setup_homebrew
setup_shell
setup_vscode

# ZSH Plugins
ZSHPLUGS=(
  "zsh-completions"
  "zsh-history-substring-search"
  "zsh-syntax-highlighting"
)

for INDEX in ${!ZSHPLUGS[*]}; do
  ZSHPLUG="${ZSHPLUGS[$INDEX]}"
  git clone --depth=1 "https://github.com/zsh-users/$ZSHPLUG.git" "$DOTLOCAL/$ZSHPLUG"
done

# MacOS Preferences
source ./mac/.macos