#!/bin/sh

DOTFILES="$HOME/.dotfiles"
DOTLOCAL="$HOME/.local/share/dotfiles"
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

echo "Let's get started..."

# Setup OhMyZsh
if test ! $(which omz); then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/agkozak/zsh-z $ZSH_CUSTOM/plugins/zsh-z
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

chmod 700 ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Setup XCode
echo "Installing Command Line Developer Tools if not installed"
if ! [ -d /Library/Developer/CommandLineTools ]; then
    echo "Please, click on Install & Agree to accept the Command Line Developer Tools License Agreement"
    sleep 1
    xcode-select --install
    read -rp "Press enter once the installation finishes" not_needed_param
else
    echo "Command Line Developer Tools are already installed!"
fi


# Setup Homebrew and brewfile
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


# Setup Shell
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