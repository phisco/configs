# Dotfiles

This repository contains my dotfiles and configurations. It is managed using
[GNU Stow](https://www.gnu.org/software/stow/).

## Installation

```
git clone git@github.com:phisco/configs.git dotfiles
cd dotfiles
# link all dotfiles to the home directory
stow .
```

## Adding a new config file

Use the `stow_add` function (defined in `.zshrc`):

```bash
stow_add ~/.config/app/config.yaml
```

This moves the file to the dotfiles repo and creates the symlink automatically.

Then commit the changes:

```bash
git add .config/app/config.yaml
git commit -m "Add app config"
```

### Notes

- The directory structure in the repo mirrors your home directory structure
- Files listed in `.stow-local-ignore` (like `README.md`, `.git`, `*.bak`) won't be symlinked
- Use `stow -n .` for a dry-run to preview what symlinks will be created
- Use `stow -D .` to remove all symlinks managed by stow
