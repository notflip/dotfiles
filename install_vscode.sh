#!/bin/bash

echo "- Setup VS Code"

ln -sv $HOME/.dotfiles/vscode/settings.json $HOME/Library/Application\ Support/Code/User/settings.json
ln -sv $HOME/.dotfiles/vscode/keybindings.json $HOME/Library/Application\ Support/Code/User/keybindings.json
ln -sv $HOME/.dotfiles/vscode/snippets/ $HOME/Library/Application\ Support/Code/User/snippets

pkglist=(
auiworks.amvim
christian-kohler.path-intellisense
CoenraadS.bracket-pair-colorizer
dbaeumer.vscode-eslint
GitHub.github-vscode-theme
golf1052.code-sync
k--kato.intellij-idea-keybindings
ms-vscode-remote.remote-ssh
ms-vscode-remote.remote-ssh-edit
vincaslt.highlight-matching-tag
)

for i in ${pkglist[@]}; do
  code --install-extension $i
done