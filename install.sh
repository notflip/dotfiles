#!/bin/sh

DOTFILES=$HOME/.dotfiles
DOTLOCAL=$HOME/.local/share/dotfiles

echo "Let's get started..."

# Clone this repo
cd "$HOME" || exit
rm -rf "$DOTFILES"
git clone https://github.com/notflip/dotfiles.git "$DOTFILES"
cd "$DOTFILES" || exit

get_linkables() {
    find -H "$DOTFILES" -maxdepth 3 -name '*.symlink'
}

# Setup OhMyZsh
setup_ohmyzsh() {
    if test ! $(which omz); then
        /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
    fi

    git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
    git clone https://github.com/agkozak/zsh-z $ZSH_CUSTOM/plugins/zsh-z
    git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
}

# Setup XCode
setup_xcode() {
    echo "Installing Command Line Developer Tools if not installed"
    if ! [ -d /Library/Developer/CommandLineTools ]; then
        echo "Please, click on Install & Agree to accept the Command Line Developer Tools License Agreement"
        sleep 1
        xcode-select --install
        read -rp "Press enter once the installation finishes" not_needed_param
    else
        echo "Command Line Developer Tools are already installed!"
    fi
}


# Setup Homebrew and brewfile
setup_homebrew() {
    echo "- Setting up Homebrew"

    if test ! "$(command -v brew)"; then
        echo "Homebrew not installed. Installing."
        # Run as a login shell (non-interactive) so that the script doesn't pause for user input
        curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash --login
    else
        echo "Homebrew is already installed!"
    fi

    # install brew dependencies from Brewfile
    brew bundle --file="$DOTFILES/brew/Brewfile" || true
    brew cleanup
}

# Setup Shell
setup_shell() {
    echo "- Setting default shell to zsh"

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

# Go
setup_ohmyzsh
setup_xcode
setup_homebrew
setup_shell

# ZSH Plugins
echo "- Installing ZSH plugins"

rm -rf $DOTLOCAL

ZSHPLUGS=(
  "zsh-completions"
  "zsh-syntax-highlighting"
)

for INDEX in ${!ZSHPLUGS[*]}; do
  ZSHPLUG="${ZSHPLUGS[$INDEX]}"
  git clone --depth=1 "https://github.com/zsh-users/$ZSHPLUG.git" "$DOTLOCAL/$ZSHPLUG"
done