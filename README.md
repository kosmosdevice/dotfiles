# Dotfiles

Personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Requirements

- [GNU Stow](https://www.gnu.org/software/stow/)
- [Neovim](https://neovim.io/) >= 0.9

## Installation

Clone the repository:

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

Symlink configurations using Stow:

```bash
stow nvim
```

This will create the following symlink:
~/.config/nvim/init.lua -> ~/dotfiles/nvim/.config/nvim/init.lua

## Removing a Configuration

```bash
stow -D nvim
```
