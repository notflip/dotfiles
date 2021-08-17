### Generate a new SSH key (from Dries's repository)
```
curl https://raw.githubusercontent.com/driesvints/dotfiles/HEAD/ssh.sh | sh -s "<YOUR EMAIL ADDRESS>"
```

### Install
```
bash -c "$(curl -fsSL https://raw.githubusercontent.com/notflip/dotfiles/main/install.sh)"
```

### Manual steps

 - `xcode-select --install`
 - import rectangle config from ./rectangle.json
 - Set your email in git config