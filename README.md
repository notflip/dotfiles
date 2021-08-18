# Miguel's Dotfiles

### Install

1. Setup SSH
```
curl https://raw.githubusercontent.com/driesvints/dotfiles/HEAD/ssh.sh | sh -s "<YOUR EMAIL ADDRESS>"
```

2. Install Main
```
bash -c "$(curl -fsSL https://raw.githubusercontent.com/notflip/dotfiles/main/install.sh)"
```

3. Setup MacOS
`sh ./install_macos.sh

4. Setup Symlinks
`sh ./install_symlinks.sh`

5. Setup VS Code
`sh ./install_vscode.sh`

### Manual steps

 - Import rectangle config from ./rectangle.json
 - Import iterm2 settings using 'Load preferences from a custom folder or URL' from `~/.dotfiles/iterm/com.googlecode.iterm2.plist`
 - Set personal data in ~/.gitconfig.local


### Todo
 - [ ] Add Alfred config and setup